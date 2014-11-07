//
//  ProfileViewController.m
//  InstagramUY
//
//  Created by Guillermo Apoj on 10/28/14.
//  Copyright (c) 2014 Course. All rights reserved.
//

#import "ProfileViewController.h"
#import "PhotoTableViewCell.h"
#import "FollowersViewController.h"
#import "FollowingViewController.h"
#import "MyCell.h"

@interface ProfileViewController ()<UITableViewDataSource,UITableViewDelegate, UICollectionViewDataSource,UICollectionViewDelegate>
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIImageView *myProfileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *secondView;
@property (strong, nonatomic) IBOutlet UIView *normalView;
- (IBAction)onSegmentedControlValueChanged:(UISegmentedControl *)sender;
@property (strong, nonatomic) IBOutlet UILabel *followersLabel;
@property (strong, nonatomic) IBOutlet UILabel *followingLabel;
@property NSMutableArray *photos;
- (IBAction)onFollowersButtonTapped:(UIButton *)sender;
- (IBAction)onFollowingButtonTapped:(id)sender;
- (IBAction)onLogout:(id)sender;

@end

@implementation ProfileViewController

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.photos.count
    ;
}

- (MyCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CELL" forIndexPath:indexPath];
    
    if (self.photos.count > 0) {
        InstagramPhoto *photo = [self.photos objectAtIndex:indexPath.row];
        PFFile *file =  photo.parsePhoto;
        if (file != nil) {
            [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                if (!error) {
                    cell.image.image = [UIImage imageWithData:data];
                    cell.image.contentMode = UIViewContentModeScaleAspectFit;
                }
            }];
        }
    }
    return cell;
}

- (void)refreshNumberLabels {
    self.nameLabel.text = self.user.name;
    PFQuery *queryFollowing = [Follower query];
    [queryFollowing whereKey:@"originUser" equalTo:self.user];
    [queryFollowing countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        self.followingLabel.text = @(number).description;
    }];
    
    PFQuery *queryFollower = [Follower query];
    [queryFollower whereKey:@"destinationUser" equalTo:self.user];
    [queryFollower countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        self.followersLabel.text = @(number).description;
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView registerNib:[UINib nibWithNibName:@"MyCell" bundle:nil] forCellWithReuseIdentifier:@"CELL"] ;
    self.photos = [NSMutableArray array];
    self.normalView.alpha=1;
    self.normalView.backgroundColor = [UIColor blackColor];
    self.secondView.backgroundColor = [UIColor blackColor];
    self.secondView.alpha = 0;
    [self refreshNumberLabels];
    [self loadUserPhotos];
}

-(void) loadUserPhotos
{
    PFQuery *photosQuery = [InstagramPhoto query];
    [photosQuery whereKey:@"owner" equalTo:self.user];
    [photosQuery findObjectsInBackgroundWithBlock:^(NSArray *photos, NSError *error) {
        for (InstagramPhoto *photo in photos) {
            [self.photos addObject:photo];
        }
        [self.tableView reloadData];
        self.collectionView.frame = CGRectMake(0, 0, 250, 300);
        [self.collectionView reloadData];
    }];
    
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
                    cell.myPhoto.contentMode = UIViewContentModeScaleAspectFit;
                }
            }];
        }
    }
    return cell;
}

- (IBAction)onSegmentedControlValueChanged:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        self.normalView.alpha =1;
        self.secondView.alpha = 0;
    } else {
        self.normalView.alpha =0;
        self.secondView.alpha = 1;
    }
}
- (IBAction)onFollowersButtonTapped:(UIButton *)sender {
    FollowersViewController *vc = [[FollowersViewController alloc] initWithNibName:@"FollowersViewController" bundle:nil];
    vc.user = self.user;
    [self showViewController:vc sender:self];
}

- (IBAction)onFollowingButtonTapped:(id)sender {
    FollowingViewController *vc = [[FollowingViewController alloc] initWithNibName:@"FollowingViewController" bundle:nil];
    vc.user = self.user;
    [self showViewController:vc sender:self];
}

- (IBAction)onLogout:(id)sender {
    [PFUser logOut];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end

