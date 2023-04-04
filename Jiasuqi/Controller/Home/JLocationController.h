#import "JController.h"
@class JLocationModel;

NS_ASSUME_NONNULL_BEGIN

@interface JLocationController : JController
@property (nonatomic, strong) NSMutableArray<JLocationModel *> *datas;
@end

NS_ASSUME_NONNULL_END
