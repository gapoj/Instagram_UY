
#import <Foundation/Foundation.h>
#import "InstagramPhoto.h"
#import <Parse/Parse.h>

@interface Hashtags :  PFObject <PFSubclassing>

@property InstagramPhoto *photo;
@property NSString *hashtagText;

@end