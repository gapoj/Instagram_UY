//
//  FollowersViewController.m
//  Instagram_UY
//
//  Created by Guillermo Apoj on 10/29/14.
//  Copyright (c) 2014 Maximiliano Casal. All rights reserved.
//

#import "FollowersViewController.h"
#import "FollowsTableViewCell.h"

@interface FollowersViewController ()<UITableViewDataSource,UITableViewDelegate>
- (IBAction)onBackButtonTapped:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property NSArray * followers;
@end

@implementation FollowersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title= @"Followers";
    [self refreshDisplay];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) refreshDisplay
{
    PFQuery *followsQuery = [Follower query];
   
    [followsQuery whereKey:@"destinationUser" equalTo:self.user];
    [followsQuery includeKey:@"originUser"];
    [followsQuery findObjectsInBackgroundWithBlock:^(NSArray *followers, NSError *error) {
        if(error){
            NSLog(@"Error: %@",error);
        }else{
            self.followers = followers;
            [self.tableView reloadData];
            
                }
        
            
        }
    ];
}

- (IBAction)onBackButtonTapped:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        //
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.followers.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FollowsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FollowsCell"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"FollowsTableViewCell" bundle:nil] forCellReuseIdentifier:@"FollowsCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"FollowsCell"];
    }
    
   Follower * follow = self.followers[indexPath.row];
    InstagramUser *user = follow[@"originUser"];
    
    cell.uiTextLabel.text = user.name;
    
    return cell;
}
@end
