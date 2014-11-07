
#import "CommentsViewController.h"
#import "Comment.h"
#import "CommentTableViewCell.h"

@interface CommentsViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *myPhoto;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UITextField *commentTextField;
@property NSArray *comments;
@end

@implementation CommentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadImage];
    [self loadComments];
}

-(void) loadComments
{
    PFQuery *queryComments = [Comment query];
    [queryComments whereKey:@"photo" equalTo:self.photo];
    [queryComments includeKey:@"owner"];
    [queryComments findObjectsInBackgroundWithBlock:^(NSArray *commentsLoaded, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
        }else
        {
            self.comments = commentsLoaded;
            [self.myTableView reloadData];
        }
    }];
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


- (IBAction)onAddCommentPressed:(id)sender {
    Comment *comment = [Comment object];
    comment.owner = self.user;
    comment.photo = self.photo;
    comment.publishedDate = [NSDate date];
    comment.title = self.commentTextField.text;
    
    [comment saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(error){
            NSLog(@"%@",error);
        }
    }];
}

- (IBAction)onBackButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.comments.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"CommentTableViewCell" bundle:nil] forCellReuseIdentifier:@"CommentCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
    }
    if (self.comments.count > 0) {
        Comment *comment = [self.comments objectAtIndex:indexPath.row];
        cell.textLabel.text = comment.title;
        InstagramUser *owner = comment[@"owner"];
        cell.userLabel.text = owner.name;
    }
    return cell;
}

@end
