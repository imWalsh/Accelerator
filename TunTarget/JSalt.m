//
//  JSalt.m
//  TunTarget
//
//  Created by Walsh on 2022/11/20.
//

#import "JSalt.h"
#import "JCommon.h"
#include "ssr_cipher_names.h"

@interface JSalt()

@property (nonatomic, copy) NSArray *params;

@end


@implementation JSalt

- (NSString *)server {
	if(!_server) {
		_server = @"";
	}
	return _server;
}

- (int)serverPort {
	if(!_serverPort) {
		_serverPort = 443;
	}
	return _serverPort;
}

- (NSString *)remarks {
	if(!_remarks) {
		_remarks = @"";
	}
	return _remarks;
}

- (NSString *)password {
	if(!_password) {
		_password = @"";
	}
	return _password;
}

- (NSString *)method {
	if(!_method) {
		_method = [NSString stringWithUTF8String:ss_cipher_name_of_type(ss_cipher_aes_256_cfb)];
	}
	return _method;
}

- (NSString *)protocol {
	if(!_protocol) {
		_protocol = [NSString stringWithUTF8String:ssr_protocol_name_of_type(ssr_protocol_origin)];
	}
	return _protocol;
}

- (NSString *)protocolParam {
	if(!_protocolParam) {
		_protocolParam = @"";
	}
	return _protocolParam;
}

- (NSString *)obfs {
	if(!_obfs) {
		_obfs = [NSString stringWithUTF8String:ssr_obfs_name_of_type(ssr_obfs_plain)];
	}
	return _obfs;
}

- (NSString *)obfsParam {
	if(!_obfsParam) {
		_obfsParam = @"";
	}
	return _obfsParam;
}

- (NSString *)ot_domain {
	if(!_ot_domain) {
		_ot_domain = @"";
	}
	return _ot_domain;
}

- (NSString *)ot_path {
	if(!_ot_path) {
		_ot_path = @"";
	}
	return _ot_path;
}

- (int)listenPort {
	if(!_listenPort) {
		_listenPort = 0;
	}
	return _listenPort;
}

- (BOOL)ot_enable {
	if(!_ot_enable) {
		_ot_enable = NO;
	}
	return _ot_enable;
}


#pragma mark -

- (NSString *)serverString {
	if(!_serverString) {
		_serverString = [self param:0];
	}
	return _serverString;
}

- (NSString *)serverPortString {
	if(!_serverPortString) {
		_serverPortString = [self param:1];
	}
	return _serverPortString;
}

- (NSString *)remarksString {
	if(!_remarksString) {
		_remarksString = @"remarks";
	}
	return _remarksString;
}

- (NSString *)passwordString {
	if(!_passwordString) {
		_passwordString = [self param:2];
	}
	return _passwordString;
}

- (NSString *)methodString {
	if(!_methodString) {
		_methodString = [self param:3];
	}
	return _methodString;
}

- (NSString *)protocolString {
	if(!_protocolString) {
		_protocolString = [self param:5];
	}
	return _protocolString;
}

- (NSString *)protocolParamString {
	if(!_protocolParamString) {
		_protocolParamString = [self param:6];
	}
	return _protocolParamString;
}

- (NSString *)obfsString {
	if(!_obfsString) {
		_obfsString = [self param:7];
	}
	return _obfsString;
}

- (NSString *)obfsParamString {
	if(!_obfsParamString) {
		_obfsParamString = [self param:8];
	}
	return _obfsParamString;
}

- (NSString *)listenPortString {
	if(!_listenPortString) {
		_listenPortString = @"listen_port";
	}
	return _listenPortString;
}

- (NSString *)ot_enableString {
	if(!_ot_enableString) {
		_ot_enableString = [self param:9];
	}
	return _ot_enableString;
}

- (NSString *)ot_domainString {
	if(!_ot_domainString) {
		_ot_domainString = [self param:10];
	}
	return _ot_domainString;
}

- (NSString *)ot_pathString {
	if(!_ot_pathString) {
		_ot_pathString = [self param:11];
	}
	return _ot_pathString;
}



- (NSArray *)params {
	if (!_params) {
		_params = @[
			@"X/vDz82vq+pEfC5bggKx6g==",
			@"4jPHiEVLyR8qfVBJykdKSw==",
			@"GFhHyulC9rz4FeX0YmJNqQ==",
			@"wkk4Yk3r/LrCNfdfiRm0KQ==",
			@"PitkMqIKIBh8o37lP4M6Zw==",
			@"N6uA9RqYs1elbw5lzeuAdA==",
			@"qiw0jSEVPMCUQg9ZLuJ9aQ==",
			@"QPEi/ziSJSwz57B/c1BJQg==",
			@"McIV31ZyAMNyUiefJ1DZOA==",
			@"AOLLg5R0JwLjlG9AuqYVPA==",
			@"P7S7FE9laakJmA4/3hF1EA==",
			@"bbZQSixjOjNATJVPCWEG2w=="
		];
	}
	return _params;
}

#pragma mark --

+ (instancetype)shared {
	static JSalt *instance;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		instance = [[super allocWithZone:NULL] init];
	});
	return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
	return [JSalt shared];
}

- (id)copyWithZone:(struct _NSZone *)zone {
	return [JSalt shared];
}

- (instancetype)initWithDic:(NSDictionary *)dic {
	if (self = [super init]) {
		self.server = dic[self.serverString] ?: @"";
		self.serverPort = [dic[self.serverPortString] intValue] ?: 443;
		self.remarks = dic[self.remarksString] ?: @"";
		self.password = dic[self.passwordString] ?: @"";
		self.method = dic[self.methodString] ?: @"";
		self.protocol = dic[self.protocolString] ?: @"";
		self.protocolParam = dic[self.protocolParamString] ?: @"";
		self.obfs = dic[self.obfsString] ?: @"";
		self.obfsParam = dic[self.obfsParamString] ?: @"";
		self.listenPort = [dic[self.listenPortString] intValue] ?: 443;
		self.ot_enable = [dic[self.ot_enableString] boolValue]?: NO;
		self.ot_domain = dic[self.ot_domainString] ?: @"";
		self.ot_path = dic[self.ot_pathString] ?: @"";
	}
	return self;
}

- (instancetype)initWithData:(NSData *)data {
	if (self = [super init]) {
		NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
		if (obj) {
			self = [self initWithDic:obj];
		}
	}
	return [self.class shared];
}

- (NSString *)param:(int)index {
	JCommon *crypt = [JCommon shared];
	[crypt loadAlgo:kCCAlgorithmAES];
	NSString *str = [crypt decrypt:self.params[index] key:@"agrees" iv:[[NSData alloc] initWithBytes:0 length:0]];
	return str;
}

- (NSMutableDictionary *)JSONDictionary {
	NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
	
	dic[self.serverString] = self.server;
	dic[self.serverPortString] = @(self.serverPort);
	dic[self.remarksString] = self.remarks;
	dic[self.passwordString] = self.password;
	dic[self.methodString] = self.method;
	dic[self.protocolString] = self.protocol;
	dic[self.protocolParamString] = self.protocolParam;
	dic[self.obfsString] = self.obfs;
	dic[self.obfsParamString] = self.obfsParam;
	dic[self.listenPortString] = @(self.listenPort);
	dic[self.ot_enableString] = @(self.ot_enable);
	dic[self.ot_domainString] = self.ot_domain;
	dic[self.ot_pathString] = self.ot_path;
	
	return dic;
}

@end
