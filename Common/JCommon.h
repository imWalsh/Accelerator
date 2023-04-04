//
//  JCommon.h
//
//  Created by Walsh on 2022/11/20.
//

#import <Foundation/Foundation.h>
@import CommonCrypto;

NS_ASSUME_NONNULL_BEGIN

@interface JCommon : NSObject

+ (instancetype)shared;

- (void)loadAlgo:(uint32_t)algorithm;
- (NSString *)encrypt:(NSString *)dataStr key:(NSString *)key iv:(NSData *)iv;
- (NSString *)decrypt:(NSString *)dataStr key:(NSString *)key iv:(NSData *)iv;

+ (NSString *)groupID;
+ (NSURL *)ovpnURL;

- (void)openLog;

@end

NS_ASSUME_NONNULL_END
