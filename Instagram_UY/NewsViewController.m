#import "NewsViewController.h"
#import "InstagramUser.h"
#import "News.h"
#import "NewsTableViewCell.h"

@interface NewsViewController () <UITableViewDelegate, UITableViewDataSource>
@property NSArray *news;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadNews];
}


-(void) loadNews
{
    PFQuery *queryNews = [News query];
    [queryNews whereKey:@"owner" equalTo:self.user];
    [queryNews findObjectsInBackgroundWithBlock:^(NSArray *parseNews, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
        }else
        {
            self.news = parseNews;
            [self.myTableView reloadData];
        }
    }];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.news.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsCell"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"NewsTableViewCell" bundle:nil] forCellReuseIdentifier:@"NewsCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"NewsCell"];
    }
    if (self.news.count > 0) {
        News *newLoaded = [self.news objectAtIndex:indexPath.row];
        cell.textLabel.text = newLoaded.newsText;
    }
    return cell;
}

@end
