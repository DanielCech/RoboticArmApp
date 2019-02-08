#import <Foundation/Foundation.h>

@interface DCExceptionHandler : NSObject

+ (BOOL)catchException:(void(^)(void))tryBlock error:(__autoreleasing NSError **)error;

@end
