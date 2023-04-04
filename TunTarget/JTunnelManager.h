#import <Foundation/Foundation.h>
@class NEPacketTunnelFlow;
NS_ASSUME_NONNULL_BEGIN
@interface TXTunnelManager : NSObject
+ (void)shadowsocksServer:(void(^)(NSInteger port))completionHandler;
+ (void)httpServer:(void(^)(NSInteger port))completionHandler;
+ (void)openTunnel:(NEPacketTunnelFlow *)packetFlow _:(void(^)(NSError *error))completionHandler;
+ (void)closeTunnel;
@end
NS_ASSUME_NONNULL_END
