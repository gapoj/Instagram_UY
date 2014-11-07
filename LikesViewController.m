#import "LikesViewController.h"
#import "Like.h"

@interface LikesViewController ()
@property (weak, nonatomic) IBOutlet UILabel *likesLabel;

@property (weak, nonatomic) IBOutlet UIImageView *myPhoto;
@end

@implementation LikesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLikesCount];
    [self loadImage];
}
- (void)loadImage {
    PFFile *file =  self.photo.parsePhoto;
    if (file != nil) {
        [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error) {
                self.myPhoto.image = [UIImage imageWithData:data];
            }
        }];
    }
}
-(void) setLikesCount
{
    PFQuery *queryLikes = [Like query];
    [queryLikes whereKey:@"photo" equalTo:self.photo];
    [queryLikes countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        self.likesLabel.text = @(number).description;
    }];
}

- (IBAction)onBackPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (IBAction)onAddLike:(id)sender {
    Like *like = [Like object];
    like.photo = self.photo;
    like.owner = self.user;
    like.publishedDate = [NSDate date];
    [like saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(error){
            NSLog(@"%@",error);
        }
    }];
}

@end
