
#import "News.h"

@implementation News
@dynamic newsText;
@dynamic owner;
@dynamic publishedDate;

+ (NSString*) parseClassName
{
    return @"News";
}

+(void) load
{
    [self registerSubclass];
}

@end