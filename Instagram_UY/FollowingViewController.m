//
//  FollowingViewController.m
//  Instagram_UY
//
//  Created by Guillermo Apoj on 10/30/14.
//  Copyright (c) 2014 Maximiliano Casal. All rights reserved.
//

#import "FollowingViewController.h"
#import "FollowsTableViewCell.h"
@interface FollowingViewController ()<UITableViewDataSource,UITabBarDelegate>
- (IBAction)onBackButtonTapped:(UIButton *)sender;
@property NSArray * following;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation FollowingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title= @"Following";
    [self refreshDisplay];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) refreshDisplay
{
    PFQuery *followsQuery = [Follower query];
    
    [followsQuery whereKey:@"originUser" equalTo:self.user];
    [followsQuery includeKey:@"destinationUser"];
    [followsQuery findObjectsInBackgroundWithBlock:^(NSArray *followers, NSError *error) {
        if(error){
            NSLog(@"Error: %@",error);
        }else{
            self.following = followers;
            [self.tableView reloadData];
        }
    }
     ];
}

- (IBAction)onBackButtonTapped:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.following.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FollowsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FollowsCell"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"FollowsTableViewCell" bundle:nil] forCellReuseIdentifier:@"FollowsCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"FollowsCell"];
    }
    
    Follower * follow = self.following[indexPath.row];
    InstagramUser *user = follow[@"destinationUser"];
    
    cell.uiTextLabel.text = user.name;
    
    return cell;
}

@end
