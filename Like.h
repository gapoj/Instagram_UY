
#import <Foundation/Foundation.h>
#import "InstagramUser.h"
#import "InstagramPhoto.h"
#import <Parse/Parse.h>
@interface Like :  PFObject <PFSubclassing>

@property InstagramUser *owner;
@property NSDate *publishedDate;
@property InstagramPhoto *photo;

@end