#import "JTunnelProvider.h"
#import "JPacketManager.h"
#import "JAsket.h"
#import "JCommon.h"
@import CocoaAsyncSocket;
@import PacketProcessor;

@interface JTunnelProvider()<GCDAsyncSocketDelegate>

@property (nonatomic, copy) void (^startCompletionHandler)(NSError *);
@property (nonatomic, copy) void (^stopCompletionHandler)(void);
@property (nonatomic, assign) NSInteger sPort;
@property (nonatomic, assign) NSInteger hPort;
@property (nonatomic, strong) GCDAsyncSocket *sock;
@property (nonatomic, strong) NWPath *dfPath;

@end

@implementation JTunnelProvider
- (void)settings:(void (^)(NSError *error))handler {
	
	NSAssert(self.hPort > 0, @"hPort is nil");
	
	NEIPv4Settings *ipv4Settings = [[NEIPv4Settings alloc] initWithAddresses:@[@"192.0.2.1"] subnetMasks:@[@"255.255.255.0"]];
	
	ipv4Settings.includedRoutes = @[[NEIPv4Route defaultRoute]];
	
	NEPacketTunnelNetworkSettings *settings = [[NEPacketTunnelNetworkSettings alloc] initWithTunnelRemoteAddress:@"192.0.2.2"];
	
	settings.IPv4Settings = ipv4Settings;
	
	settings.MTU = @(TunnelMTU);
	
	NEProxySettings* proxySettings = [[NEProxySettings alloc] init];
	NSString *proxyServerName = @"localhost";
	
	proxySettings.HTTPEnabled = YES;
	
	proxySettings.HTTPServer = [[NEProxyServer alloc] initWithAddress:proxyServerName port:self.hPort];//
	
	proxySettings.HTTPSEnabled = YES;
	
	proxySettings.HTTPSServer = [[NEProxyServer alloc] initWithAddress:proxyServerName port:self.hPort];//
	
	proxySettings.excludeSimpleHostnames = YES;
	
	settings.proxySettings = proxySettings;
	
	NSArray *dnsServers = [JAsket dns];
	
	NEDNSSettings *dnsSettings = [[NEDNSSettings alloc] initWithServers:dnsServers];
	dnsSettings.matchDomains = @[@""];
	settings.DNSSettings = dnsSettings;
	[self setTunnelNetworkSettings:settings completionHandler:^(NSError * _Nullable error) {
		if (handler) {
			handler(error);
		}
	}];
}


- (void)startTunnelWithOptions:(NSDictionary *)options completionHandler:(void (^)(NSError *))completionHandler {
	[[JCommon shared] openLog];
	
	NSError *error = [TunnelInterface setupWithPacketTunnelFlow:self.packetFlow];
	if (error) {
		completionHandler(error);
		exit(1);
		return;
	}
	self.startCompletionHandler = completionHandler;
	[self startProxies];
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[self startPacketForwarders];
	});
}

- (void)startProxies {
	[self startShadowsocks];
	[self startHttpProxy];
	[self startSocksProxy];
}

- (void)startShadowsocks {
	[JPacketManager shadowsocksServers:^(NSInteger port) {
		self.sPort = port;
	}];
}

- (void)startHttpProxy {
	[JPacketManager httpServers:^(NSInteger port) {
		self.hPort = port;
	}];
}

- (void)startSocksProxy {
	self.sock = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(0, 0)];
	
	[self.sock acceptOnInterface:@"127.0.0.1" port:0 error:nil];
}

- (void)stopTunnelWithReason:(NEProviderStopReason)reason completionHandler:(void (^)(void))completionHandler {
	completionHandler();
	
	self.stopCompletionHandler = completionHandler;
	
	[JPacketManager stopServer];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
	if ([keyPath isEqualToString:@"defaultPath"]) {
		if (![self.defaultPath isEqualToPath:self.dfPath] && self.defaultPath.status == NWPathStatusSatisfied) {
			if (!self.dfPath) {
				self.dfPath = self.defaultPath;
			} else {
				dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
					[self settings:nil];
				});
			}
		}else {
			self.dfPath = self.defaultPath;
		}
	}
}

- (void)startPacketForwarders {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tun2SocksStopped) name:kTun2SocksStoppedNotification object:nil];
	
	__weak typeof(self) weakSelf = self;
	[self settings:^(NSError *error) {
		
		__strong typeof(self) strongSelf = weakSelf;
		if (error == nil) {
			NSAssert(self.sPort > 0, @"sPort is nil");
			
			[weakSelf addObserver:weakSelf forKeyPath:@"defaultPath" options:NSKeyValueObservingOptionInitial context:nil];
			[TunnelInterface startTun2Socks:(int)self.sPort];
			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
				[TunnelInterface processPackets];
			});
		}
		if (strongSelf.startCompletionHandler) {
			strongSelf.startCompletionHandler(error);
			strongSelf.startCompletionHandler = nil;
		}
	}];
	
}

- (void)tun2SocksStopped {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	if (self.stopCompletionHandler) {
		self.stopCompletionHandler();
		
		self.stopCompletionHandler = nil;
	}
	[self cancelTunnelWithError:nil];
	
	exit(EXIT_SUCCESS);
}

- (void)wake {
	
}

- (void)sleepWithCompletionHandler:(void (^)(void))completionHandler {
	completionHandler();
}

- (void)handleAppMessage:(NSData *)messageData completionHandler:(void (^)(NSData *))completionHandler {
	if (completionHandler != nil) {
		completionHandler(nil);
	}
}

#pragma mark - GCDAsyncSocket Delegate

- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket {
	self.sock = newSocket;
}
@end
