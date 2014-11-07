
#import <Foundation/Foundation.h>
#import "InstagramUser.h"
#import <Parse/Parse.h>

@interface InstagramPhoto : PFObject <PFSubclassing>

@property NSString* title;
@property InstagramUser *owner;
@property NSDate *publishedDate;
@property UIImageView *instaPhoto;
@property PFFile *parsePhoto;

@end
