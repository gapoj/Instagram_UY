
#import "PhotoViewController.h"
#import "PhotoTableViewCell.h"
#import "InstagramPhoto.h"
#import "Hashtags.h"
@interface PhotoViewController ()
@property (strong, nonatomic) IBOutlet UIButton *buttonSave;
- (IBAction)onSaveTapped:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIButton *buttonAddTag;
- (IBAction)onAddTagTapped:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UITextField *titleTexfield;
@property (strong, nonatomic) IBOutlet UILabel *tagsLabel;

@property NSMutableArray * tags;
@end

@implementation PhotoViewController

- (void)resetView {
    self.buttonSave.hidden= YES;
    self.titleLabel.text = @" ";
    self.tagsLabel.text = @"No hashtags";
    self.titleLabel.hidden = YES;
    self.titleTexfield.hidden = YES;
    self.tagsLabel.hidden = YES;
    self.buttonAddTag.hidden = YES;
    self.tags = [NSMutableArray array];
    self.myPhoto.image = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self resetView];
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
        
    }
}

- (IBAction)onCameraRollPressed:(UIButton *)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)onTakePhotoPressed:(UIButton *)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}
- (void)showAll {
    self.buttonSave.hidden= NO;
    self.titleLabel.hidden = NO;
    self.titleTexfield.hidden = NO;
    self.tagsLabel.hidden = NO;
    self.buttonAddTag.hidden = NO;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.myPhoto.image = chosenImage;
     self.myPhoto.contentMode = UIViewContentModeScaleAspectFit;
    [self showAll];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
- (IBAction)onSaveTapped:(UIButton *)sender {
    [self addPhotosToParse:self.titleLabel.text user:self.user];
    
}
- (IBAction)onAddTagTapped:(UIButton *)sender {
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"New Tag", @"new_tag_dialog")
                                                          message:@"add new tag" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];

    myAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [myAlertView show];
  

}



-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        [self.tags addObject:[NSString stringWithFormat:@"#%@", [alertView textFieldAtIndex:0].text]];
       self.tagsLabel.text = [self.tags  componentsJoinedByString:@" "];
            }
   
}
- (void)addPhotosToParse: (NSString*)name user: (InstagramUser*) owner
{
    InstagramPhoto *instagramPhoto = [InstagramPhoto object];
    instagramPhoto.owner = owner;
    NSData* data = UIImageJPEGRepresentation(self.myPhoto.image, 0.5f);
    PFFile *imageFile = [PFFile fileWithData:data];
    instagramPhoto.parsePhoto = imageFile;
    instagramPhoto.title = name;
    instagramPhoto.publishedDate = [NSDate date];
    [instagramPhoto saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(error){
            NSLog(@"%@",error);
        }else{
            [self addHashtags:instagramPhoto];
            [self resetView];
            UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Succes"
                                                                  message:@"The photo was saved"
                                                                 delegate:nil
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles: nil];
            
            [myAlertView show];
            [self.tabBarController setSelectedIndex:0];
            
        }
    }];
    
}
- (void)addHashtags:(InstagramPhoto*)photo
{
    for (NSString *tag in self.tags) {
        Hashtags *hashtag= [Hashtags object];
        
        hashtag.photo = photo;
        hashtag.hashtagText = tag;
        [hashtag saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if(error){
                NSLog(@"%@",error);
            }
        }];
        
    }

}
@end
