
#import "Hashtags.h"

@implementation Hashtags

@dynamic photo;
@dynamic hashtagText;

+ (NSString*) parseClassName
{
    return @"Hashtag";
}

+(void) load
{
    [self registerSubclass];
}
@end
