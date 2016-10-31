#ifndef _H_CAMERA_DEFINE_INC_
#define _H_CAMERA_DEFINE_INC_

#include "CommonDefine.h"

#define SET_PARAM_NETWORK	0x2000
#define GET_PARAM_NETWORK	0x2001
#define SET_PARAM_USERINFO	0x2002
#define GET_PARAM_USERINFO	0x2003
#define SET_PARAM_DDNS		0x2004
#define GET_PARAM_DDNS		0x2005
#define SET_PARAM_FTP		0x2006
#define GET_PARAM_FTP		0x2007
#define SET_PARAM_MAIL		0x2008
#define GET_PARAM_MAIL		0x2009
#define SET_PARAM_PTZ		0x2010				// set_misc
#define GET_PARAM_PTZ		0x2011				// get_misc
#define SET_PARAM_WIFI		0x2012
#define GET_PARAM_WIFI		0x2013
#define GET_PARAM_WIFI_LIST 0x2014
#define SET_PARAM_DATETIME	0x2015
#define GET_PARAM_DATETIME  0x2016
#define SET_PARAM_ALARM		0x2017
#define GET_PARAM_ALARM		0x2018
#define GET_PARAM_RECORDSCH 0x2021
#define SET_PARAM_RECORDSCH 0x2022
#define GET_PARAM_SDFORMAT  0x2023
#define SET_PARAM_SDFORMAT  0x2024
#define GET_CAMERA_PARAMS	0x2025 //fixfix 2013-05-11
#define SET_CAMERA_PARAMS	0x2026 //fixfix 2013-05-11

#define SET_FACTORY_PARAM	0x2027

#define REBOOT_EDV			0x2700
#define GET_PARAM_STATUS	0x2701
#define SET_PARAM_ALIAS		0x2702

#define GET_PARAM_APWIFI	0x2703		// add 2013-11-8
#define SET_PARAM_APWIFI	0x2704		// add 2013-11-8

#define GET_LOGIN_PARAM		0x2705		// fix 2013-12-4

#define SEARCH_RECORD_FILE	0x2706

#define WIFI_SCAN			0x2707
#define CHECK_USER			0x2708

#define GET_PARAM_ONVIF		0x2709
#define SET_PARAM_ONVIF		0x270A
#define GET_PARAM_RTSP		0x270B
#define SET_PARAM_RTSP		0x270C
#define GET_PARAM_ONLINE_USER		0x270D
#define GET_SNAPSHOT		0x270E
#define PLAY_BACK_CONTROL	0x270F

#define RESTORE_FACTORY		0x2710		// 恢复出厂设置
#define SET_IOS_PUSH        0x2711              // 设置IOS推送token
#define SET_IOS_PUSH_STOP    0x2712              // 取消IOS推送token

#define GET_PARAM_ALARM_CAM_LIST		0x2713		// 获取报警设备对码列表
#define SET_PARAM_ALARM_CAM_PRESET_CTRL	0x2714		// 设置报警对应的预置位
#define SET_PARAM_ALARM_CAM_CODE		0x2715		// 报警对码

#define DOOR_BELL_CONTROL				0x2716

#define ALARM_PRESET_SET1		30			// 报警预置位开始
#define ALARM_PRESET_SET32		61			// 报警预置位结束


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

typedef struct tagDateTime
{
	int nYear;
	int nMonth;
	int nDay;
	int nHour;
	int nMinute;
	int nSecond;
}AP_STRU_DateTime;

typedef struct _Search_File_t
{
	AP_STRU_DateTime startTime;
	AP_STRU_DateTime endTime;
}Search_File;
typedef void (STDCALL *SearchSdFilesCallback)(const char *filename,const char *filedate, const unsigned int filelen, void *data);



typedef struct tag_STRU_CAMERA_PARAMS
{
	int resolution;
	int brightness;
	int contrast;
	int hue;
	int saturation;
	int flip;
	int mode;
	int osdEnable;
	int enc_framerate;
	int sub_enc_framerate;
	// 以下3518e有
	int CameraType;		// 0/1/2/3:solomon/rt5350/ar9331/hi3518e
	int resolutionSub;
	int resolutionSubSub;
	int enc_size;
	int enc_keyframe;
	int enc_quant;
	int enc_ratemode;
	int enc_bitrate;
	int enc_main_mode;
	int sub_enc_size;
	int sub_enc_keyframe;
	int sub_enc_quant;
	int sub_enc_ratemode;
	int sub_enc_bitrate;
	int sub_sub_enc_size;
	int sub_sub_enc_framerate;
	int sub_sub_enc_keyframe;
	int sub_sub_enc_quant;
	int sub_sub_enc_ratemode;
	int sub_sub_enc_bitrate;
	int speed;			// 云台速度
	int ircut;			// 0/1: 未打开/已打开
	int involume;		// 麦克风音量
	int outvolume;		// 喇叭音量
}STRU_CAMERA_PARAMS,*PSTRU_CAMERA_PARAMS;

typedef struct tag_STRU_CAMERA_CONTROL
{
	int param;
	int value;
}STRU_CAMERA_CONTROL,*PSTRU_CAMERA_CONTROL;


typedef struct tag_STRU_ALIAS_PARAMS
{
	char alias[64];
}STRU_ALIAS_PARAMS,*PSTRU_ALIAS_PARAMS;


typedef struct tag_STRU_STATUS_PARAMS
{
	char sys_ver[32];
	char alias[96];
	char deviceid[32];
	int alarm_status;
	int sdcardstatus;
	int sdcardtotalsize;
	int sdcardremainsize;
	char mac[32];
	char wifimac[32];
	int dns_status;
	int upnp_status;

}STRU_STATUS_PARAMS,*PSTRU_STATUS_PARAMS;

typedef struct tag_STRU_NETWORK_PARAMS
{
	char ipaddr[64];
	char netmask[64];
	char gatway[64];
	char dns1[64];
	char dns2[64];
	int dhcp;
	int port;
	int rtspport;
}STRU_NETWORK_PARAMS,*PSTRU_NETWORK_PARAMS;

typedef struct tag_STRU_USER_INFO
{
	char user1[64];
	char pwd1[64];
	char user2[64];
	char pwd2[64];
	char user3[64];
	char pwd3[64];
}STRU_USER_INFO,*PSTRU_USER_INFO;
/*
enable 0:disable wifi 1:enable
ssid ssid，长度<= 40
channel 
mode Wifi模式
Authtype 0：禁止认证；：wep；：wpa tkip；：wpa aes；：wpa2 aes；：wpa2 tkip+aes
encrypt wep 校验方式，：open；：share
keyformat wep密钥格式，：进制数字；：ascii 字符
defkey wep中密钥选择：-3
key1 wep密钥，长度<= 30
key2 wep密钥
key3 wep密钥
key4 wep密钥
key1_bits wep密钥长度，：bits；：bits
key2_bits wep密钥长度，：bits；：bits
key3_bits wep密钥长度，：bits；：bits
key4_bits wep密钥长度，：bits；：bits
wpa_psk wpa psk 密钥，长度<= 64*/

typedef struct tag_STRU_WIFI_PARAMS
{
	int enable;
	char ssid[128];
	int channel;
	int mode;
	int authtype;
	int encrypt;
	int keyformat;
	int defkey;
	char key1[128];
	char key2[128];
	char key3[128];
	char key4[128];
	int key1_bits;
	int key2_bits;
	int key3_bits;
	int key4_bits;
	char wpa_psk[128];
}STRU_WIFI_PARAMS,*PSTRU_WIFI_PARAMS;


typedef struct tag_STRU_WIFI_SEARCH_RESULT
{
	char ssid[64];
	char mac[64];
	int security;
	char dbm0[32];
	char  dbm1[32];
	int mode;
	int channel;
}STRU_WIFI_SEARCH_RESULT,*PSTRU_WIFI_SEARCH_RESULT;
typedef struct tag_STRU_WIFI_SEARCH_RESULT_LIST
{
	int wifiCount;
	STRU_WIFI_SEARCH_RESULT wifi[32];
}STRU_WIFI_SEARCH_RESULT_LIST,*PSTRU_WIFI_SEARCH_RESULT_LIST;

/*
now 从-1-1 0:0:0到指定时间所流逝的秒数，如附加该参数，设备则依据此时间进行校时
tz 时区设置：和标准格林威治时间偏离的秒数
ntp_enable0：禁止ntp校时；：允许
ntp_svr ntp服务器，长度<= 64*/

typedef struct tag_STRU_DATETIME_PARAMS
{
	int now;
	int tz;
	int ntp_enable;
	char ntp_svr[64];
}STRU_DATETIME_PARAMS,*PSTRU_DATETIME_PARAMS;

/*service 0：禁止ddns服务
1：花生壳(暂不支持)
2：DynDns.org(dyndns)
3：DynDns.org(statdns)
4：DynDns.org(custom)
5：保留
6：保留
7：保留
8：(dyndns)
9：(statdns)
10：
11：厂家自有
12：厂家自有
user ddns用户，长度<= 64
pwd ddns密码，长度<= 64
host ddns域名，长度<= 64
proxy_svr 代理服务器地址，长度<= 64
Ddns_mode 部份dns需要的模式
proxy_port 代理服务器端口*/

typedef struct tag_STRU_DDNS_PARAMS
{
	int service;
	char user[64];
	char pwd[64];
	char host[64];
	char proxy_svr[64];
	int ddns_mode;
	int proxy_port;
	int ddns_status; 
}STRU_DDNS_PARAMS, *PSTRU_DDNS_PARAMS;
/*
svr ftp服务器地址，长度<= 64
port ftp服务器端口
user ftp服务器登录用户，长度<= 64
pwd ftp服务器登录密码，长度<= 64
dir ftp服务器上的存储目录，长度<= 64
mode 0：port模式；：pasv模式
Filename ftp文件名*/

typedef struct tag_STRU_FTP_PARAMS
{
	char svr_ftp[64];
	char user[64];
	char pwd[64];
	char dir[128];
	
	int port;
	int mode;
	int upload_interval;
}STRU_FTP_PARAMS,*PSTRU_FTP_PARAMS;
/*svr 邮件服务器地址，长度<= 64
sort 邮件服务端口
user 邮件服务器登录用户，长度<= 64
ssl 表示支持ssl认证
pwd 邮件服务器登录密码，长度<= 64
Sender 邮件的发送者，长度<= 64
receiver1 邮件的接收者，长度<= 64
receiver2 邮件的接收者，长度<= 64
receiver3 邮件的接收者，长度<= 64
receiver4 邮件的接收者，长度<= 64
mail_inet_ip 邮件通知IP,0->表示不需要，->表示需要*/

typedef struct tag_STRU_MAIL_PARAMS
{
	char svr[64];
	char user[64];
	char pwd[64];
	char sender[64];
	char receiver1[64];
	char receiver2[64];
	char receiver3[64];
	char receiver4[64];
	
	int port;
	int ssl;
	int smtpupload;
}STRU_MAIL_PARAMS,*PSTRU_MAIL_PARAMS;


/*motion_armed
motion_sensitivity
input_armed
ioin_level
iolinkage
alarmpresetsit
ioout_level
mail
snapshot
record
upload_interval
schedule_enable
schedule_sun_0
schedule_sun_1
schedule_sun_2
schedule_mon_0
schedule_mon_1
schedule_mon_2
schedule_tue_0
schedule_tue_1
schedule_tue_2
schedule_wed_0
schedule_wed_1
schedule_wed_2
schedule_thu_0
schedule_thu_1
schedule_thu_2
schedule_fri_0
schedule_fri_1
schedule_fri_2
schedule_sat_0
schedule_sat_1
schedule_sat_2*/

typedef struct tag_STRU_ALARM_PARAMS
{
	int motion_armed;
	int motion_sensitivity;
	int input_armed;
	int ioin_level;

	int iolinkage;
	int iolinkage_level;
	int alarmpresetsit;

	int mail;
	int snapshot;
	int record;
	int upload_interval;

	int schedule_enable;
	int schedule_sun_0;
	int schedule_sun_1;
	int schedule_sun_2;

	int schedule_mon_0;
	int schedule_mon_1;
	int schedule_mon_2;

	int schedule_tue_0;
	int schedule_tue_1;
	int schedule_tue_2;

	int schedule_wed_0;
	int schedule_wed_1;
	int schedule_wed_2;

	int schedule_thu_0;
	int schedule_thu_1;
	int schedule_thu_2;
	int schedule_fri_0;
	int schedule_fri_1;
	int schedule_fri_2;
	int schedule_sat_0;
	int schedule_sat_1;
	int schedule_sat_2;
	int alarm_audio;		// 声音报警
	int alarm_temp;			// 温度报警
    int pirenable;          // PIR检测
}STRU_ALARM_PARAMS,*PSTRU_ALARM_PARAMS;
/*led_mode：：模式；：模式；：关掉指示灯
ptz_center_onstart：=1，启动后居中
ptz_auto_patrol_interval：设置自动巡视间隔，：不自动巡视
ptz_run_times：巡视圈数，：无限大
ptz_patrol_rate：云台手动操作速度，-10，：最快
ptz_patrol_up_rate：向上自动巡航速度：-10，：最慢
ptz_patrol_down_rate：向下自动巡航速度：-10，：最慢
ptz_patrol_left_rate：向左自动巡航速度：-10，：最慢
ptz_patrol_right_rate：向右自动巡航速度：-10，：最慢
disable_preset：启用预置位，：禁用预置位
ptz_preset:：启用启动时调用预置位，表示启动居中，-16表示调用相对应的预置位
但禁用预置位后，启动时不会强制调用预置位
*/

typedef struct tag_STRU_PTZ_PARAMS
{
	int led_mode;						// 0：模式1；1：模式2；2：关掉指示灯
	int ptz_center_onstart;				// 1，启动后居中
	int ptz_run_times;					// 巡视圈数，0：无限大
	int ptz_patrol_rate;				// 云台手动操作速度，0-10，0：最快
	int ptz_patrol_up_rate;				// 向上自动巡航速度：0-10，0：最慢
	int ptz_patrol_down_rate;			// 向下自动巡航速度：0-10，0：最慢
	int ptz_patrol_left_rate;			// 向左自动巡航速度：0-10，0：最慢
	int ptz_patrol_right_rate;			// 向右自动巡航速度：0-10，0：最慢
	int disable_preset;					// 0: 启用预置位，1：禁用预置位
	int ptz_preset;						// PTZ预置位

	char ptz_preset_on_off[16];//[0]--preset0, [1]--preset1, ... //fixfix 2013-05-08
#if HI3518E	
	int device_type;		// 3518E有返回此字段，值为1
#endif	
}STRU_PTZ_PARAMS,*PSTRU_PTZ_PARAMS;

/////////////////录像计划////////////////
//record_cover：录像覆盖               //
//record_time：录像文件时间            //
//time_schedule_enable：日程安排       //
/////////////////////////////////////////
typedef struct tag_STRU_RECORDSCH_PARAMS
{
	int record_cover;
	int record_time;	
	int record_size;
	int time_schedule_enable;

	int schedule_sun_0;
	int schedule_sun_1;
	int schedule_sun_2;

	int schedule_mon_0;
	int schedule_mon_1;
	int schedule_mon_2;

	int schedule_tue_0;
	int schedule_tue_1;
	int schedule_tue_2;

	int schedule_wed_0;
	int schedule_wed_1;
	int schedule_wed_2;

	int schedule_thu_0;
	int schedule_thu_1;
	int schedule_thu_2;

	int schedule_fri_0;
	int schedule_fri_1;
	int schedule_fri_2;

	int schedule_sat_0;
	int schedule_sat_1;
	int schedule_sat_2;

	int sdcard_status;
	int sdcard_totalsize;
	int sdcard_remainsize;
	int record_audio;		// 3518E
	
}STRU_RECORDSCH_PARAMS,*PSTRU_RECORDSCH_PARAMS;


//typedef struct  tag_STRU_SD_RECORD_PARAM
//{
//	int record_cover_enable; 
//	int record_timer; 
//	int record_size;
//	int record_time_enable; 
//	int record_schedule_sun_0;
//	int record_schedule_sun_1; 
//	int record_schedule_sun_2; 
//	int record_schedule_mon_0; 
//	int record_schedule_mon_1; 
//	int record_schedule_mon_2; 
//	int record_schedule_tue_0; 
//	int record_schedule_tue_1; 
//	int record_schedule_tue_2; 
//	int record_schedule_wed_0;
//	int record_schedule_wed_1; 
//	int record_schedule_wed_2; 
//	int record_schedule_thu_0; 
//	int record_schedule_thu_1; 
//	int record_schedule_thu_2; 
//	int record_schedule_fri_0; 
//	int record_schedule_fri_1; 
//	int record_schedule_fri_2; 
//	int record_schedule_sat_0; 
//	int record_schedule_sat_1; 
//	int record_schedule_sat_2; 
//	int record_sd_status; 
//	int sdtotal;
//	int sdfree; 
//
//}STRU_SD_RECORD_PARAM, *PSTRU_SD_RECORD_PARAM;

/*
-------------AP WIFI结构-------------
apwifi_encrypt:加密认证模式：
0->无加密
1->WEP:不支持
2->WPA/AES
3->WPA/TKIP
4->WPA2/AES
5->WPA2/TKIP
apwifi_key:		  加密字符串
apwifi_ssid:	  无线AP的SSID
apwifi_ipaddr:	无线的IP地址
apwifi_mask:		无线的MASK
apwifi_startip:	无线的启动地址
apwifi_endip:	  无线的结束地址
*/
typedef struct tag_STRU_APWIFI_PARAM
{
	int apwifi_encrypt;
	int apswifi_port;
	char apwifi_key[64];
	char apwifi_ssid[64];
	char apwifi_ipaddr[32];
	char apwifi_mask[32];
	char apwifi_startip[32];
	char apwifi_endip[32];
}STRU_APWIFI_PARAM, *PSTRU_APWIFI_PARAM;

/*
------------登陆后返回数据---------
username 用户名
password 登陆密码
privilege 权限
*/
typedef struct tag_STRU_LOGIN_PARAM
{
	char username[32];
	char password[32];
	int privilege;			// 255:管理员
}STRU_LOGIN_PARAM, *PSTRU_LOGIN_PARAM;

typedef struct tag_STRU_SDCARD_RECORD_FILE
{
	int nFileCount;         // 总文件数量
    int nFileNo;            // 当前文件编号
    char szFileName[128];
	unsigned int nFileDate;
    int nFileSize;
}STRU_SDCARD_RECORD_FILE, *PSTRU_SDCARD_RECORD_FILE;

//#define MAX_RECORD_FILE_COUNT 128
typedef struct tag_STRU_RECORD_FILE_LIST
{
    int nCount;
    int nRecordCount;
    int nPageCount;
    int nPageIndex;
    int nPageSize;
    STRU_SDCARD_RECORD_FILE recordFile[MAX_RECORD_FILE_COUNT];

}STRU_RECORD_FILE_LIST, *PSTRU_RECORD_FILE_LIST;

#define PLAYBACK_START			4
#define PLAYBACK_STOP			0x11

// 录像播放
typedef struct tagCameraRecordFilePlay {
	char szFilename[128];	// 播放文件名
	int pos;				// 播放位置
	int mode;				// 播放模式 4->播放 17->停止播放
}CameraPlayRecordFile;

typedef void (STDCALL *SearchSdFilesCallbackV2)(const STRU_SDCARD_RECORD_FILE *pRecFile, void *pUser);

typedef struct tagSTRU_ONVIF_PARAM {
	int enable;		// 0/1: 未打开/打开
}STRU_ONVIF_PARAM, *PSTRU_ONVIF_PARAM;


typedef struct tagSTRU_RTSP_PARAM {
	int enable;		// 1/2: 打开/关闭
	int port;
	char user[64];
	char pwd[64];
	
}STRU_RTSP_PARAM, *PSTRU_RTSP_PARAM;

// 在线用户数
typedef struct tagSTRU_ONLINE_USER_PARAM {
	int p2pcount;
}STRU_ONLINE_USER_PARAM;


// IOS 推送设置结构
typedef struct tagSTRU_IOS_PUSH_PARAM{
    char token[96];
    int ID;
    int other;
}STRU_IOS_PUSH_PARAM;

//-----------------------报警摄像机--------------------
/*
 * 获取报警设备
 */
typedef struct tagSTRU_ALARM_CAM_CODE_STATUS {	
	int alarmCam;		// 表示当前状态：0->表示是否启用 1->表示正在校码 2->表示可以正常使用
	char alarmKey[32];	// 表示保存的无线码
	int alarmPtz;		// 表示是否启用了预置位
}STRU_ALARM_CAM_CODE_STATUS;

#define MAX_ALARM_CAM_SCENE		8
#define MAX_ALARM_CAM_ITEM		4
typedef struct tagSTRU_ALARM_CAM_LIST {
	STRU_ALARM_CAM_CODE_STATUS	list[MAX_ALARM_CAM_SCENE][MAX_ALARM_CAM_ITEM];
	int alarm_audio[MAX_ALARM_CAM_SCENE];		// 报警声音状态 0/1:关闭/打开报警声音
	int zone_arming;									// 布防 0/1:撤防/布防
}STRU_ALARM_CAM_CODE_LIST;

/*
 * 报警对码
 */
typedef struct tagSTRU_ALARM_CAM_CODE {
	int zone;		// 报警类型	0-7
	int sit;		// 同类型的报警个数	0-3
	int clearAll;	// 0/1:设置/清除全部
}STRU_ALARM_CAM_CODE, *PSTRU_ALARM_CAM_CODE;

/*
 * 设置报警对应的预置位
 */
typedef struct tagSTRU_ALARM_PTZ_CONTROL {
	int command;		// 30-61表示设置对应报警的位置		布防：10 撤防：11	20-27:分别对应报警0-7 zone的声音
	int audio_enable;	// 0-表示关闭音频  1-表示打开音频 
}STRU_ALARM_PTZ_CONTROL, *PSTRU_ALARM_PTZ_CONTROL;
//-----------------------报警摄像机 END--------------------

//-----------------------门铃------------------------
/*
 * 门铃控制
 */
typedef struct tagSTRU_DOOR_BELL_CONTROL {
	int cmd;		// 0/1 : 关闭/打开
}STRU_DOOR_BELL_CONTROL, *PSTRU_DOOR_BELL_CONTROL;

//-----------------------门铃 END--------------------

/*
 *厂商参数
 */
typedef struct tagSTRU_FACTORY_PARAM {
	char szDeviceID[32];		// 设备ID  小于64字符	 
	char szMac[32];				// mac地址	 
	char szServer[64]; 			// 厂家域名服务器	 
	char szUsername[64];		// 厂家域名账号	 
	char szUserPwd[64];			// 厂家域名密码	 
	int heartbeat; 				// 心跳间隔 	 
	int service_index;			// 厂家域名序列号	 
	int mode;					// 部分dns的模式	 
	char szWifiMac[32];			// wifi的MAC地址	 
	int port;					// 域名端口	 
	char szPnPServer[64];		// p2p的server 	 
	int pnpport; 				// p2p的端口
}STRU_FACTORY_PARAM, PSTRU_FACTORY_PARAM;

#endif