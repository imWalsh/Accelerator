#ifndef Constant_h
#define Constant_h


#define KEY_TOKEN				@"KEY_TOKEN"

#define KEY_UID					@"KEY_UID"

#define KEY_PID					@"KEY_PID"
#define KEY_NID					@"KEY_NID"
#define KEY_CONNECT				@"KEY_CONNECT"
#define KEY_NOTIFY				@"KEY_NOTIFY"
#define KEY_TIMEOUT				@"KEY_TIMEOUT"


#define MAIN_BUNDLE             [NSBundle mainBundle]
#define APPLICATION             [UIApplication sharedApplication]
#define SCREEN_WIDTH        	[UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT       	[UIScreen mainScreen].bounds.size.height
#define USER_DEFAULTS       	[NSUserDefaults standardUserDefaults]
#define NOTIFICATION_CENTER    	[NSNotificationCenter defaultCenter]
#define APP_NAME				[MAIN_BUNDLE objectForInfoDictionaryKey:@"CFBundleDisplayName"]




#define __Log(s,...)    		NSLog(@"<%p %@:(%d)> %s : %@", self, \
[[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, __func__, \
[NSString stringWithFormat:(s), ##__VA_ARGS__])



#define kThemeColor									[UIColor colorWithHex:0xE23AF1]
#define kNormalColor								[UIColor colorWithHex:0xB5AEBE]
#define kTintColor									[UIColor colorWithHex:0x66F0F6]
#define kBackgroundColor							[UIColor colorWithHex:0x171327]

#define kJNetStatusChangedNotification				@"JNetStatusChangedNotification"
#define kJLocationChangedNotification				@"JLocationChangedNotification"
#define kJSignChangedNotification					@"JSignChangedNotification"
#define kJVPNStatusChangeNotification				@"JVPNStatusChangeNotification"
#define kJAddSpeedNotification						@"JAddSpeedNotification"


#endif 
