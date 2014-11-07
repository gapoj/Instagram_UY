
#import <Foundation/Foundation.h>

#import <Parse/Parse.h>

@interface InstagramUser: PFObject <PFSubclassing>

@property NSString *name;
@property NSString *email;
@property NSString *password;

@end
