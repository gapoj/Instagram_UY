
#import <Foundation/Foundation.h>
#import "InstagramUser.h"
#import <Parse/Parse.h>

@interface Follower :  PFObject <PFSubclassing>

@property InstagramUser *originUser;
@property InstagramUser *destinationUser;

@end