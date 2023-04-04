#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface JConfModel : NSObject
@property (nonatomic, copy) NSString *ip;
@property (nonatomic, copy) NSString *passwd;
@property (nonatomic, copy) NSString *port;
@property (nonatomic, assign) int obfs;
@property (nonatomic, assign) int method;
@property (nonatomic, assign) int protocol;
@end
NS_ASSUME_NONNULL_END
