#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface JTimer : NSObject

- (instancetype)initWithTimeInterval:(NSTimeInterval)start interval:(NSTimeInterval)ti target:(id)t selector:(SEL)s userInfo:(nullable id)ui repeats:(BOOL)rep;
+ (JTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo;
+ (JTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)(JTimer *timer))block;
- (void)resume;
- (void)suspend;
- (void)invalidate;

@property (readonly) BOOL repeats;
@property (readonly) NSTimeInterval timeInterval;
@property (readonly, getter=isValid) BOOL valid;
@property (nullable, readonly, retain) id userInfo;

@end
NS_ASSUME_NONNULL_END
