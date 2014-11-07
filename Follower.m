
#import "Follower.h"

@implementation Follower

@dynamic originUser;
@dynamic destinationUser;


+ (NSString*) parseClassName
{
    return @"Follower";
}

+(void) load
{
    [self registerSubclass];
}
@end
