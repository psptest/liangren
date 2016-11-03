#ifndef _H_IPC_CLIENT_NET_LIB_
#define _H_IPC_CLIENT_NET_LIB_

#include "CameraDefine.h"

#ifdef _WIN32
#define DEVICE_NET_API __declspec(dllexport)
#else
#define DEVICE_NET_API
#endif

#ifdef __cplusplus
extern "C" {
#endif // __cplusplus

DEVICE_NET_API int device_net_work_init(const char *serv);
DEVICE_NET_API int device_net_work_deInit();
DEVICE_NET_API int device_net_work_NetworkDetect();
DEVICE_NET_API unsigned int device_net_work_GetAPIVersion();
DEVICE_NET_API unsigned int device_net_work_GetP2PVersion();

//-------------------------------CAMERA API-----------------------------
DEVICE_NET_API	int device_net_work_createInstance(struct __login_user_info_t t, int NetType); // 0/1: tcp/p2p
DEVICE_NET_API	int device_net_work_destroyInstance(int UserID);
DEVICE_NET_API	int device_net_work_set_event_callback(int UserID, EventCallBack f, void *pUser);
DEVICE_NET_API	int device_net_work_set_p2pmode_callback(int UserID, P2PModeCallBack pfn, void *pUser);
DEVICE_NET_API	int device_net_work_set_alarmMessage_callback(int UserID, AlarmCallBack pfn, void *pUser);

DEVICE_NET_API	int device_net_work_start(int UserID);
DEVICE_NET_API	int device_net_work_stop(int UserID);

DEVICE_NET_API	int device_net_work_startStream(int UserID, int StreamId, AVDataCallBack pCallBack, void *pUser);
DEVICE_NET_API	int device_net_work_stopStream(int UserID);
DEVICE_NET_API	int device_net_work_startStreamV2(int UserID, int StreamId, int subStreamId, AVDataCallBack pCallBack, void *pUser);

DEVICE_NET_API	int device_net_work_startAudio(int UserID, int AudioId, AVDataCallBack pCallBack, void *pUser);
DEVICE_NET_API	int device_net_work_stopAudio(int UserID);

DEVICE_NET_API	int device_net_work_startTalk(int UserID);
DEVICE_NET_API	int device_net_work_stopTalk(int UserID);
DEVICE_NET_API	int device_net_work_sendTalkData(int UserID, const char * param, int nLen);


DEVICE_NET_API	int device_net_work_ptz(int UserID, int nType);

DEVICE_NET_API	int device_net_work_param_callback(int UserID, get_param_callback fget , set_param_callback fset , void *pUser);
DEVICE_NET_API	int device_net_work_set_param(int UserID, unsigned int nType, const char * param , unsigned int nLen);
DEVICE_NET_API	int device_net_work_get_param(int UserID, unsigned int nType);

DEVICE_NET_API	int device_record_file_search_list(int UserID, Search_File t, SearchSdFilesCallback pCallBack, void *pUser);
DEVICE_NET_API	int device_record_file_start(int UserID, const char *filename, AVDataCallBack pCallBack , void *pUser);
DEVICE_NET_API	int device_record_file_stop(int UserID);
DEVICE_NET_API	int device_record_file_set_pos(int UserID, unsigned int pos);

DEVICE_NET_API	int device_broadcast_Initialization();
DEVICE_NET_API	int device_broadcast_unInitialization();
DEVICE_NET_API	int device_broadcast_search(BroadcastSearchCallback pcallback, void *pUser);
DEVICE_NET_API  int device_broadcast_ModifyDeviceParam(BCASTPARAM *param);

// add取代device_record_file_start, device_record_file_stop, device_record_file_set_pos
DEVICE_NET_API	int device_record_file_callback(int UserID, SearchSdFilesCallbackV2 pCallBack, void *pUser);
DEVICE_NET_API	int device_record_file_search(int UserID, Search_File *t);
DEVICE_NET_API	int device_record_data_callback(int UserID, AVDataCallBack pCallBack , void *pUser);
DEVICE_NET_API	int device_record_playback_control(int UserID, CameraPlayRecordFile *playInfo);

#ifdef __cplusplus
}
#endif // __cplusplus


#endif