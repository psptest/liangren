#ifndef _STREAM_PLAY_LIB_INC_
#define _STREAM_PLAY_LIB_INC_

#include "CommonDefine.h"

#ifdef _WIN32
#define STREAM_PLAY_API	__declspec(dllexport)
#else
#define STREAM_PLAY_API
#endif

#ifdef __cplusplus
extern "C" {
#endif // __cplusplus

STREAM_PLAY_API int x_player_initPlayLib( void );
STREAM_PLAY_API int x_player_uninitPlayLib( void );

// VideoType 0/1:H264/JPEG
// AudioType 0:Adpcm
STREAM_PLAY_API int x_player_createPlayInstance(int VideoType, int AudioType);  
STREAM_PLAY_API int x_player_destroyPlayInstance(int player_id);


STREAM_PLAY_API int x_player_startPlay(int player_id);
STREAM_PLAY_API int x_player_stopPlay(int player_id);

STREAM_PLAY_API int x_player_openSound(int player_id);
STREAM_PLAY_API int x_player_closeSound(int player_id);

STREAM_PLAY_API int x_player_inputNetFrame(int player_id, const char *buf, int size);

STREAM_PLAY_API int x_player_setPlayWnd(int player_id, void* view);

STREAM_PLAY_API int x_player_RegisterVideoCallBack(int player_id, YUV420DataCallBack pfn, void *pUserData);
STREAM_PLAY_API int x_player_RegisterAudioCallBack(int player_id, AudioDataCallBack pfn, void *pUserData);

STREAM_PLAY_API int x_player_StartTalk(int player_id, EncodeAudioDataCallBack pfn, void *pContext);
STREAM_PLAY_API int x_player_StopTalk(int player_id);
STREAM_PLAY_API int x_player_inputPcmData(int player_id, const char *pData, int size);

STREAM_PLAY_API int x_player_StartRecord(int player_id, const char *szFilename, int width, int height, int framerate);
STREAM_PLAY_API int x_player_StopRecord(int player_id);

STREAM_PLAY_API int x_player_RefreshAudioBuffer(int player_id);
STREAM_PLAY_API int x_Player_RefreshVideoBuffer(int player_id);

STREAM_PLAY_API int x_player_CapturePicture(int player_id, const char *szFilename);

/*
 * write record to mp4 file
 * szFilename: /x/myfile.mp4
 */
STREAM_PLAY_API int x_player_StartRecordForPlayback(int player_id, const char *szFilename);
/*
 * stop write mp4 file.
 */
STREAM_PLAY_API int x_player_StopRecordForPlayback(int player_id);

#ifdef __cplusplus
}
#endif // __cplusplus

#endif