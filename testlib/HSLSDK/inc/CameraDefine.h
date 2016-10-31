#ifndef _H_CAMERA_DEFINE_INC_
#define _H_CAMERA_DEFINE_INC_

#include "CommonDefine.h"

#define SET_PARAM_NETWORK	0x2000		// 设置网络参数 STRU_NETWORK_PARAMS
#define GET_PARAM_NETWORK	0x2001
#define SET_PARAM_USERINFO	0x2002		// 设置设备用户信息 STRU_USER_INFO
#define GET_PARAM_USERINFO	0x2003
#define SET_PARAM_DDNS		0x2004		// ddns参数  STRU_DDNS_PARAMS
#define GET_PARAM_DDNS		0x2005
#define SET_PARAM_FTP		0x2006		// ftp参数 STRU_FTP_PARAMS
#define GET_PARAM_FTP		0x2007
#define SET_PARAM_MAIL		0x2008		// mail参数 STRU_MAIL_PARAMS
#define GET_PARAM_MAIL		0x2009
#define SET_PARAM_PTZ		0x2010		// set_misc STRU_PTZ_PARAMS
#define GET_PARAM_PTZ		0x2011		// get_misc STRU_PTZ_PARAMS
#define SET_PARAM_WIFI		0x2012		// wifi参数 STRU_WIFI_PARAMS
#define GET_PARAM_WIFI		0x2013
#define GET_PARAM_WIFI_LIST 0x2014		// 获取wifi热点 STRU_WIFI_SEARCH_RESULT_LIST
#define SET_PARAM_DATETIME	0x2015		// 设置设备时钟 STRU_DATETIME_PARAMS
#define GET_PARAM_DATETIME  0x2016
#define SET_PARAM_ALARM		0x2017		// 设置报警参数 STRU_ALARM_PARAMS
#define GET_PARAM_ALARM		0x2018
#define GET_PARAM_RECORDSCH 0x2021		// 前端录像设置 STRU_RECORDSCH_PARAMS
#define SET_PARAM_RECORDSCH 0x2022
//#define GET_PARAM_SDFORMAT  0x2023
#define SET_PARAM_SDFORMAT  0x2024
#define GET_CAMERA_PARAMS	0x2025 //fixfix 2013-05-11 STRU_CAMERA_PARAMS
#define SET_CAMERA_PARAMS	0x2026 //fixfix 2013-05-11 STRU_CAMERA_CONTROL

#define SET_FACTORY_PARAM	0x2027

#define REBOOT_EDV			0x2700		// 重启设备
#define GET_PARAM_STATUS	0x2701		// 获取设备状态信息 STRU_STATUS_PARAMS
#define SET_PARAM_ALIAS		0x2702		// 设置设备名称 STRU_ALIAS_PARAMS

#define GET_PARAM_APWIFI	0x2703		// AP WIFI参数获取 STRU_APWIFI_PARAM
#define SET_PARAM_APWIFI	0x2704		// AP WIFI设置 STRU_APWIFI_PARAM

#define GET_LOGIN_PARAM		0x2705		// fix 2013-12-4

#define SEARCH_RECORD_FILE	0x2706		

#define WIFI_SCAN			0x2707
#define CHECK_USER			0x2708

#define GET_PARAM_ONVIF		0x2709		// STRU_ONVIF_PARAM
#define SET_PARAM_ONVIF		0x270A
#define GET_PARAM_RTSP		0x270B		// STRU_RTSP_PARAM
#define SET_PARAM_RTSP		0x270C
#define GET_PARAM_ONLINE_USER		0x270D		// STRU_ONLINE_USER_PARAM
#define GET_SNAPSHOT		0x270E

#define RESTORE_FACTORY		0x2710		// 恢复出厂设置
#define SET_IOS_PUSH        0x2711              // 设置IOS推送token STRU_IOS_PUSH_PARAM
#define SET_IOS_PUSH_STOP    0x2712              // 取消IOS推送token

#define GET_PARAM_ALARM_CAM_LIST		0x2713		// 获取报警设备对码列表 STRU_ALARM_CAM_CODE_LIST
#define SET_PARAM_ALARM_CAM_PRESET_CTRL	0x2714		// 设置报警对应的预置位 STRU_ALARM_PTZ_CONTROL
#define SET_PARAM_ALARM_CAM_CODE		0x2715		// 报警对码 STRU_ALARM_CAM_CODE

#define DOOR_BELL_CONTROL				0x2716		// 门铃控制 STRU_DOOR_BELL_CONTROL

#define SET_TRANSMIT_FILE					0x2717		// 升级固件 STRU_TRANSMIT_FILE
#define SET_TRANSMIT_FILE_PROGRESS			0x2718		// 已经传输数据量
#define SET_UPGRADE_FILE_CONFIRM			0x2719		// 确认升级 STRU_UPGRADE_FILE_CONFIRM
#define GET_PARAM_FILE_MD5					0x271A		// 获取文件MD5 输入文件名，返回32Bytes字符串
#define SET_DOOR_BELL_VOICE_LANGUAGE		0x271B		// 设备门铃播放声音的类型 STRU_DOOR_BELL_VOICE_LANGUAGE
#define GET_DOOR_BELL_VOICE_LANGUAGE		0x271C		// 获取门铃声音语言
#define SET_DOOR_BELL_MASTER_BUSY			0x271D		// 挂断门铃提示声音 STRU_DOOR_BELL_MASTER_BUSY

#define SET_PARAM_EXTRA						0x271E		// 设置extra参数 STRU_EXTRA_PARAM

#define ALARM_PRESET_SET1		30			// 报警预置位开始
#define ALARM_PRESET_SET32		61			// 报警预置位结束

#define GET_PARAM_ALARM_PTZ_LIST			0x271F		// 获取报警预置位设置详细 STRU_ALARM_PTZ_LIST
#define SET_PARAM_ALARM_PTZ					0x2720		// 设置报警预置位 STRU_ALARM_PTZ
#define SET_PARAM_CALL_ALARM_PTZ			0x2721		// 调用报警预置位 STRU_ALARM_PTZ_CALL

#define GET_PARAM_DOORBELL_USER				0x2722		// 获取门铃操作密码 STRU_DOOR_BELL_USER
#define SET_PARAM_DOORBELL_USER				0x2723		// 设置门铃操作密码 STRU_DOOR_BELL_USER
#define CHECK_DOORBELL_USER					0x2724		// 检验门铃操作密码 STRU_DOOR_BELL_USER

#define SEND_PARAM_SERIAL_DATA				0x2725		// 发送数据到串口
#define RECV_PARAM_SERIAL_DATA				0x2726		// 被动从串口接收数据

#define GET_RECORD_JPEG						0x2727		// 获取设备抓拍图片
#define SNAPSHOT_JPEG_IN_SD					0x2728		// 通知设备抓拍jpg图片
#define DEL_RECORD_FILE_IN_SD				0x2729		// 删除设备上的录像文件(不是所有设备都支持)

#define SET_PARAM_WAKE_WORD					0x272A		// 设置机器狗唤醒词
#define GET_PARAM_SMART_DOG					0x272B		// 获取机器狗唤醒词 STRU_SMART_DOG_PARAM

#define SET_PARAM_OKT_CONTROL_WIFI			0x272C		// STRU_OKT_CONTROL_WIFI
#define GET_PARAM_OKT_CONTROL_WIFI			0x272D		// STRU_OKT_PARAMS

#define SET_PARAM_ISMART					0x272E		// STRU_ISMART_PARAMS
#define GET_PARAM_ISMART					0x272F

#define GET_PARAM_MULTI_WIFI				0x2730		// STRU_MULTI_WIFI
#define SET_PARAM_MULTI_WIFI				0x2731

#define SET_PARAM_MAIL_TEST					0x2732		// 邮箱测试，必须是保存了邮箱设置后测试
#define MAIL_TEST							0x2733

#define GET_DEVICE_LOG						0x2734		// 获取设备日志	查询条件Search_File 数据回调SearchLogCallback
#define CLEAR_DEVICE_LOG					0x2735		// 清除设备日志

#define SET_SMART_RECORD					0x2736		// 设置、获取录像摘要 STRU_SMART_RECORD
#define GET_SMART_RECORD					0x2737

typedef struct tagSmartRecord {
	int smartrecord;	// 0--关闭摘要录像 1--打开摘要录像
}STRU_SMART_RECORD;

/*
 * 前端录像结构
 */
typedef struct tagPURecord
{
	int manual_record_enable;       // 0->停止，1->开始
	int reserved1;					// 备用
	int reserved2;					
}STRU_PU_RECORD;

/*
 * 时间结构
 */
typedef struct tagDateTime
{
	int nYear;
	int nMonth;
	int nDay;
	int nHour;
	int nMinute;
	int nSecond;
}AP_STRU_DateTime;

/*
 * 搜索录像时间结构
 */
typedef struct _Search_File_t
{
	AP_STRU_DateTime startTime;
	AP_STRU_DateTime endTime;
}Search_File;
typedef void (STDCALL *SearchSdFilesCallback)(const char *filename,const char *filedate, const unsigned int filelen, void *data);

typedef struct tagSTRU_EXTRA_PARAM
{
	int close_ap;
	int close_mic;
	int device_type;
	int max_file_count;	// SD卡格式化最大文件数
}STRU_EXTRA_PARAM;

/*
 * 挂断门铃提示
 */
typedef struct tagSTRU_DOOR_BELL_MASTER_BUSY
{
	int busy_flag;		// 1->挂断提示音
	char reserve[32];
}STRU_DOOR_BELL_MASTER_BUSY; 

/*
 * 门铃声音参数
 */
typedef struct tagSTRU_DOOR_BELL_VOICE_LANGUAGE
{
	int language;		// 0->静音 1->中文 2->英文 
	char reserve[32];
}STRU_DOOR_BELL_VOICE_LANGUAGE;

// 传输文件执行状态
typedef enum {
	TRANSMIT_FILE_STATUS_READY = 0,			// 准备传输
	TRANSMIT_FILE_STATUS_WORK,				// 正在传输
	TRANSMIT_FILE_STATUS_INVALID_RESULT,	// 设备应答无效结果
	TRANSMIT_FILE_STATUS_TIMEOUT,			// 传输超时
	TRANSMIT_FILE_STATUS_VER_MISMATCH,		// 版本不匹配
	TRANSMIT_FILE_STATUS_CANCEL,			// 传输取消
	TRANSMIT_FILE_STATUS_TRANSFER_ERR,		// 传输数据错误
	TRANSMIT_FILE_STATUS_OPEN_FILE_FAILED,	// 打开文件失败
	TRANSMIT_FILE_STATUS_MD5_ERR,			// MD5校验失败
	TRANSMIT_FILE_STATUS_TRANSFER_SUCC,		// 传输数据成功
}TRANSMIT_FILE_STATUS;

/*
 * 升级参数
 */
typedef struct tagSTRU_TRANSMIT_FILE
{
	char szPath[512];		// 完整的升级文件名(含路径)
	char szFilename[256];	// 升级文件名
	int FileType;			// 类型 1-系统固件，2-应用固件，3-证书文件 4-ZIP 5-TMP TTS
	char FileVer[32];		// 版本
	int FileSize;			// 文件大小
	char szMD5[32];			// md5值
	int ForceFlag;			// 1->强制升级,否则会和当前版本比较
}STRU_TRANSMIT_FILE;

/*
 * 升级文件确认
 */
typedef struct tagSTRU_UPGRADE_FILE_CONFIRM
{
	int confirm;	// 1->确认升级 0->取消升级
	char reserve[32];
}STRU_UPGRADE_FILE_CONFIRM;
 
/*
 * 摄像机音视频参数
 */
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
	char svalue[64];	// param=38,39时使用
}STRU_CAMERA_CONTROL,*PSTRU_CAMERA_CONTROL;

/*
 * 设备名称结构
 */
typedef struct tag_STRU_ALIAS_PARAMS
{
	char alias[64];
}STRU_ALIAS_PARAMS,*PSTRU_ALIAS_PARAMS;

/*
 * 设备状态
 */
typedef struct tag_STRU_STATUS_PARAMS
{
	char sys_ver[32];		// 固件版本号
	char alias[96];			// 设备别名
	char deviceid[32];		// 设备ID
	int alarm_status;		// 报警状态
	int sdcardstatus;		// SD卡状态
	int sdcardtotalsize;	// SD卡总容量
	int sdcardremainsize;	// SD卡剩余容量
	char mac[32];			// 网口mac地址
	char wifimac[32];		// 无线mac地址
	int dns_status;			// 
	int upnp_status;
	int wifi_status;		// 连接wifi状态 0->未连接 1->连接成功
	
	// smart dv
	int wdr;
	int awb;
	int expose;				//曝光
	int snapshotmode;		//抓图模式
	int recordint;			//录模模式
	int recordlap;			//循环录像
	int screensave;			//自动关机
	int recordres;			//录像分辨率
	int snapshotres;		//抓图分辨率
	int recordaudio;		//录像带音频
	int batter;				//电池
	int recordstatus;		// 录像状态
	int recordindex;		// 0->record 1->抓拍 2->定时录像 3->定时抓拍
	int recordact;			// 0->停止 1->启动
	int learstatus;			// 红外学习进度 smartdog
	
	// bat cam
	int batcapacity;		// 电池剩余容量，百分比
	int batstatus;			// 0---表示未充电，1---表示充电状态
	int pirtimes;
	int pirjpeg;			// 表示pir产生报警是抓图片
	int pirrecord;			// 表示PIR产生报警进行录像
	int messagerecord;		// 表示进行留言留影
	
}STRU_STATUS_PARAMS,*PSTRU_STATUS_PARAMS;

/*
 * 网络参数
 */
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

/*
 * 设备用户
 */
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
 * WIFI参数
 */
typedef struct tag_STRU_WIFI_PARAMS
{
	int enable;		// 0:disable wifi 1:enable
	char ssid[128];	// ssid，长度<= 40
	int channel;	// 
	int mode;		// Wifi模式  0->Infra 1->Adhoc
	int authtype;	// 0：禁止认证；：wep；：wpa tkip；：wpa aes；：wpa2 aes；：wpa2 tkip+aes
	int encrypt;	// wep 校验方式，：open；：share
	int keyformat;	// wep密钥格式，：进制数字；：ascii 字符
	int defkey;		// wep中密钥选择：-3
	char key1[128];	// wep密钥，长度<= 30
	char key2[128];	// wep密钥
	char key3[128];	// wep密钥
	char key4[128];	// wep密钥
	int key1_bits;	// wep密钥长度，：bits；：bits
	int key2_bits;	// wep密钥长度，：bits；：bits
	int key3_bits;	// wep密钥长度，：bits；：bits
	int key4_bits;	// wep密钥长度，：bits；：bits
	char wpa_psk[128];	// 密钥，长度<= 64
}STRU_WIFI_PARAMS,*PSTRU_WIFI_PARAMS;

/*
 * WIFI热点
 */
typedef struct tag_STRU_WIFI_SEARCH_RESULT
{
	char ssid[64];		// 热点名
	char mac[64];		// router的mac地址
	int security;		// 0->指WEP-NONE，1->指WEP，2->WPA-PSK TKIP
						// 3->WPA-PSK AES，4->WPA2-PSK TKIP，5->WPA2-PSK AES
	char dbm0[32];		// 信号强度
	char  dbm1[32];
	int mode;			// 指工作模式，0->infra 1->adhoc
	int channel;		// 无线通道号
}STRU_WIFI_SEARCH_RESULT,*PSTRU_WIFI_SEARCH_RESULT;
typedef struct tag_STRU_WIFI_SEARCH_RESULT_LIST
{
	int wifiCount;
	STRU_WIFI_SEARCH_RESULT wifi[32];
}STRU_WIFI_SEARCH_RESULT_LIST,*PSTRU_WIFI_SEARCH_RESULT_LIST;

/*
 * 设备时钟
 */
typedef struct tag_STRU_DATETIME_PARAMS
{
	int now;			// UTC时间 >0使用now校时
	int tz;				// 时区设置：和标准格林威治时间偏离的秒数
	int ntp_enable;		// 禁止ntp校时；：允许
	char ntp_svr[64];	// ntp服务器，长度<= 64 
	
	int dst_enable;		// 0->关闭  1->打开
	int dst_time;		// 单位分钟（0-180）
}STRU_DATETIME_PARAMS,*PSTRU_DATETIME_PARAMS;

/*
 * DDNS参数
 */
typedef struct tag_STRU_DDNS_PARAMS
{
	int service;		/* 0：禁止ddns服务
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
						*/
	char user[64];		// ddns用户，长度<= 64
	char pwd[64];		// ddns密码，长度<= 64
	char host[64];		// ddns域名，长度<= 64
	char proxy_svr[64];	// 代理服务器地址，长度<= 64
	int ddns_mode;		// 部份dns需要的模式
	int proxy_port;		// 代理服务器端口
	int ddns_status; 
}STRU_DDNS_PARAMS, *PSTRU_DDNS_PARAMS;

/*
 * FTP参数
 */
typedef struct tag_STRU_FTP_PARAMS
{
	char svr_ftp[64];	// ftp服务器地址，长度<= 64
	char user[64];		// ftp服务器登录用户，长度<= 64
	char pwd[64];		// ftp服务器登录密码，长度<= 64
	char dir[128];		// ftp服务器上的存储目录，长度<= 64
	int port;			// ftp服务器端口
	int mode;			// 0：port模式；：pasv模式
	int upload_interval;//
}STRU_FTP_PARAMS,*PSTRU_FTP_PARAMS;

/*
 * MAIL参数
 */
typedef struct tag_STRU_MAIL_PARAMS
{
	char svr[64];		// 邮件服务器地址，长度<= 64
	char user[64];		// 邮件服务器登录用户，长度<= 64
	char pwd[64];		// 邮件服务器登录密码，长度<= 64
	char sender[64];	// 邮件的发送者，长度<= 64
	char receiver1[64];	// 邮件的接收者，长度<= 64
	char receiver2[64];	// 邮件的接收者，长度<= 64
	char receiver3[64];	// 邮件的接收者，长度<= 64
	char receiver4[64];	// 邮件的接收者，长度<= 64	
	int port;			// 邮件服务端口
	int ssl;			// 1->表示支持ssl认证
	int smtpupload;		// 
}STRU_MAIL_PARAMS,*PSTRU_MAIL_PARAMS;

/*
 * 报警参数
 */
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
	int alarm_audio;		// 声音报警 0->禁止 1->高灵敏度 2->中灵敏度 3->低灵敏度(3518e support)
	int alarm_temp;			// 温度报警
    int pirenable;          // PIR检测
	int call_sound;			// 设置设备报警后是否播放声音
}STRU_ALARM_PARAMS,*PSTRU_ALARM_PARAMS;

/*
 * 云台参数
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

/*
 * 录像计划参数
 */
typedef struct tag_STRU_RECORDSCH_PARAMS
{
	int record_cover;	// 1->录像覆盖
	int record_time;	// 录像文件时间
	int record_size;
	int time_schedule_enable;	// 日程安排 

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
	int record_stream;		// 录像码流  0->主码流 1->次  2 ->次次 add 2015-8-26
	
}STRU_RECORDSCH_PARAMS,*PSTRU_RECORDSCH_PARAMS;

/*
 * AP WIFI参数
 */
typedef struct tag_STRU_APWIFI_PARAM
{
	int apwifi_encrypt;		/*加密认证模式：
								0->无加密
								1->WEP:不支持
								2->WPA/AES
								3->WPA/TKIP
								4->WPA2/AES
								5->WPA2/TKIP
							*/
	int apswifi_port;		// 
	char apwifi_key[64];	// 加密字符串
	char apwifi_ssid[64];	// 无线AP的SSID
	char apwifi_ipaddr[32];	// 无线的IP地址
	char apwifi_mask[32];	// 无线的MASK
	char apwifi_startip[32];// 无线的开始地址
	char apwifi_endip[32];	// 无线的结束地址
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

/*
 * 录像文件参数
 */
typedef struct tag_STRU_SDCARD_RECORD_FILE
{
	int nFileCount;         // 总文件数量
    int nFileNo;            // 当前文件编号
    char szFileName[128];
	unsigned int nFileDate;
    int nFileSize;
	int nFileType;			// 0->264 1->jpg
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

/* 
 * 录像播放控制参数
 */
typedef struct tagCameraRecordFilePlay {
	char szFilename[128];	// 播放文件名
	int pos;				// 播放位置
	int mode;				// 播放模式 4->播放 17->停止播放
}CameraPlayRecordFile;

typedef void (STDCALL *SearchSdFilesCallbackV2)(const STRU_SDCARD_RECORD_FILE *pRecFile, void *pUser);

/*
 * ONVIF参数
 */
typedef struct tagSTRU_ONVIF_PARAM {
	int enable;		// 0/1: 未打开/打开
}STRU_ONVIF_PARAM, *PSTRU_ONVIF_PARAM;

/*
 * RTSP参数
 */
typedef struct tagSTRU_RTSP_PARAM {
	int enable;		// 1/2: 打开/关闭
	int port;
	char user[64];
	char pwd[64];
	
}STRU_RTSP_PARAM, *PSTRU_RTSP_PARAM;

/*
 * 在线用户数
 */
typedef struct tagSTRU_ONLINE_USER_PARAM {
	int p2pcount;
}STRU_ONLINE_USER_PARAM;


/*
 * IOS 推送设置参数
 */
typedef struct tagSTRU_IOS_PUSH_PARAM{
    char token[96];
    int ID;
    int other;
}STRU_IOS_PUSH_PARAM;

//-----------------------报警摄像机--------------------
/*
 * 获取报警设备对码列表
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



/*
 * 报警预置位 2015.7.15 add
 */
typedef struct tagAlarmPTZ {
	int used;			// 预置位是否使用 0->未使用 1->已使用(设置无效，返回有效)
	int clear;			// 清除预置位为1，设置为0；
	int bound;			// 是否绑定报警点，绑定时为1，sit和zone为相应坐标。不绑定时为0；
	int sit;			//（8x4）坐标的横坐标（0-3）
	int zone;			//（8x4）坐标的纵坐标（0-7）
	int ptz_speed;		// 预置位速度
	int scene_type;		// 场景类型
	int number;			// 预置位号（0-31）
	char name[64];		// 预置位名称
}STRU_ALARM_PTZ;

#define MAX_ALARM_PTZ_COUNT	32
typedef struct tagAlarmPTZList {
	STRU_ALARM_PTZ items[MAX_ALARM_PTZ_COUNT];
}STRU_ALARM_PTZ_LIST;

/*
 * 报警预置位调用 2015.7.15 add
 */
typedef struct tagAlarmPTZCall {
	int number;			// 预置位号
	char reserve[4];	// 未用
}STRU_ALARM_PTZ_CALL;

//-----------------------报警摄像机 END--------------------

//-----------------------门铃------------------------
/*
 * 门铃控制
 */
typedef struct tagSTRU_DOOR_BELL_CONTROL {
	int cmd;		// 0/1 : 关闭/打开
}STRU_DOOR_BELL_CONTROL, *PSTRU_DOOR_BELL_CONTROL;

typedef struct tagSTRU_DOOR_BELL_USER {
	char username[32];
	char password[32];
}STRU_DOOR_BELL_USER;

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

/*
 * 机器狗唤醒词
 */
typedef struct tagSmartDogParam {
	char wakeword[128];
}STRU_SMART_DOG_PARAM;

/*
 * 奥卡特
 */
typedef struct {
	int cmd;		// 1上锁  2解锁  3开灯  4关灯  5开插座  6 关插座  7上行  8下行  9停止
	int value;		// 0关闭，1打开或者操作
}STRU_OKT_CONTROL_WIFI;

typedef struct {
	int wifi_lock;	// 1->上锁 0->解锁
	int wifi_light_status; 	// 1：灯开，0：灯关
	int wifi_socket_status;	// 开关   1 开  0 关
}STRU_OKT_PARAMS;


/*
 * ISMART定制
 */
typedef struct {
	int light_switch;		// 0->auto  1->on  2->off
	int light_manul_time;	// 1、3、6、8（建议四档）
	int light_auto_time;	// 10秒-120s
	int light_intensity;	// 灯光强度取值四档1 2 3 4（对应下发25 50 100 200）
	int adc_value;			// 取值范围，0-1023
	int pir_intensity;		// pir灵敏度  高中低三档(1, 2, 4)
}STRU_ISMART_PARAMS;

/*
 * 获取设置的wifi列表
 */
typedef struct _MultiWifi{
	char ssid0[64];
	char pwd0[64];
	char ssid1[64];
	char pwd1[64];
	char ssid2[64];
	char pwd2[64];
	char ssid3[64];
	char pwd3[64];
	char ssid4[64];
	char pwd4[64];
	int use_no;			// 当前使用的wifi的序号
}STRU_MULTI_WIFI;

// 设备日志回调
typedef void (STDCALL *SearchLogCallback)(int count, int index, unsigned int timestamp, int type, void *pUser);

#endif
