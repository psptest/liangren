#ifndef _H_COMMON_DEFINE_INC_
#define _H_COMMON_DEFINE_INC_

/*************************************************
* NAS CAMERA通用定义
*************************************************/

#define AP_ERROR_FAILED			0		// SDK API执行失败
#define AP_ERROR_SUCC			1
#define AP_ERROR_NOT_INIT		-1		// SDK未初始化
#define AP_ERROR_MAX_INSTANCE	-2		// 超过最大可实例化数
#define AP_ERROR_INVALID_ID		-3		// userid不可用
#define AP_ERROR_LINK_MODE		-4		// 连接模式错误
#define AP_ERROR_ALLOC_FAILED	-5		// 申请资源失败
#define AP_ERROR_PARAMETERS		-6		// 错误参数
#define AP_ERROR_TRANSMIT_FILE_RUNNING	-7	// 已经在传输文件

#define AP_NET_TYPE_TCP		0
#define AP_NET_TYPE_P2P		1

// MAC地址字节数
#define MAC_ADDR_COUNT		6

// 连接设备信息结构
struct __login_user_info_t
{
	char	szUser[64]; 
	char	szPwd[64];
	char	szServIp[64];	// ip地址
	int		iServPort;		// 连接端口，tcp连接用
	char	szDid[64];		// 设备ID
};

#ifdef WIN32
#define STDCALL	__stdcall
#else
#define STDCALL

#endif

/* 
 * SDK事件回调
 * nType: 参考NET_EVENT_*
 */
typedef void (STDCALL *EventCallBack)(unsigned int nType, void *pUser);

/* 
 * P2P模式回调
 * nType: 参考NET_EVENT_P2P_MODE_*
 */
typedef void (STDCALL *P2PModeCallBack)(unsigned int nType, void *pContext);

/*
 * 警报消息回调
 * nType: 警报信息类型
 */
typedef void (STDCALL *AlarmCallBack)(unsigned int nType, void *pContext);

typedef void (STDCALL *AlarmCallBackV2)(int channel, unsigned int nType, void *pContext);

/*
 * 音视频回调
 * pBuffer: 音视频数据，根据帧头区分数据类型
 * nBufSize: 数据长度，包含帧头长度
 */
typedef void (STDCALL *AVDataCallBack)(const char *pBuffer, unsigned int nBufSize, void *pUser);

/*
 * 获取参数回调
 * nType: 参数类型
 * pszMessage: 参数数据
 * nLen: 数据长度
 */
typedef void (STDCALL *get_param_callback)(unsigned int nType, const char *pszMessage, unsigned int nLen, void *pUser);

/*
 * 设置参数回调
 * nType: 参数类型
 * nResult=1成功
 */
typedef void (STDCALL *set_param_callback)(unsigned int nType, unsigned int nResult, void *pUser);

typedef struct _stMessageHead{
	short nStartCode;
	short nCmd;
}MESSAGE_HEAD, *PMESSAGE_HEAD;

#define STARTCODE						0x4844

#define CMD_GET_NET_PARAM_REQUEST		0x0101		// 搜索IPC
#define CMD_GET_NET_PARAM_RESPONSE		0x0801 

#define CMD_SET_NET_PARAM_REQUEST		0x0102
#define CMD_SET_NET_PARAM_RESPONSE		0x0802

#define STATUS_OK						0x8000
#define STATUS_USER_PSW_ERROR			0x8001
#define STATUS_PERMISSIONS_ERROR		0x8002

#define CMD_GET_NET_PARAM_SMART_PLUG	0X0202		// 搜索只能插座

// 设备搜索结构
typedef struct _stBcastParam{
	char            szIpAddr[16];		// 设备IP地址
	char            szMask[16];			// 子网掩码
	char            szGateway[16];		// 网关
	char            szDns1[16];			
	char            szDns2[16];
	char            szMacAddr[6];		// eth0 MAC
	unsigned short          nPort;		// web端口
	char            dwDeviceID[32]; 	// 设备ID
	char            szDevName[80];		// 设备名称
	char            sysver[16];			// 系统固件版本
	char            appver[16];			// 应用固件版本
	char            szUserName[32];		
	char            szPassword[32];
	char            sysmode;        
	char		    dhcp;
	//char            other[2];    
	char			smartconnect;		// 0->normal 1->smart connect
	char			other;	
	unsigned char	WifiMac[6];
	unsigned char	type;				// 0:通用云台机 1:WVR 2:开关 3:报警摄像机 4:WIFI门铃 5:不带PTZ摄像机 6:光学放大倍数
	unsigned char	streamid;			
	char            other1[12];     
}BCASTPARAM, *PBCASTPARAM;
typedef void (STDCALL *BroadcastSearchCallback)(const BCASTPARAM *param, void *data);

// SDK事件
#define NET_EVENT_CONNECTTING		0		// 正在连接
#define NET_EVENT_CONNECTED			100		// 在线
#define NET_EVENT_CONNECT_ERROR		101		// 连接失败

#define NET_EVENT_ERROR_USER_PWD	1		// 用户名密码错误
#define NET_EVENT_ERROR_MAX_USER	2		// 超过最大可连接用户数
#define NET_EVENT_ERROR_STREAM_ID	3		// Stream ID错误
#define NET_EVENT_ERROR_VIDEO_LOST	4		// 视频丢失
#define NET_EVENT_ERROR_INVALID_ID	5		// 不可用的设备ID

#define NET_EVENT_P2P_NOT_ON_LINE	9		// 设备部在线
#define NET_EVENT_CONNECT_TIMEOUT	10		// 连接超时
#define NET_EVENT_DISCONNECT		11		// 断开连接
#define NET_EVENT_CHECK_ACCOUNT		12		// 校验用户账号

// P2P连接模式
#define NET_EVENT_P2P_MODE_RELAY 	6		// P2P 中继模式
#define NET_EVENT_P2P_MODE_P2P		7		// P2P 直连模式

// 报警类型
#define NET_EVENT_ALARM_CLEAR			0x19
#define NET_EVENT_ALARM_MOTION_START	0x20		// 发生移动侦测
#define NET_EVENT_ALARM_GPIO_START		0x21		// 发生GPIO警报
#define NET_EVENT_ALARM_MOTION_END		0x22		
#define NET_EVENT_ALARM_GPIO_END		0x23
#define NET_EVENT_ALARM_AUDIO_START		0x24		// 发生声音警报

#define NET_EVENT_ALARM_IR				0x25		// 红外警报信息
#define NET_EVENT_ALARM_DOORSENSOR		0x26		// 门磁警报
#define NET_EVENT_ALARM_SMOKE			0x27		// 烟感警报
#define NET_EVENT_ALARM_BELLITF			0x28		// 红外对射
#define NET_EVENT_ALARM_DOORBELL_PRESS	0x29		// 门铃按下

// 报警摄像机报警点
// 遥控1-4
#define NET_EVENT_ALARM_REMOTE_CONTROL1		0x40
#define NET_EVENT_ALARM_REMOTE_CONTROL2		0x41
#define NET_EVENT_ALARM_REMOTE_CONTROL3		0x42
#define NET_EVENT_ALARM_REMOTE_CONTROL4		0x43
// 门铃1-4
#define NET_EVENT_ALARM_DOORBELL1			0x44
#define NET_EVENT_ALARM_DOORBELL2			0x45
#define NET_EVENT_ALARM_DOORBELL3			0x46
#define NET_EVENT_ALARM_DOORBELL4			0x47
// 大厅
#define NET_EVENT_ALARM_HALL1				0x48
#define NET_EVENT_ALARM_HALL2				0x49
#define NET_EVENT_ALARM_HALL3				0x4A
#define NET_EVENT_ALARM_HALL4				0x4B
// 窗户
#define NET_EVENT_ALARM_WINDOW1				0x4C
#define NET_EVENT_ALARM_WINDOW2				0x4D
#define NET_EVENT_ALARM_WINDOW3				0x4E
#define NET_EVENT_ALARM_WINDOW4				0x4F
// 阳台
#define NET_EVENT_ALARM_VERANDA1			0x50
#define NET_EVENT_ALARM_VERANDA2			0x51
#define NET_EVENT_ALARM_VERANDA3			0x52
#define NET_EVENT_ALARM_VERANDA4			0x53
// 卧室
#define NET_EVENT_ALARM_BEDROOM1			0x54
#define NET_EVENT_ALARM_BEDROOM2			0x55
#define NET_EVENT_ALARM_BEDROOM3			0x56
#define NET_EVENT_ALARM_BEDROOM4			0x57
// 庭院
#define NET_EVENT_ALARM_YARD1				0x58
#define NET_EVENT_ALARM_YARD2				0x59
#define NET_EVENT_ALARM_YARD3				0x5A
#define NET_EVENT_ALARM_YARD4				0x5B
// 其他
#define NET_EVENT_ALARM_OTHER1				0x5C
#define NET_EVENT_ALARM_OTHER2				0x5D
#define NET_EVENT_ALARM_OTHER3				0x5E
#define NET_EVENT_ALARM_OTHER4				0x5F

// WVR GPIO Alarm
#define NET_EVENT_ALARM_WVR_GPIO			0x60

// 最大帧长度 Frame_Head.len
#define MAX_VIDEO_DATA_SIZE	(512*1024)
#define MAX_AUDIO_DATA_SIZE	(2*1024)

// 兼容老的，新的不会使用
#define MAX_FRAME_BUF_SIZE (512*1024) 

// 音视频帧头结构
typedef struct _stFrameHead
{	
	unsigned int   		startcode;	// STARTCODE

	char				type;		// 0->IFrame 1->PFrame 3->MJPEG 6->ADPCM 
	char				streamid;

	unsigned short 		militime;	
	unsigned int 		sectime;	
	unsigned int    	frameno;	
	unsigned int 		len;		// tcp len=0是报警信息,否则是数据长度,不包含头

	unsigned char		version;	
	unsigned char		size;

	unsigned char		other[2];
	unsigned char		other2;		// index 25Bytes 20130828
	char				byzone;		// TimeZone	20131022 unsigned char改成char
	unsigned char		other1[6];	// 8 to 6

}Frame_Head;
typedef struct _stFrameData
{
	Frame_Head head; 
	char frameBuf[MAX_VIDEO_DATA_SIZE];
}Frame_Data;

#define MAX_RECORD_FILE_COUNT 1000

/* 
 *视频解码后数据回调
 * pYUVData YUV420数据
 */
typedef void (STDCALL *YUV420DataCallBack)(unsigned char *pYUVData, int width, int height, void *pUserData);
/*
 * 音频解码后数据回调
 * pData: pcm数据
 * size: 数据长度
 */
typedef void (STDCALL *AudioDataCallBack)(const char *pData, int size, void *pUserData);
/* 
 *解码库压缩音频数据回调
 * pData: 编码后的adpcm数据
 * nSize = 256Byte
 */
typedef void (STDCALL *EncodeAudioDataCallBack)(const char *pData, int nSize, void *pUserData);


typedef enum {
	VIDEO_ENCODE_H264,
	VIDEO_ENCODE_MJPEG,
}VideoEncodeType;

typedef enum {
	AUDIO_ENCODE_ADPCM,
	AUDIO_ENCODE_G711A,
}AudioEncodeType;


/*
 *云台控制码
 */
#define PTZ_UP 				0
#define PTZ_UP_STOP	 		1
#define PTZ_DOWN 			2
#define PTZ_DOWN_STOP 		3
#define PTZ_LEFT 			4
#define PTZ_LEFT_STOP 		5
#define PTZ_RIGHT 			6
#define PTZ_RIGHT_STOP 		7

#define PTZ_LEFT_UP 		90
#define PTZ_RIGHT_UP 		91
#define PTZ_LEFT_DOWN 		92
#define PTZ_RIGHT_DOWN		93
#define PTZ_STOP 			1

#define PTZ_CENTER 			25

#define PTZ_VPATROL 		26
#define PTZ_VPATROL_STOP 	27
#define PTZ_HPATROL 		28
#define PTZ_HPATROL_STOP 	29
#define PTZ_PREFAB_BIT_SET0 30
#define PTZ_PREFAB_BIT_RUN0 31
#define PTZ_PREFAB_BIT_SET1 32
#define PTZ_PREFAB_BIT_RUN1 33
#define PTZ_PREFAB_BIT_SET2 34
#define PTZ_PREFAB_BIT_RUN2 35
#define PTZ_PREFAB_BIT_SET3 36
#define PTZ_PREFAB_BIT_RUN3 37
#define PTZ_PREFAB_BIT_SET4 38
#define PTZ_PREFAB_BIT_RUN4 39
#define PTZ_PREFAB_BIT_SET5 40
#define PTZ_PREFAB_BIT_RUN5 41
#define PTZ_PREFAB_BIT_SET6 42
#define PTZ_PREFAB_BIT_RUN6 43
#define PTZ_PREFAB_BIT_SET7 44
#define PTZ_PREFAB_BIT_RUN7 45
#define PTZ_PREFAB_BIT_SET8 46
#define PTZ_PREFAB_BIT_RUN8 47
#define PTZ_PREFAB_BIT_SET9 48
#define PTZ_PREFAB_BIT_RUN9 49
#define PTZ_PREFAB_BIT_SETA 50
#define PTZ_PREFAB_BIT_RUNA 51
#define PTZ_PREFAB_BIT_SETB 52
#define PTZ_PREFAB_BIT_RUNB 53
#define PTZ_PREFAB_BIT_SETC 54
#define PTZ_PREFAB_BIT_RUNC 55
#define PTZ_PREFAB_BIT_SETD 56
#define PTZ_PREFAB_BIT_RUND 57
#define PTZ_PREFAB_BIT_SETE 58
#define PTZ_PREFAB_BIT_RUNE 59
#define PTZ_PREFAB_BIT_SETF 60
#define PTZ_PREFAB_BIT_RUNF 61

#define PTZ_LR 30
#define PTZ_UD 31

#define PTZ_IR 32
#define PTZ_LED 33
#define PTZ_OSD 34  // Andrew 20130819 add

#define IO_ON 94
#define IO_OFF 95

#endif