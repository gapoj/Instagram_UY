
#import <UIKit/UIKit.h>
#import "InstagramUser.h"
@interface PhotoViewController : UIViewController
@property InstagramUser *user;
@property (strong, nonatomic) IBOutlet UIImageView *myPhoto;
@end
