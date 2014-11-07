
#import "Comment.h"

@implementation Comment
@dynamic title;
@dynamic owner;
@dynamic publishedDate;
@dynamic photo;


+ (NSString*) parseClassName
{
    return @"Comment";
}

+(void) load
{
    [self registerSubclass];
}

@end
