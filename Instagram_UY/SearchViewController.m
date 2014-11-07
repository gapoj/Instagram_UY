
#import "SearchViewController.h"
#import "InstagramPhoto.h"
#import "InstagramUser.h"
#import "PhotoTableViewCell.h"
#import "UserTableViewCell.h"
#import "Follower.h"
#import "News.h"
#import "Hashtags.h"

@interface SearchViewController () <UISearchBarDelegate,UITableViewDelegate, UITableViewDataSource,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *mySegment;
@property NSArray *photos;
@property NSArray *users;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (self.mySegment.selectedSegmentIndex == 0) {
        [self loadUsers: searchBar.text];
    }else if (self.mySegment.selectedSegmentIndex ==1)
    {
        [self loadPhotos: searchBar.text];
    }else if (self.mySegment.selectedSegmentIndex ==2){
        [self loadPhotosByHashtag: searchBar.text];
    }
}

-(void) loadUsers: (NSString*)name
{
    PFQuery *queryUsers = [InstagramUser query];
    [queryUsers whereKey:@"name" equalTo:name];
    [queryUsers findObjectsInBackgroundWithBlock:^(NSArray *usersLoaded, NSError *error) {
        self.users = usersLoaded;
        [self.myTableView reloadData];
        [self.view endEditing:YES];
    }];
}

-(void) loadPhotos: (NSString*)title
{
    PFQuery *queryPhotos = [InstagramPhoto query];
    [queryPhotos whereKey:@"title" equalTo:title];
    [queryPhotos findObjectsInBackgroundWithBlock:^(NSArray *photosLoaded, NSError *error) {
        self.photos = photosLoaded;
        [self.myTableView reloadData];
        [self.view endEditing:YES];
    }];
    
}

-(void) loadPhotosByHashtag: (NSString*)text
{
    PFQuery *queryPhotos = [Hashtags query];
    [queryPhotos whereKey:@"hashtagText" equalTo:text];
    [queryPhotos includeKey:@"photo"];
    [queryPhotos findObjectsInBackgroundWithBlock:^(NSArray *hashtags, NSError *error) {
        NSMutableArray *photos = [NSMutableArray array];
        for (Hashtags *hashtag in hashtags) {
            [photos addObject:hashtag.photo];
        }
        self.photos = photos;
        [self.myTableView reloadData];
        [self.view endEditing:YES];
    }];
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.mySegment.selectedSegmentIndex == 0) {
        self.myTableView.rowHeight = 44;
        return self.users.count;
    }else
    {
        self.myTableView.rowHeight = 250;
        return self.photos.count;
    }
}

- (UserTableViewCell *)createViewCellForUsers:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    UserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserCell"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"UserTableViewCell" bundle:nil] forCellReuseIdentifier:@"UserCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"UserCell"];
        
    }
    if (self.users.count > 0) {
        InstagramUser *instaUser = [self.users objectAtIndex:indexPath.row];
        cell.textLabel.text = instaUser.name;
        UIButton *addFriendButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        addFriendButton.tag =indexPath.row;
        addFriendButton.frame = CGRectMake(300.0f, 5.0f, 75.0f, 30.0f);
        [addFriendButton setTitle:@"+" forState:UIControlStateNormal];
        addFriendButton.titleLabel.font = [UIFont systemFontOfSize:25];
        [cell addSubview:addFriendButton];
        [addFriendButton addTarget:self
                            action:@selector(addFriend:)
                  forControlEvents:UIControlEventTouchUpInside];
        
    }
    return cell;
}

- (PhotoTableViewCell *)createViewCellForPhotos:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.mySegment.selectedSegmentIndex == 0) {
        UserTableViewCell *cell;
        cell = [self createViewCellForUsers:tableView indexPath:indexPath];
        return cell;
    }else
    {
        PhotoTableViewCell *cell;
        cell = [self createViewCellForPhotos:tableView indexPath:indexPath];
        return cell;
    }
}

- (void)addFollowingNew:(Follower *)follower
{
    News * followingNew = [News object];
    followingNew.owner = self.user;
    followingNew.publishedDate = [NSDate date];
    followingNew.newsText = [NSString stringWithFormat:@"You are now following to: %@", follower.destinationUser.name];
    [followingNew saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(error){
            NSLog(@"%@",error);
        }
    }];
}

- (void)addFollowerNew:(Follower *)follower
{
    News * followerNew = [News object];
    followerNew.owner = follower.destinationUser;
    followerNew.publishedDate = [NSDate date];
    followerNew.newsText = [NSString stringWithFormat:@"You have a new follower: %@", self.user.name];
    [followerNew saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(error){
            NSLog(@"%@",error);
        }
    }];
}

- (void)showAlertViewConfirmation
{
    UIAlertView *alertView =[[UIAlertView alloc] init];
    alertView.title = @"New Friend";
    alertView.message=@"You have added a new friend...!";
    [alertView addButtonWithTitle:@"OK"];
    [alertView show];
}

- (IBAction)addFriend:(UIButton *)sender
{
    Follower *follower =[Follower object];
    follower.originUser = self.user;
    follower.destinationUser = [self.users objectAtIndex:sender.tag];
    [follower saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(error){
            NSLog(@"%@",error);
        }else{
            [self addFollowingNew:follower];

            [self addFollowerNew:follower];
            
            [self showAlertViewConfirmation];
        }
    }];
}

@end
