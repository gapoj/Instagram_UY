
#import "AppDelegate.h"
#import "SearchViewController.h"
#import "PhotoViewController.h"
#import "ProfileViewController.h"
#import "HomeViewController.h"
#import "NewsViewController.h"
#import "LogInViewController.h"
#import <Parse/Parse.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [Parse setApplicationId:@"fakbQcgLjgKh6CttLfheBKDXXFrdRgHUdv6qgCuo" clientKey:@"UqbOynwOp9f6bWawfukAHAGyIpvFt8862tU3HISU"];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    LogInViewController *login =[[LogInViewController alloc]init];
    
    
    self.window.rootViewController = login;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

@end
