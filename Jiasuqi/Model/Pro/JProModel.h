#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface JProModel : NSObject
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) BOOL loaded;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, assign) CGFloat des;
@property (nonatomic, assign) NSInteger pris;
@property (nonatomic, copy) NSString *ios_pris;
@property (nonatomic, copy) NSString *ios_code;
@property (nonatomic, copy) NSString *duration;
@property (nonatomic, copy) NSString *vip_name;
@property (nonatomic, copy) NSString *vip_dtitle;
@end
NS_ASSUME_NONNULL_END
