//
//  JSalt.h
//  TunTarget
//
//  Created by Walsh on 2022/11/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JSalt : NSObject

+ (instancetype)shared;
- (instancetype)initWithDic:(NSDictionary *)dic;
- (instancetype)initWithData:(NSData *)data;
- (NSMutableDictionary *)JSONDictionary;


@property (nonatomic, copy) NSString *serverString;
@property (nonatomic, copy) NSString *serverPortString;
@property (nonatomic, copy) NSString *remarksString;
@property (nonatomic, copy) NSString *passwordString;
@property (nonatomic, copy) NSString *methodString;
@property (nonatomic, copy) NSString *protocolString;
@property (nonatomic, copy) NSString *protocolParamString;
@property (nonatomic, copy) NSString *obfsString;
@property (nonatomic, copy) NSString *obfsParamString;
@property (nonatomic, copy) NSString *listenPortString;
@property (nonatomic, copy) NSString *ot_enableString;
@property (nonatomic, copy) NSString *ot_domainString;
@property (nonatomic, copy) NSString *ot_pathString;

@property (nonatomic, copy) NSString *server;
@property (nonatomic, assign) int serverPort; //443
@property (nonatomic, copy) NSString *remarks;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *method;
@property (nonatomic, copy) NSString *protocol;
@property (nonatomic, copy) NSString *protocolParam;
@property (nonatomic, copy) NSString *obfs;
@property (nonatomic, copy) NSString *obfsParam;
@property (nonatomic, copy) NSString *ot_domain;
@property (nonatomic, copy) NSString *ot_path;
@property (nonatomic, assign) int listenPort;
@property (nonatomic, assign) BOOL ot_enable;


@end

NS_ASSUME_NONNULL_END
