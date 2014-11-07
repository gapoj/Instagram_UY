
#import "HomeViewController.h"
#import "PhotoTableViewCell.h"
#import "InstagramUser.h"
#import "Follower.h"
#import "InstagramPhoto.h"
#import "LikesViewController.h"
#import "CommentsViewController.h"

@interface HomeViewController () <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>
@property NSMutableArray *photos;
@property NSArray* followings;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property InstagramPhoto *selectedPhoto;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.photos = [NSMutableArray array];
    [self loadFollowings];
}

- (void)addPhotosToParse: (NSString*)name user: (InstagramUser*) owner
{
    InstagramPhoto *instagramPhoto = [InstagramPhoto object];
    instagramPhoto.owner = owner;
    NSData* data = UIImageJPEGRepresentation([UIImage imageNamed:name], 0.5f);
    PFFile *imageFile = [PFFile fileWithData:data];
    instagramPhoto.parsePhoto = imageFile;
    instagramPhoto.title = @"Lion test";
    instagramPhoto.publishedDate = [NSDate date];
    [instagramPhoto saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(error){
            NSLog(@"%@",error);
        }
    }];
    
}

-(void) loadFollowings
{
    PFQuery *queryFollowing = [Follower query];
    [queryFollowing whereKey:@"originUser" equalTo:self.user];
    [queryFollowing findObjectsInBackgroundWithBlock:^(NSArray *followings, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
        }else
        {
            self.followings = followings;
            [self loadHomePhotos];
        }
    }];
    
}

-(void) loadHomePhotos
{
    for (Follower *following in self.followings) {
        PFQuery *photosQuery = [InstagramPhoto query];
        [photosQuery whereKey:@"owner" equalTo:following.destinationUser];
        [photosQuery findObjectsInBackgroundWithBlock:^(NSArray *photos, NSError *error) {
            for (InstagramPhoto *photo in photos) {
                [self.photos addObject:photo];
            }
            [self.tableView reloadData];
        }];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.photos.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PhotoCell"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"PhotoTableViewCell" bundle:nil] forCellReuseIdentifier:@"PhotoCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"PhotoCell"];
    }
    if (self.photos.count > 0) {
        InstagramPhoto *photo = [self.photos objectAtIndex:indexPath.row];
        PFFile *file =  photo.parsePhoto;
        if (file != nil) {
            [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                if (!error) {
                    cell.myPhoto.image = [UIImage imageWithData:data];
                }
            }];
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    InstagramPhoto *photo = [self.photos objectAtIndex:indexPath.row];
    if (photo!= nil) {
        self.selectedPhoto = photo;
        UIAlertView *alertView =[[UIAlertView alloc] init];
        alertView.title = @"Edit photo";
        alertView.message=@"Please select one option";
        [alertView addButtonWithTitle:@"Likes"];
        [alertView addButtonWithTitle:@"Comments"];
        [alertView addButtonWithTitle:@"Cancel"];
        alertView.delegate = self;
        [alertView show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        LikesViewController *vc = [[LikesViewController alloc] initWithNibName:@"LikesViewController" bundle:nil];
        vc.user = self.user;
        vc.photo = self.selectedPhoto;
        [self showViewController:vc sender:self];
    }else if (buttonIndex == 1){
        CommentsViewController *vc = [[CommentsViewController alloc] initWithNibName:@"CommentsViewController" bundle:nil];
        vc.user = self.user;
        vc.photo = self.selectedPhoto;
        [self showViewController:vc sender:self];
    }
}
@end