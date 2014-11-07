
#import "InstagramPhoto.h"

@implementation InstagramPhoto
@dynamic title;
@dynamic owner;
@dynamic publishedDate;
@dynamic instaPhoto;

+ (NSString*) parseClassName
{
    return @"InstagramPhoto";
}

+(void) load
{
    [self registerSubclass];
}

@end