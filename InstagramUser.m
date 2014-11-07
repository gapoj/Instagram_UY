
#import "InstagramUser.h"

@implementation InstagramUser
@dynamic email;
@dynamic password;
@dynamic name;

+ (NSString*) parseClassName
{
    return @"InstagramUser";
}

+(void) load
{
    [self registerSubclass];
}

@end
