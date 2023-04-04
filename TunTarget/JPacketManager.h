//
//  JPacketManager.h
//  TunTarget
//
//  Created by Walsh on 2022/11/20.
//

#import <Foundation/Foundation.h>
@class NEPacketTunnelFlow;

NS_ASSUME_NONNULL_BEGIN

@interface JPacketManager : NSObject

+ (void)shadowsocksServers:(void(^)(NSInteger port))completionHandler;

+ (void)httpServers:(void(^)(NSInteger port))completionHandler;

+ (void)startTunn:(NEPacketTunnelFlow *)packetFlow _:(void(^)(NSError *error))completionHandler;

+ (void)stopServer;

@end

NS_ASSUME_NONNULL_END
