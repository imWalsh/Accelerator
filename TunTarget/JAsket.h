
#import <Foundation/Foundation.h>

typedef void(^TunnelHandler)(int port, NSError *error);

@interface JAsket : NSObject


@property(nonatomic, assign)int  		resMark;
@property(nonatomic, assign)long  		observeCount;
@property(nonatomic, assign)float  		addressSize;
@property(nonatomic, assign)double  	from_margin;


+ (JAsket *)shared;
 

- (void)httpTunnelServers:(NSURL*)httpURL completion:(TunnelHandler)completion;
- (void)shadowsocksServers:(NSURL*)ssURL completion:(TunnelHandler)completion;

- (void)endHttpTunnel;
- (void)endShadowsocks;

+ (NSArray *)dns;

@end
 
