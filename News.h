
#import <Foundation/Foundation.h>
#import "InstagramUser.h"
#import <Parse/Parse.h>

@interface News  : PFObject <PFSubclassing>

@property NSString* newsText;
@property InstagramUser *owner;
@property NSDate *publishedDate;

@end
