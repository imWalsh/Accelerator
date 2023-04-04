
#import "JAsket.h"
#import <netinet/in.h>
#include <sys/types.h>
#include <arpa/nameser.h>
#include <resolv.h>
#include <arpa/inet.h>
//@import PPacketNative;
@import ShadowPath;

struct ssr_client_state *sState = NULL;

int socketPort (int fd) {
	struct sockaddr_in sin;
	socklen_t len = sizeof(sin);
	if (getsockname(fd, (struct sockaddr *)&sin, &len) < 0) {
		return 0;
	} else {
		return ntohs(sin.sin_port);
	}
}

@interface JAsket ()
{
	TunnelHandler _ssTunHandle;
	TunnelHandler _httpTunHandle;
	
	BOOL _isHttpRun;
}
@property(nonatomic, assign)NSInteger block_flag;
@property(nonatomic, assign)NSInteger collection_count;


- (void)httpTunnelHandle: (int)fd;
- (void)shadowsocksTunnelHandle:(int)fd;

@end


void ssHandler(int fd, void *udata) {
	JAsket *provider = (__bridge JAsket *)udata;
	[provider shadowsocksTunnelHandle:fd];
}

void httpTunHandler(int fd, void *udata) {
	JAsket *provider = (__bridge JAsket *)udata;
	[provider httpTunnelHandle:fd];
}


@implementation JAsket
{
	int _ssTunPort;
}


+ (JAsket *)shared {
	static dispatch_once_t onceToken;
	static JAsket *m;
	dispatch_once(&onceToken, ^{
		m = [JAsket new];
	});
	return m;
}

# pragma mark - http

- (void)httpTunnelServers:(NSURL*)httpURL completion:(TunnelHandler)completion {
	_httpTunHandle = [completion copy];
	NSAssert(httpURL, @"httpURL a valid!");
	[NSThread detachNewThreadSelector:@selector(httpActWithURL:) toTarget:self withObject:httpURL];
}

- (void)httpTunnelHandle:(int)fd {
	NSError *error;
	
	int httpProxyPort = 0;
	if (fd > 0) {
		httpProxyPort = socketPort(fd);
		_isHttpRun = YES;
	}else {
		error = [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier] code:100 userInfo:@{NSLocalizedDescriptionKey: @"fd xy"}];
	}
	if (_httpTunHandle) {
		_httpTunHandle(httpProxyPort, error);
	}
}

- (void)httpActWithURL:(NSURL *)confURL {
	struct forward_spec *proxy = NULL;
	if (_ssTunPort > 0) {
		proxy = calloc(1, sizeof(*proxy));
		proxy->type = SOCKS_5;
		proxy->gateway_host = "127.0.0.1";
		proxy->gateway_port = _ssTunPort;
	}
	shadowpath_main(strdup([[confURL path] UTF8String]), proxy, httpTunHandler, (__bridge void *)self);
}

- (void)endHttpTunnel {
	
}


# pragma mark - Shadowsocks

- (void)shadowsocksServers:(NSURL*)ssURL completion:(TunnelHandler)completion {
	_ssTunHandle = [completion copy];
	[NSThread detachNewThreadSelector:@selector(shadowsocksActwithURL:) toTarget:self withObject:ssURL];
}

- (void)shadowsocksTunnelHandle:(int)fd {
	NSError *error;
	if (fd > 0) {
		_ssTunPort = socketPort(fd);
	} else {
		error = [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier] code:100 userInfo:@{NSLocalizedDescriptionKey: @"fdy"}];
	}
	if (_ssTunHandle) {
		_ssTunHandle(_ssTunPort, error);
	}
}


- (void)endShadowsocks {
//	ssr_run_loop_shutdown(sState);
}

- (void)shadowsocksActwithURL:(NSURL*)proxyConfUrl {
	NSError *err1;
	
	NSError *err2;
	
	NSString *confContent = [NSString stringWithContentsOfURL:proxyConfUrl encoding:NSUTF8StringEncoding error:&err1];
	
	NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[confContent dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&err2];
	
	NSString *host = json[@"host"];
	NSNumber *port = json[@"port"];
	NSString *password = json[@"password"];
	NSString *authscheme = json[@"authscheme"];
	NSString *protocol = json[@"protocol"];
	NSString *obfs = json[@"obfs"];
	NSString *obfs_param = json[@"obfs_param"];
	
	BOOL ota = [json[@"ota"] boolValue];
	if (host && port && password && authscheme) {
		
		profile_t profile;
		memset(&profile, 0, sizeof(profile_t));
		
		profile.remote_host = strdup([host UTF8String]);
		profile.remote_port = [port intValue];
		profile.password = strdup([password UTF8String]);
		profile.method = strdup([authscheme UTF8String]);
		profile.local_addr = "127.0.0.1";
		profile.local_port = 0;
		profile.timeout = 600;
		profile.auth = ota;
		if (protocol.length > 0) {
			profile.protocol = strdup([protocol UTF8String]);
		}
		if (obfs.length > 0) {
			profile.obfs = strdup([obfs UTF8String]);
		}
		if (obfs_param.length > 0) {
			profile.obfs_param = strdup([obfs_param UTF8String]);
		}
		start_ss_local_server(profile, ssHandler, (__bridge void *)self);
	} else {
		if (_ssTunHandle) {
			_ssTunHandle(0, nil);
		}
		return;
	}
}

#pragma mark --

+ (NSArray *)dns {
	res_state res = malloc(sizeof(struct __res_state));
	res_ninit(res);
	
	NSMutableArray *servers = [NSMutableArray array];
	for (int i = 0; i < res->nscount; i++) {
		sa_family_t family = res->nsaddr_list[i].sin_family;
		char str[INET_ADDRSTRLEN + 1];
		if (family == AF_INET) {
			inet_ntop(AF_INET, & (res->nsaddr_list[i].sin_addr.s_addr), str, INET_ADDRSTRLEN);
			str[INET_ADDRSTRLEN] = '\0';
			NSString *address = [[NSString alloc] initWithCString:str encoding:NSUTF8StringEncoding];
			if (address.length) {
				[servers addObject:address];
			}
		}
	}
	res_ndestroy(res);
	free(res);
	return servers;
}

@end

