;//
//  CamObj.m
//
#import <sys/time.h>
#import "CamObj.h"
#import "H264iPhone.h"
#import "DelegateCamera.h"
#import "PPCS_API.h"
#import "AVStream_IO_proto.h"
#import "H264iPhone.h"
#import "OpenALPlayer.h"
#import "NSDataWithCameraType.h"
#import "Encryption.h"
#import "HouseModelHandle.h"
#import "JSONKit.h"

#define CHANNEL_DATA 1
#define CHANNEL_IOCTRL 2


#define MAX_SIZE_IOCTRL_BUF   5120    //5K
#define MAX_SIZE_AV_BUF       262144  //256K
#define MAX_SIZE_AUDIO_PCM    3200
#define MAX_SIZE_AUDIO_SAMPLE 640

#define MAX_AUDIO_BUF_NUM     25
#define MIN_AUDIO_BUF_NUM     1

#define DecodeOrEncode_Key @"RUZZI000027HWNVF" //加密解密用的Key

typedef unsigned int UINT;
typedef unsigned char UCHAR;

typedef unsigned char byte;

int  gAPIVer   =0;

@implementation CamObj
@synthesize nRowID, mCamState;
@synthesize m_bRunning, m_bVideoPlaying, m_bAudioDecording;
@synthesize mVideoHeight, mVideoWidth;
@synthesize m_fifoVideo, m_fifoAudio;
@synthesize mLockConnecting;
@synthesize nsCamName, nsDID;
@synthesize m_delegateCam;

#pragma mark -
#pragma mark init and release
- (void) initValue
{
    nRowID    =-1;
    nsCamName =@"";
    nsDID     =@"";
    
    mConnMode=CONN_MODE_UNKNOWN;
    mCamState=CONN_INFO_UNKNOWN;
    
    m_nTickUpdateInfo=0L;
    m_bVideoPlaying  =NO;
    m_bAudioDecording=NO;
    m_bRunning=NO;
    
    mThreadPlayVideo  =nil;
    mThreadDecordAudio=nil;
    mThreadRecvAVData =nil;
    mLockPlayVideo   =nil;
    mLockDecordAudio =nil;
    mLockRecvAVData  =nil;
    
    m_handle    =-1;
    mWaitTime_ms=0L;
    
    mVideoHeight=0;
    mVideoWidth =0;
    
    m_fifoAudio=av_FifoNew();
    m_fifoVideo=av_FifoNew();
    m_nInitH264Decoder=-1;
    
    m_bConnecting=0;
    mLockConnecting=[[NSLock alloc] init];
    
    m_delegateCam = nil;
    
}

- (id)init
{
    if((self = [super init])) [self initValue];
    return self;
}

- (void) releaseObj
{
    [nsCamName release];
    [nsDID release];
    nsCamName=nil;
    nsDID=nil;
    
    if(m_fifoVideo){
        av_FifoRelease(m_fifoVideo);
        m_fifoVideo=NULL;
    }
    if(m_fifoAudio){
        av_FifoRelease(m_fifoAudio);
        m_fifoAudio = NULL;
    }
    
    [mLockConnecting release];
    mLockConnecting=nil;
}
+ (int32_t ) initAPI
{
    //换了接口 需要先判断 再初始化
    NSString *adress = [[[HouseModelHandle shareHouseHandle] currentHouse] address];
    NSString *did = [adress substringToIndex:5];
    
     int32_t ret;
    
    if ([did isEqualToString:@"SLIFE"]) {
        //新的API接口
    char Para[]={"ADHOAFAJPFMPCNNCBIHOBAFHDMNFGJJCHDAGFHCFEAIHOLKFDHADCLPBCJLLMMKBEIJCLDHGPJMLEMCDMGMMNOEIIGLHENDLEDCIHNBOMKKFFMCBBH"};
        
     ret =  PPCS_Initialize(Para);
    }else
    {
         char Para[]={"BIHLBDBIKAJKHJJJAPGJBMFNDGJOGPJIHLEPFKCIFCIBKPKFDFBPHHPBDCLNMMOAAFJOLBDHLNNAFGCBJFNNIIAAIMPMEBCKEPGDDKFJMOOO"};
        
    ret =  PPCS_Initialize(Para);
    
    }
    
    gAPIVer=PPCS_GetAPIVersion();
    
   MYLog(@"gAPIVer=0x%X", gAPIVer);
    
    return ret;
}
+ (void) deinitAPI
{
    PPCS_DeInitialize();
}

+ (NSString *) infoCode2Str:(int)infoCode
{
    //将infoCode转换为字符串
    NSString *result=@"";
    switch(infoCode) {
        case CONN_INFO_NO_NETWORK:
            result=NSLocalizedString(@"Network is not reachable",nil);
            break;
            
        case CONN_INFO_CONNECTING:
            result=NSLocalizedString(@"Connecting...",nil);
            break;
            
        case CONN_INFO_CONNECT_WRONG_DID:
            result=NSLocalizedString(@"Wrong DID",nil);
            break;
            
        case CONN_INFO_CONNECT_WRONG_PWD:
            result=NSLocalizedString(@"Wrong password",nil);
            break;
            
        case CONN_INFO_CONNECT_FAIL:
            result=NSLocalizedString(@"Failed to connect",nil);
            break;
            
        case CONN_INFO_CONNECTED:
            result=NSLocalizedString(@"Connected",nil);
            break;
            
        case STATUS_INFO_SESSION_CLOSED:
            result=NSLocalizedString(@"Disconnected",nil);
            break;
            
        default:
            break;
    }
    return result;
}

#pragma mark - misc function
+ (unsigned long) getTickCount
{
    struct timeval tv;
    if(gettimeofday(&tv, NULL)!=0) return 0;
    return (tv.tv_sec*1000 +tv.tv_usec/1000);
}

-(void) ResetAudioVar
{
    m_nFirstTickLocal_audio=0L;
    m_nTick2_audio=0L;
    m_nFirstTimestampDevice_audio=0L;
    
    av_FifoEmpty(m_fifoAudio);
}

-(void) ResetVideoVar
{
    m_nFirstTickLocal_video=0L;
    m_nTick2_video=0L;
    m_nFirstTimestampDevice_video=0L;
    
    av_FifoEmpty(m_fifoVideo);
    m_bFirstFrame=TRUE;
}

- (BOOL) mayContinue
{
    if(nsDID==nil || [nsDID length]<=0) return NO;
    else return YES;
}

-(int) readDataFromRemote:(int) handleSession withChannel:(unsigned char) Channel withBuf:(char *)DataBuf
             withDataSize: (int *)pDataSize withTimeout:(int)TimeOut_ms
{
    //maybe this is only used in vedio
    INT32 nRet=-1, nTotalRead=0, nRead=0;
    while(nTotalRead < *pDataSize){
        nRead=*pDataSize-nTotalRead;
        if(handleSession>=0) nRet=PPCS_Read(handleSession, Channel,(DataBuf+nTotalRead), &nRead, TimeOut_ms);
        else break;
        nTotalRead+=nRead;
        
        if((nRet != ERROR_PPCS_SUCCESSFUL) && (nRet != ERROR_PPCS_TIME_OUT )) break;
        
        if(!m_bRunning) break;
    }
    //    NSLog(@" readDataFromRemote(.)=%d, *pDataSize=%d\n", nRet, *pDataSize);
    if(nRet<0) *pDataSize=nTotalRead;
    
    return nRet;
}

- (int)readDataWithHandleSession:(int)handleSession {
   
    char  buff[4];
    int a = 4;
    UINT32 timeout = 10000;
    ;
    // 7
    int ret = PPCS_Read(handleSession, 2, buff, &a, timeout);
    
 //   MYLog(@"_____________read:%d 位数 %s",ret , buff);
    
    if (ret == ERROR_PPCS_SUCCESSFUL && buff[0] == '#' && buff[1] == '#') {

        char p = buff[2];
        char q = buff[3];
      //  NSLog(@"ppppp%c",p);
      //  NSLog(@"qqqqq%c",q);
        int zero = 0;
        char x =zero & 0xff;
        char y = zero & 0xff;
        
        //转换高低位
        NSMutableData *receiveData = [[NSMutableData alloc] initWithCapacity:2];
        
        [receiveData appendBytes:&q length:1];
        [receiveData appendBytes:&p length:1];
        [receiveData appendBytes:&x length:1];
        [receiveData appendBytes:&y length:1];
        
        
        //获取字符串长度
        int a ;
        
        [receiveData getBytes:&a range:{0,4}];
        
        MYLog(@"---%d",a);
       // [receiveData release];
        
        char buff[a];
    
        // 4
        ret = PPCS_Read(handleSession, 2, buff, &a, timeout);
        //ERROR_PPCS_SUCCESSFUL
        if (ret == ERROR_PPCS_SUCCESSFUL) {
            
            NSData * data = [NSData dataWithBytes:buff length:a];
            NSString * string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            //            NSLog(@"string %@",string);
            
            a = 2;
            char buff[a];
            // 4
            ret = PPCS_Read(handleSession, 2, buff, &a, timeout);
            if (ret == ERROR_PPCS_SUCCESSFUL) {
                NSData * data = [NSData dataWithBytes:buff length:a];
                NSString * subString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                if ([subString isEqualToString:@"!!"]) {
                  //  NSLog(@"数据完整%@",string);
                    if (self.m_delegateCam && [self.m_delegateCam respondsToSelector:@selector(receiveString:)]) {
                        [self.m_delegateCam receiveString:string];
                    }
                } else {
                  //  NSLog(@"数据不完整 %@ %@",string,subString);
                }
                
                [subString release];
            }
            [string release];
        }
    }
    return ret;
}

//=={{audio: ADPCM codec==============================================================
INT32 g_nAudioPreSample=0;
INT32 g_nAudioIndex = 0;

static int gs_index_adjust[8]= {-1,-1,-1,-1,2,4,6,8};
static int gs_step_table[89] =
{
    7,8,9,10,11,12,13,14,16,17,19,21,23,25,28,31,34,37,41,45,
    50,55,60,66,73,80,88,97,107,118,130,143,157,173,190,209,230,253,279,307,337,371,
    408,449,494,544,598,658,724,796,876,963,1060,1166,1282,1411,1552,1707,1878,2066,
    2272,2499,2749,3024,3327,3660,4026,4428,4871,5358,5894,6484,7132,7845,8630,9493,
    10442,11487,12635,13899,15289,16818,18500,20350,22385,24623,27086,29794,32767
};

void Encode(unsigned char *pRaw, int nLenRaw, unsigned char *pBufEncoded)
{
    short *pcm = (short *)pRaw;
    int cur_sample;
    int i;
    int delta;
    int sb;
    int code;
    nLenRaw >>= 1;
    
    for(i = 0; i<nLenRaw; i++)
    {
        cur_sample = pcm[i];
        delta = cur_sample - g_nAudioPreSample;
        if (delta < 0){
            delta = -delta;
            sb = 8;
        }else sb = 0;
        
        code = 4 * delta / gs_step_table[g_nAudioIndex];
        if (code>7) code=7;
        
        delta = (gs_step_table[g_nAudioIndex] * code) / 4 + gs_step_table[g_nAudioIndex] / 8;
        if(sb) delta = -delta;
        
        g_nAudioPreSample += delta;
        if (g_nAudioPreSample > 32767) g_nAudioPreSample = 32767;
        else if (g_nAudioPreSample < -32768) g_nAudioPreSample = -32768;
        
        g_nAudioIndex += gs_index_adjust[code];
        if(g_nAudioIndex < 0) g_nAudioIndex = 0;
        else if(g_nAudioIndex > 88) g_nAudioIndex = 88;
        
        if(i & 0x01) pBufEncoded[i>>1] |= code | sb;
        else pBufEncoded[i>>1] = (code | sb) << 4;
    }
}

void Decode(char *pDataCompressed, int nLenData, char *pDecoded)
{
    int i;
    int code;
    int sb;
    int delta;
    short *pcm = (short *)pDecoded;
    nLenData <<= 1;
    
    for(i=0; i<nLenData; i++)
    {
        if(i & 0x01) code = pDataCompressed[i>>1] & 0x0f;
        else code = pDataCompressed[i>>1] >> 4;
        
        if((code & 8) != 0) sb = 1;
        else sb = 0;
        code &= 7;
        
        delta = (gs_step_table[g_nAudioIndex] * code) / 4 + gs_step_table[g_nAudioIndex] / 8;
        if(sb) delta = -delta;
        
        g_nAudioPreSample += delta;
        if(g_nAudioPreSample > 32767) g_nAudioPreSample = 32767;
        else if (g_nAudioPreSample < -32768) g_nAudioPreSample = -32768;
        
        pcm[i] = g_nAudioPreSample;
        g_nAudioIndex+= gs_index_adjust[code];
        if(g_nAudioIndex < 0) g_nAudioIndex = 0;
        if(g_nAudioIndex > 88) g_nAudioIndex= 88;
    }
}
//==}}audio: ADPCM codec==============================================================

#pragma mark - interface of CamObj
- (NSInteger)sendIOCtrl:(int) handleSession withIOType:(int) nIOCtrlType withIOData:(char *)pIOData withIODataSize:(int)nIODataSize
{
    NSInteger nRet=0;
    
    int nLenHead=sizeof(st_AVStreamIOHead)+sizeof(st_AVIOCtrlHead);
    char *packet=new char[nLenHead+nIODataSize];
    st_AVStreamIOHead *pstStreamIOHead=(st_AVStreamIOHead *)packet;
    st_AVIOCtrlHead *pstIOCtrlHead =(st_AVIOCtrlHead *)(packet+sizeof(st_AVStreamIOHead));
    
    pstStreamIOHead->nStreamIOHead=sizeof(st_AVIOCtrlHead)+nIODataSize;
    pstStreamIOHead->uionStreamIOHead.nStreamIOType=SIO_TYPE_IOCTRL;
    
    pstIOCtrlHead->nIOCtrlType   =nIOCtrlType;
    pstIOCtrlHead->nIOCtrlDataSize=nIODataSize;
    
    if(pIOData) memcpy(packet+nLenHead, pIOData, nIODataSize);
    
    int nSize=nLenHead+nIODataSize;
    
    nRet=PPCS_Write(handleSession, CHANNEL_IOCTRL, packet, nSize);
    
    delete []packet;
    
    return nRet;
}
- (int )writeWithDic:(NSDictionary *)dic sessionHandle:(int)sessionHandle {
   
    NSError * error = nil;
  //  NSData *data = [dic JSONData];
    NSData * data = [NSJSONSerialization dataWithJSONObject:dic options:0 error:&error];
  //  NSData *data = [dic ];
    NSString *tempString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    //    tempString = [tempString stringByAppendingString:@"\n"];
    int length = (int)tempString.length;
    
    
    NSString *headString = @"##";
    
    NSData *data1 = [headString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableData *mutData = [NSMutableData dataWithData:data1];
    
    int i = length;
    char c1 = (i >> 8) & 0xff; // 高8位
    char c2 = i & 0xff; // 低8位
    
    
    //  [mutData  appendBytes:&length length:sizeof(length/2)];
    [mutData appendBytes:&c1 length:1];
    [mutData appendBytes:&c2 length:1];
    
  //  NSData *sendData1 = [tempString dataUsingEncoding:NSUTF8StringEncoding];
    
    [mutData appendData:data];
    
    NSString *tailString = @"!!";
    NSData *tailData = [tailString dataUsingEncoding:NSUTF8StringEncoding];
    
    [mutData appendData:tailData];
    int sendDataLength = (int)mutData.length;
    
    // 3
    MYLog(@"%@",mutData);
    int result = PPCS_Write(sessionHandle, 1,(char *)mutData.bytes, (INT32)mutData.length);
    
  //  MYLog(@"writeData:%@ \n%d.writeDataLength: %d",mutData,(int)result,sendDataLength);
    
  //  MYLog(@"the length is %ld",mutData.length);
 //   MYLog(@"the sendString is  %@",[[NSString alloc]initWithData:mutData encoding:NSUTF8StringEncoding]);
    
    return result;
}

- (BOOL) isConnected
{
    return (m_handle>=0 ? YES : NO);
}

- (void) stopAll
{
  //  [self closeAudio];
   // [self stopVideo];
    [self stopConnect];
}

INT32 myGetDataSizeFrom(st_AVStreamIOHead *pStreamIOHead)
{
    INT32 nDataSize=pStreamIOHead->nStreamIOHead;
    nDataSize &=0x00FFFFFF;
    return nDataSize;
}

- (NSInteger) startConnect:(unsigned long)waitTime_sec
{
    if(![self mayContinue]) return -1;
    else if(m_bConnecting) return -2;
    else {
        m_bConnecting=1;
        [mLockConnecting lock];
        mConnMode=CONN_MODE_UNKNOWN;
        
        char *sDID=NULL;
        sDID=(char *)[nsDID cStringUsingEncoding:NSASCIIStringEncoding];
        m_handle=PPCS_Connect(sDID, 1, 0);
        if(m_handle>=0){
          //  MYLog(@"connected %d %@",m_handle,mThreadRecvAVData);
            st_PPCS_Session SInfo;
            memset(&SInfo, 0, sizeof(SInfo));
            PPCS_Check(m_handle, &SInfo);
            mConnMode=SInfo.bMode;
            // i added this method
            if (PPCS_Check(m_handle, &SInfo)== ERROR_PPCS_SUCCESSFUL) {
                if (mConnMode == 0) {
                    MYLog(@"p2p连接成功");
                }

            }
            

            //create receiving data thread
            if (mThreadRecvAVData != nil) {
                [mThreadRecvAVData cancel];
                [mThreadRecvAVData release];
                mThreadRecvAVData = nil;
            }
            
            m_bRunning=YES;
            mLockRecvAVData=[[NSConditionLock alloc] initWithCondition:NOTDONE];
            mThreadRecvAVData=[[NSThread alloc] initWithTarget:self selector:@selector(ThreadRecvAVData) object:nil];
            [mThreadRecvAVData start];
        }

        [mLockConnecting unlock];
        m_bConnecting = 0;
    }
    
    // 监听数据
    [self listonData];
    
    return m_handle;
}

- (void) stopConnect
{
    int nRet = PPCS_Connect_Break();
    
    NSLog(@"PPCS_Connect_Break:%d",nRet);
    
    if(m_handle>=0) {
        PPCS_Close(m_handle);
        
        //stop receiving data thread
        m_bRunning=NO;

#if 0
        if(mThreadRecvAVData != nil){
            
            [mLockRecvAVData lockWhenCondition:DONE];
            [mLockRecvAVData unlock];
            
            [mLockRecvAVData release];
            mLockRecvAVData  =nil;
            [mThreadRecvAVData cancel];
            [mThreadRecvAVData release];
            mThreadRecvAVData = nil;
            NSLog(@"mThreadRecvAVData %@",mThreadRecvAVData);
        }
#endif

        m_handle = -1;
    }
}

- (NSInteger) openAudio
{
    NSInteger nRet=-1;
    nRet=[self sendIOCtrl:m_handle withIOType:IOCTRL_TYPE_AUDIO_START withIOData:NULL withIODataSize:0];
    
    if(nRet>=0 && mThreadDecordAudio==nil){
        [self ResetAudioVar];
        mLockDecordAudio=[[NSConditionLock alloc] initWithCondition:NOTDONE];
        mThreadDecordAudio=[[NSThread alloc] initWithTarget:self selector:@selector(ThreadDecordAudio) object:nil];
        [mThreadDecordAudio start];
    }
    return nRet;
}

- (void) closeAudio
{
    NSInteger nRet=-1;
    nRet=[self sendIOCtrl:m_handle withIOType:IOCTRL_TYPE_AUDIO_STOP withIOData:NULL withIODataSize:0];
    NSLog(@"closeAudio, nRet=%ld", (long)nRet);
    
    m_bAudioDecording=NO;
    if(mThreadDecordAudio!=nil){
        [mLockDecordAudio lockWhenCondition:DONE];
        [mLockDecordAudio unlock];
        
        [mLockDecordAudio release];
        mLockDecordAudio  =nil;
        [mThreadDecordAudio release];
        mThreadDecordAudio=nil;
    }
}

- (NSInteger) startVideo
{
    NSInteger nRet=-1;
    nRet=[self sendIOCtrl:m_handle withIOType:IOCTRL_TYPE_VIDEO_START withIOData:NULL withIODataSize:0];
    
    if(nRet>=0 && mThreadPlayVideo==nil){
        mLockPlayVideo=[[NSConditionLock alloc] initWithCondition:NOTDONE];
        mThreadPlayVideo=[[NSThread alloc] initWithTarget:self selector:@selector(ThreadPlayVideo) object:nil];
        [mThreadPlayVideo start];
    }
    return nRet;
}

- (void) stopVideo
{
    NSInteger nRet=-1;
    nRet=[self sendIOCtrl:m_handle withIOType:IOCTRL_TYPE_VIDEO_STOP withIOData:NULL withIODataSize:0];
    NSLog(@"stopVideo, nRet=%ld", (long)nRet);
    
    m_bVideoPlaying=NO;
    if(nRet>=0 && mThreadPlayVideo!=nil){
        [mLockPlayVideo lockWhenCondition:DONE];
        [mLockPlayVideo unlock];
        
        [mLockPlayVideo release];
        mLockPlayVideo  =nil;
        [mThreadPlayVideo release];
        mThreadPlayVideo=nil;
    }
}


- (int)setResolutionWithVideoResolution:(VideoResolutionType)videoResolutionType {
    NSInteger nRet = -1;
    char byte[1] = {static_cast<char>(videoResolutionType)};
    
    nRet = [self sendIOCtrl:m_handle withIOType:IOCTRL_TYPE_VIDEO_SET_RESOLUTION withIOData:byte withIODataSize:1];
    
    if (nRet >= 0) {
        NSLog(@"成功改变分辨率 %d", (int)videoResolutionType);
    } else {
        NSLog(@"失败 %d", (int)videoResolutionType);
    }
    return (int)nRet;
}

/**
 *  切换摄像头
 *
 *  @param camera 摄像头id
 *
 *  @return <#return value description#>
 */
- (int) SwitchCamera:(CameraType) camera
{
    NSInteger nRet = -1;
    char byte[1] = {static_cast<char>(camera)};
    
    nRet = [self sendIOCtrl:m_handle withIOType:IOCTRL_TYPE_VIDEO_SELECT_ANALOG_CAMERA withIOData:byte withIODataSize:1];
    
    if (nRet >= 0) {
        NSLog(@"成功切换摄像头到 %d", (int)camera);
    } else {
        NSLog(@"切换摄像头失败 %d", (int)camera);
    }
    return (int)nRet;
}

-(void) myDoVideoData:(CHAR *)pData
{
//    st_AVFrameHead stFrameHead;
//    int nLenFrameHead=sizeof(stFrameHead);
//    memcpy(&stFrameHead, pData, nLenFrameHead);
//    long nDiffTimeStamp=0L;
//    
//    //update online num every 3s
//    unsigned long nTick2=[CamObj getTickCount];
//    NSUInteger nTimespan=nTick2-m_nTickUpdateInfo;
//    if(nTimespan==0) nTimespan=1000;
//    if(nTimespan>=3000 || m_bFirstFrame){
//        m_nTickUpdateInfo=nTick2;
//        NSUInteger totalFrame=mTotalFrame;
//        mTotalFrame=0;
//        nTimespan=nTimespan/1000;
//        //NSLog(@"myDoVideoData, stFrameHead.status=%d, totalFrame=%d\n", stFrameHead.status, totalFrame);
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if(self.m_delegateCam && [self.m_delegateCam respondsToSelector:@selector(refreshSessionInfo:OnlineNm:TotalFrame:Time:)])
//                [self.m_delegateCam refreshSessionInfo:mConnMode OnlineNm:stFrameHead.nOnlineNum TotalFrame:totalFrame Time:nTimespan];
//        });
//    }
//    
//    switch(stFrameHead.nCodecID)
//    {
//            
//        case CODECID_V_H264:
//            if(m_nInitH264Decoder>=0){
//                if(m_bFirstFrame && stFrameHead.flag!=VFRAME_FLAG_I) break;
//                m_bFirstFrame=FALSE;
//                
//                int consumed_bytes=0;
//                int nFrameSize=stFrameHead.nDataSize;
//                UCHAR *pFrame=(UCHAR *)(pData+nLenFrameHead);
//                
//                while(nFrameSize>0){
//                AGAIN_DECODER_NAL:
//                    consumed_bytes=H264Decode(m_pBufBmp24, pFrame, nFrameSize, m_framePara);
//                    if(consumed_bytes<0){
//                        //                        nFrameSize=0;
//                        break;
//                    }
//                    if(!m_bVideoPlaying) break;
//                    
//                    if(m_framePara[0]>0){
//                        if(m_framePara[2]>0 && m_framePara[2]!=mVideoWidth){
//                            mVideoWidth =m_framePara[2];
//                            mVideoHeight =m_framePara[3];
//                            NSLog(@"  myDoVideoData(..): DecoderNal(.)>=0, %dX%d, pFrame[2,3,4,5]=%X,%X,%X,%X\n",
//                                  m_framePara[2], m_framePara[3], pFrame[2],pFrame[3],pFrame[4],pFrame[5]);
//                        }
//                        
//                        m_nTick2_video=[CamObj getTickCount];
//                        if(m_nFirstTimestampDevice_video==0 || m_nFirstTickLocal_video==0){
//                            m_nFirstTimestampDevice_video=stFrameHead.nTimeStamp;
//                            m_nFirstTickLocal_video =m_nTick2_video;
//                        }
//                        if(m_nTick2_video<m_nFirstTickLocal_video ||
//                           stFrameHead.nTimeStamp<m_nFirstTimestampDevice_video)
//                        {
//                            m_nFirstTimestampDevice_video=stFrameHead.nTimeStamp;
//                            m_nFirstTickLocal_video =m_nTick2_video;
//                        }
//                        
//                        nDiffTimeStamp=(stFrameHead.nTimeStamp-m_nFirstTimestampDevice_video) - (m_nTick2_video-m_nFirstTickLocal_video);
//                        if(nDiffTimeStamp<3000){
//                            for(int kk=0; kk<nDiffTimeStamp; kk++){
//                                if(!m_bVideoPlaying) break;
//                                usleep(1000);
//                            }
//                        }
//                        
//                        mTotalFrame++;
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                            if(self.m_delegateCam &&
//                               [self.m_delegateCam respondsToSelector:@selector(refreshFrame:withVideoWidth:videoHeight:withObj:)])
//                                [self.m_delegateCam refreshFrame:m_pBufBmp24
//                                                  withVideoWidth:mVideoWidth
//                                                     videoHeight:mVideoHeight
//                                                         withObj:self];
//                        });
//                    }
//                    nFrameSize-=consumed_bytes;
//                    if(nFrameSize>0) memcpy(pFrame, pFrame+consumed_bytes, nFrameSize);
//                    else nFrameSize=0;
//                }//while--end
//            }
//            break;
//        default:;
//    }
}
//video: decord and display it
- (void)ThreadPlayVideo
{
//    block_t *pBlock=NULL;
//    NSLog(@"    ThreadPlayVideo, nNumFiFo=%d", av_FifoCount(m_fifoVideo));
//    
//    m_nTickUpdateInfo =0L;
//    mTotalFrame=0;
//    
//    [mLockPlayVideo lock];
//    m_nInitH264Decoder=InitCodec(1);
//    m_pBufBmp24=(unsigned char *)malloc(MAXSIZE_IMG_BUFFER);
//    m_bVideoPlaying=YES;
//    while(m_bVideoPlaying){
//        pBlock=av_FifoGetAndRemove(m_fifoVideo);
//        if(pBlock==NULL){
//            usleep(8000);
//            continue;
//        }
//        
//        [self myDoVideoData:pBlock->p_buffer];
//        block_Release(pBlock);
//        pBlock=NULL;
//    }
//    free(m_pBufBmp24);
//    UninitCodec();
//    [mLockPlayVideo unlockWithCondition:DONE];
//    
//    NSLog(@"=== ThreadPlayVideo exit ===");
}


//audio: decord and play it
- (void)ThreadDecordAudio
{
//    NSLog(@"  --- ThreadDecordAudio, going...\n");
//    int nAudioFIFONum=0, nAUDIO_BUF_NUM=MAX_AUDIO_BUF_NUM;
//    [mLockDecordAudio lock];
//    block_t *pBlock=NULL;
//    st_AVFrameHead stFrameHead;
//    int  nLenFrameHead=sizeof(st_AVFrameHead), nFrameSize=0;
//    char *pFrame=NULL;
//    char *outPCM=(char *)malloc(MAX_SIZE_AUDIO_PCM);
//    int  nTimeSleep=25000, nSizePCM=0;
//    char bufTmp[640];
//    
//    OpenALPlayer *player = nil;
//    player = [[OpenALPlayer alloc] init];
//    int format=AL_FORMAT_MONO16, nSamplingRate=8000;
//    [player initOpenAL:format :nSamplingRate];
//    
//    g_nAudioIndex=0;
//    g_nAudioPreSample=0;
//    m_bAudioDecording=YES;
//    while(m_bAudioDecording){
//        nAudioFIFONum=av_FifoCount(m_fifoAudio);
//        if(nAudioFIFONum<nAUDIO_BUF_NUM){
//            if(nAUDIO_BUF_NUM==MIN_AUDIO_BUF_NUM) nAUDIO_BUF_NUM=MAX_AUDIO_BUF_NUM;
//            usleep(4000);
//            continue;
//        }else nAUDIO_BUF_NUM=MIN_AUDIO_BUF_NUM;
//        
//        pBlock=av_FifoGetAndRemove(m_fifoAudio);
//        if(pBlock==NULL) continue;
//        
//        memcpy(&stFrameHead, pBlock->p_buffer, nLenFrameHead);
//        pFrame=(pBlock->p_buffer+nLenFrameHead);
//        nFrameSize=stFrameHead.nDataSize;
//        if(stFrameHead.nCodecID==CODECID_A_ADPCM){
//            nSizePCM=0;
//            for(int i=0; i<nFrameSize/160; i++){
//                Decode((char *)pFrame+i*160, 160, bufTmp);
//                memcpy(outPCM+nSizePCM, bufTmp, 640);
//                nSizePCM+=640;
//            }
//            
//            [player openAudioFromQueue:[NSData dataWithBytes:outPCM length:nSizePCM]];
//            usleep(nTimeSleep);
//            //NSLog(@"adpcm, nTimeSleep=%d nFrameSize=%d, nSizePCM=%d", nTimeSleep, nFrameSize, nSizePCM);
//        }
//        block_Release(pBlock);
//        pBlock=NULL;
//    }
//    
//    if(outPCM) {
//        free(outPCM);
//        outPCM=NULL;
//    }
//    if(player != nil) {
//        [player stopSound];
//        [player cleanUpOpenAL];
//        [player release];
//        player = nil;
//    }
//    [mLockDecordAudio unlockWithCondition:DONE];
//    NSLog(@"=== ThreadDecordAudio exit ===");
}


- (void)ThreadRecvAVData
{
//    NSLog(@"    ThreadRecvAVData going...");
//    
//    CHAR  *pAVData=(CHAR *)malloc(MAX_SIZE_AV_BUF);
//    INT32 nRecvSize=4, nRet=0;
//    CHAR  nCurStreamIOType=0;
//    st_AVStreamIOHead *pStreamIOHead=NULL;
//    block_t *pBlock=NULL;
//    
//    m_bRunning=YES;
//    while(m_bRunning){
//        nRecvSize=sizeof(st_AVStreamIOHead);
//        
//        nRet=[self readDataFromRemote:m_handle withChannel:CHANNEL_DATA withBuf:pAVData withDataSize:&nRecvSize withTimeout:100];
//        
//        if(nRet == ERROR_PPCS_SESSION_CLOSED_TIMEOUT){
//            NSLog(@"ThreadRecvAVData: Session TimeOUT!!\n");
//            break;
//            
//        }else if(nRet == ERROR_PPCS_SESSION_CLOSED_REMOTE){
//            NSLog(@"ThreadRecvAVData: Session Remote Close!!\n");
//            break;
//            
//        }else if(nRet==ERROR_PPCS_SESSION_CLOSED_CALLED){
//            NSLog(@"ThreadRecvAVData: myself called PPCS_Close!!\n");
//            break;
//            
//        }//else NSLog(@"ThreadRecvAVData: errorCode=%d\n", nRet);
//        
//        if(nRecvSize>0){
//            
//            pStreamIOHead=(st_AVStreamIOHead *)pAVData;
//            nCurStreamIOType=pStreamIOHead->uionStreamIOHead.nStreamIOType;
//            
//            nRecvSize=myGetDataSizeFrom(pStreamIOHead);
//            
//            nRet=[self readDataFromRemote:m_handle withChannel:CHANNEL_DATA withBuf:pAVData withDataSize:&nRecvSize withTimeout:100];
//            
//            if(nRet == ERROR_PPCS_SESSION_CLOSED_TIMEOUT){
//                NSLog(@"ThreadRecvAVData: Session TimeOUT!!\n");
//                break;
//                
//            }else if(nRet == ERROR_PPCS_SESSION_CLOSED_REMOTE){
//                NSLog(@"ThreadRecvAVData: Session Remote Close!!\n");
//                break;
//                
//            }else if(nRet==ERROR_PPCS_SESSION_CLOSED_CALLED){
//                NSLog(@"ThreadRecvAVData: myself called PPCS_Close!!\n");
//                break;
//            }
//            
//            if(nRecvSize>0){
//                if(nRecvSize>=MAX_SIZE_AV_BUF) NSLog(@"====nRecvSize>256K, nCurStreamIOType=%d\n", nCurStreamIOType);
//                else{
//                    if(nCurStreamIOType==SIO_TYPE_AUDIO){
//                        
//                        pBlock=(block_t *)malloc(sizeof(block_t));
//                        block_Alloc(pBlock, pAVData, nRecvSize+sizeof(st_AVStreamIOHead));
//                        av_FifoPut(m_fifoAudio, pBlock);
//                        
//                    }else if(nCurStreamIOType==SIO_TYPE_VIDEO){
//                        char * p = pAVData + 16;
//                        NSData * data = [[NSData alloc] initWithBytes:p length:nRecvSize - 16];
//                        
//                        //判断flag加密位
//                        NSData *imageData;
//                        int tpye = pStreamIOHead->uionStreamIOHead.nStreamIOType;
//                        if (tpye>='\x80') {
//                            //截取原生dataSize
//                            NSData *recData = [[NSData alloc] initWithBytes:pAVData length:nRecvSize];
//                            NSData *subData = [recData subdataWithRange:NSMakeRange(8,4)];
//                            //data to int
//                            int i;
//                            [subData getBytes: &i length: sizeof(i)];
//                            //ASE128解密
//                            NSString *Key = [HouseModelHandle shareHouseHandle].currentHouse.address;
//                            NSData *DecodeData = [Encryption AES128Decrypt:data key:Key];
//                            imageData = [NSData dataWithBytes:[DecodeData bytes] length:DecodeData.length - (nRecvSize - i-16)];
//                            
//                            NSLog(@"nRecvSize = %d,i = %d",nRecvSize,i);
//                            
//                            //摄像头
//                            tpye -=(unsigned char)'\x80';
//                            pStreamIOHead->uionStreamIOHead.nStreamIOType = tpye;
//                            
//                            [recData release];
//                            [DecodeData release];
//                            [data release];
//                            
//                        }
//                        else
//                        {
//                            imageData = data;
//                        }
//                        
//                        NSDataWithCameraType *dataWcamera = [NSDataWithCameraType data:imageData withcameraType:tpye];
//                        //pStreamIOHead->uionStreamIOHead.nStreamIOType
//                        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_imageData object:dataWcamera];
//                        
//                        [data release];
//                        [dataWcamera release];
//                        [imageData release];
//                        
//                        //                        pBlock=(block_t *)malloc(sizeof(block_t));
//                        //                        block_Alloc(pBlock, pAVData, nRecvSize+sizeof(st_AVStreamIOHead));
//                        //                        av_FifoPut(m_fifoVideo, pBlock);
//                    }
//                }
//            }
//        }//if(nRecvSize>0)-end
//    }
//    
//    //    NSLog(@"%@",mLockRecvAVData);
//    
//    [mLockRecvAVData lockWhenCondition:DONE];
//    [mLockRecvAVData unlock];
//    
//    NSLog(@"%@",[NSThread currentThread]);
//    NSLog(@"=== ThreadRecvAVData exit ===");
}

// 监听数据
- (void)listonData {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        while ([self isConnected]) {
            
            int ret = [self readDataWithHandleSession:m_handle];
            if (ret == ERROR_PPCS_TIME_OUT) {
                MYLog(@"超时 %d",ret);
            } else if (ret == ERROR_PPCS_NOT_INITIALIZED) {
                MYLog(@"没有初始化");
                break;
            } else if (ret < 0) {
                //                [self stopAll];
                MYLog(@"ret = %d",ret);
                //                [self stopAll];
                [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationP2PDidDisConnected object:nil];
                break;
            }
        }
    });
}




@end
