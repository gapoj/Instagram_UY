//
//  LogInViewController.m
//  Instagram_UY
//
//  Created by Guillermo Apoj on 10/31/14.
//  Copyright (c) 2014 Maximiliano Casal. All rights reserved.
//
#import "SearchViewController.h"
#import "PhotoViewController.h"
#import "ProfileViewController.h"
#import "HomeViewController.h"
#import "NewsViewController.h"
#import <Parse/Parse.h>
#import "LogInViewController.h"
#import "NewUserViewController.h"

@interface LogInViewController ()
- (IBAction)prueba:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *userTexField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UILabel *errorLabel;
@property (strong, nonatomic) IBOutlet UIImageView *image;
- (IBAction)onSignInButtonTapped:(UIButton *)sender;


@end

@implementation LogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
      self.image.contentMode = UIViewContentModeScaleAspectFit;
    self.errorLabel.text =@" ";
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onSignInButtonTapped:(UIButton *)sender {
    if([self confirmUser]){
    [self openApp];
    }else{
     self.errorLabel.text =@"Error: wrong user or password";
    }
}
-(BOOL)confirmUser{
    PFQuery *personQuery = [PFQuery queryWithClassName:[InstagramUser parseClassName]];
    [personQuery whereKey:@"name" equalTo:self.userTexField.text];
    [personQuery whereKey:@"password" equalTo:self.passwordTextField.text];
    self.user = [personQuery findObjects].firstObject;
    if(self.user){
        return YES;
    }else{
        return NO;
    }

    
}
-(void) openApp{
    UITabBarController *tabBars = [[UITabBarController alloc] init];
    NSMutableArray *localViewControllersArray = [[NSMutableArray alloc] initWithCapacity:5];
    
    HomeViewController *homeViewController = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    homeViewController.tabBarItem.title=@"Home";
    homeViewController.user = self.user;
    [localViewControllersArray addObject:homeViewController];
    [homeViewController.tabBarItem setImage:[UIImage imageNamed:@"home"]];
    
    PhotoViewController *photoViewController = [[PhotoViewController alloc] initWithNibName:@"PhotoViewController" bundle:nil];
    photoViewController.user =self.user;
    photoViewController.tabBarItem.title=@"Photo";
    [localViewControllersArray addObject:photoViewController];
    [photoViewController.tabBarItem setImage:[UIImage imageNamed:@"camera"]];
    
    SearchViewController *searchViewController = [[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:nil];
    searchViewController.user = self.user;
    searchViewController.tabBarItem.title=@"Search";
    [localViewControllersArray addObject:searchViewController];
    [searchViewController.tabBarItem setImage:[UIImage imageNamed:@"search"]];
    
    NewsViewController *newsViewController = [[NewsViewController alloc] initWithNibName:@"NewsViewController" bundle:nil];
    newsViewController.user = self.user;
    newsViewController.tabBarItem.title=@"News";
    [localViewControllersArray addObject:newsViewController];
    newsViewController.tabBarItem.image = [UIImage imageNamed:@"news"];
    
    ProfileViewController *profileViewController = [[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil];
    profileViewController.user = self.user;
    profileViewController.tabBarItem.title=@"Profile";
    [profileViewController.tabBarItem setImage:[UIImage imageNamed:@"profile"]];
    [localViewControllersArray addObject:profileViewController];
    
    tabBars.viewControllers = localViewControllersArray;
    tabBars.view.autoresizingMask=(UIViewAutoresizingFlexibleHeight);
    [self showViewController:tabBars sender:self];

}
- (IBAction)test:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)prueba:(id)sender {
    NewUserViewController *vc =[[NewUserViewController alloc] initWithNibName:@"NewUserViewController" bundle:nil];
    [self showViewController:vc sender:self];
}
@end
