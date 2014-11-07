
#import "Like.h"

@implementation Like

@dynamic owner;
@dynamic publishedDate;
@dynamic photo;

+ (NSString*) parseClassName
{
    return @"Like";
}

+(void) load
{
    [self registerSubclass];
}

@end
