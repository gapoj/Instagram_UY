//
//  NewUserViewController.m
//  Instagram_UY
//
//  Created by Guillermo Apoj on 10/31/14.
//  Copyright (c) 2014 Maximiliano Casal. All rights reserved.
//

#import "NewUserViewController.h"
#import "InstagramUser.h"

@interface NewUserViewController ()
@property (strong, nonatomic) IBOutlet UITextField *nameTexfield;
@property (strong, nonatomic) IBOutlet UITextField *emailTextfield;
@property (strong, nonatomic) IBOutlet UITextField *passwordTexfield;
- (IBAction)onCreate:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UILabel *errorLabel;

@end

@implementation NewUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.errorLabel.text = @" ";
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

- (IBAction)onCreate:(UIButton *)sender {
    if ([self.nameTexfield.text isEqualToString:@""] || [self.emailTextfield.text isEqualToString:@""]|| [self.passwordTexfield .text isEqualToString:@""] ) {
        self.errorLabel.text=@"YOU HAVE TO FILL ALL THE FIELDS";
    }else{
    
        self.errorLabel.text=@" ";
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"SUCCES"
                                                              message:@"You sign up succesfully"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        InstagramUser *user= [InstagramUser object];
        
        user.name =self.nameTexfield.text;
        user.email = self.emailTextfield.text;
        user.password = self.passwordTexfield.text;
        
        [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if(error){
                NSLog(@"%@",error);
                 self.errorLabel.text=@"Connection error, Try Again ";
            }else{
             [myAlertView show];
                [self dismissViewControllerAnimated:YES completion:^{
                    //
                }];
            }
        }];
       


    }
}

@end
