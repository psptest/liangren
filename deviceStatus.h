//
//  deviceStatus.h
//  secQre
//
//  Created by Sen5 on 16/10/27.
//  Copyright © 2016年 hsl. All rights reserved.
//

#ifndef deviceStatus_h
#define deviceStatus_h


#endif /* deviceStatus_h */

//"actions":[
//           {
//               "id":1,
//               "description":"onoff",
//               "param_length":1,
//               "params":{
//                   "level":[0, 1]
//               }
//           }，
//           {
//               "id":2,
//               "description":"level",
//               "param_length":3,
//               "params":{
//                   "level":[0, 255],
//                   "switch_priod":[0, 65535]
//               }
//           }
//           ]
//}


//{
//    "status_list":[
//                   {
//                       "id":0,
//                       "description":"unknown",
//                       "param_length":0,
//                       "params":null
//                   }，
//                   {
//                       "id":1,
//                       "description":"onoff",
//                       "param_length":1,
//                       "params":{
//                           "status":[0, 1]
//                       }
//                   }，
//                   {
//                       "id":2,
//                       "description":"feibit_sensor_status",
//                       "param_length":4,
//                       "params":{
//                           "status":[0, 1],
//                           "tamper":[0, 1],
//                           "low_battery":[0, 1],
//                           "weekly_report":[0, 1]
//                       }
//                   },
//                   {
//                       "id":3,
//                       "description":"feibit_temperature",
//                       "param_length":2,
//                       "params":{
//                           "temperature_int":[0, 255],
//                           "temprature_dec":[0,99]
//                       }
//                   },

//                   {
//                       "id":4,
//                       "description":"feibit_humidity",
//                       "param_length":2,
//                       "params":{
//                           "humidity_int":[0, 255],
//                           "humidity_dec":[0,99]
//                       }
//                   },
//                   {
//                       "id":5,
//                       "description":"device_group",
//                       "param_length":4,
//                       "params":{
//                           "group_id":[0, 4294967295]
//                       }
//                   },
//                   {
//                       "id":6,
//                       "description":"device_DID",
//                       "param_length":16,
//                       "params":{
//                           "did": "ascii string of 16 bytes"
//                       }
//                   },
//                   {
//                       "id":7,
//                       "description":"door sensor status",
//                       "param_length":1,
//                       "params":{
//                           "onoff": [0,1]
//                       }
//                   }，
//                   {
//                       "id":8,
//                       "description":"luminance",
//                       "param_length":3,
//                       "params":{
//                           "scale":[0,1]
//                           "value_int": [0,255],
//                           "value_dec": [0,99]
//                       }
//                   },
//                   {
//                       "id":9,
//                       "description":"home security",
//                       "param_length":1,
//                       "params":{
//                           "event": [1,8]
//                       }
//                   },
//                   {
//                       "id":10,
//                       "description":"zwave humidity",
//                       "param_length":3,
//                       "params":{
//                           "scale":[0,1]
//                           "value_int": [0,255],
//                           "value_dec": [0,99]
//                       }
//                   },
//                   {
//                       "id":11,
//                       "description":"water sensor",
//                       "param_length":1,
//                       "params":{
//                           "event": [1,4]
//                       }
//                   },
//                   {
//                       "id":12,
//                       "description":"CO alarm",
//                       "param_length":1,
//                       "params":{
//                           "event": [1,2]
//                       }
//                   },
//                   {
//                       "id":13,
//                       "description":"smoke alarm",
//                       "param_length":1,
//                       "params":{
//                           "event": [1,2]
//                       }
//                   },
//                   {
//                       "id":14,
//                       "description":"combustible gas alarm",
//                       "param_length":1,
//                       "params":{
//                           "event": [1,2]
//                       }
//                   },
//                   
//                   ]
//}



//{
//    "AC05E02100000":{
//        "dev_mode":1,
//        "description":"ZLL_light",
//        "action_ids":[1],
//        "status_ids":[1]
//    },
//    "A010402200000":{
//        "dev_mode":1,
//        "description":"ZHA/ZLL_light",
//        "action_ids":[1],
//        "status_ids":[1]
//    },
//    "A010400020000":{
//        "dev_mode":1,
//        "description":"ZHA_binary_switch",
//        "action_ids":[1],
//        "status_ids":[1]
//    },
//    "A010400090000":{
//        "dev_mode":1,
//        "description":"ZHA_outlet",
//        "action_ids":[1],
//        "status_ids":[1]
//    },
//    "A010400510000":{
//        "dev_mode":1,
//        "description":"ZHA_outlet_EU",
//        "action_ids":[1],
//        "status_ids":[1]
//    },
//    "A010401000000":{
//        "dev_mode":1,
//        "description":"ZHA_relay",
//        "action_ids":[1],
//        "status_ids":[1]
//    },
//    "A010404020000":{
//        "dev_mode":0,
//        "description":"ZHA_sensor",
//        "action_ids":[],
//        "status_ids":[2]
//    },
//    "A010404020015":{
//        "dev_mode":0,
//        "description":"ZHA_door_sensor",
//        "action_ids":[],
//        "status_ids":[2]
//    },
//    "A01040402000D":{
//        "dev_mode":0,
//        "description":"ZHA_PIR_sensor",
//        "action_ids":[],
//        "status_ids":[2]
//    },
//    "A010404020028":{
//        "dev_mode":0,
//        "description":"ZHA_smoke_sensor",
//        "action_ids":[],
//        "status_ids":[2]
//    },
//    "A01040402002B":{
//        "dev_mode":0,
//        "description":"ZHA_gas_sensor",
//        "action_ids":[],
//        "status_ids":[2]
//    },
//    "A010404028001":{
//        "dev_mode":0,
//        "description":"ZHA_CO_sensor",
//        "action_ids":[],
//        "status_ids":[2]
//    },
//    "A01040402002D":{
//        "dev_mode":0,
//        "description":"ZHA_quake_sensor",
//        "action_ids":[],
//        "status_ids":[2]
//    },
//    "A01040402002A":{
//        "dev_mode":0,
//        "description":"ZHA_water_sensor",
//        "action_ids":[],
//        "status_ids":[2]
//    },
//    "A010404020115":{
//        "dev_mode":0,
//        "description":"ZHA_secure_RC",
//        "action_ids":[],
//        "status_ids":[2]
//    },
//    "A01040402002C":{
//        "dev_mode":0,
//        "description":"ZHA_emergency_button",
//        "action_ids":[],
//        "status_ids":[2]
//    },
//    "A010404030225":{
//        "dev_mode":0,
//        "description":"ZHA_siren",
//        "action_ids":[],
//        "status_ids":[2]
//    },
//    "A010403020000":{
//        "dev_mode":0,
//        "description":"ZHA_humidity_temperature_sensor",
//        "action_ids":[],
//        "status_ids":[3] //temp
//    },
//    "A010403020000":{
//        "dev_mode":0,
//        "description":"ZHA_humidity_temperature_sensor",
//        "action_ids":[],
//        "status_ids":[4] //humidity
//    },
//    "B000000000001":{
//        "dev_mode":4,
//        "description":"misc_alarm",
//        "action_ids":[1],
//        "status_ids":[1]
//    },
//    "B000000000002":{
//        "dev_mode":4,
//        "description":"misc_ip_camera",
//        "action_ids":[],
//        "status_ids":[6]
//    }
//}
