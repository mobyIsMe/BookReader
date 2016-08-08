//
//  AppDelegate.m
//  LSYReader
//
//  Created by Labanotation on 16/5/30.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import "AppDelegate.h"
//#import "Demo1ViewController.h"
#import "BookStoreTabBar.h"
#import "AboutTabBar.h"
#import "MainViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UITabBarController* tabBarControllers = [[UITabBarController alloc]init];
    MainViewController* bookShelf = [[MainViewController alloc] init];
    BookStoreTabBar* bookStore = [[BookStoreTabBar alloc] init];
    AboutTabBar* about= [[AboutTabBar alloc] init];
    _navigationControllerBookShelf = [[UINavigationController alloc]initWithRootViewController:bookShelf];
    _navigationControllerBookStore = [[UINavigationController alloc]initWithRootViewController:bookStore];
    _navigationControllerAbout= [[UINavigationController alloc]initWithRootViewController:about];
    bookShelf.title = @"书架";
    bookStore.title = @"书城";
    //bookShelf.tabBarController.navigationController.navigationItem.title = @"书架";
     about.title = @"关于";
    UIColor* blueColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:blueColor forKey:UITextAttributeTextColor];
//    bookShelf.tabBarController.navigationController.navigationBar.titleTextAttributes = dict;
//     bookShelf.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemBookmarks tag:1];
    //bookShelf.tabBarItem.title=@"shujia";
   
    bookShelf.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"书架" image:nil tag:1];
    
    bookShelf.tabBarItem.image = [UIImage imageNamed:@"Documents"];
    //设置选中图片
   // bookShelf.tabBarItem.selectedImage = [UIImage imageNamed:@"tabbar_mainframeHL"];
    
    bookStore.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"书城" image:nil tag:2];
    about.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"关于" image:nil tag:3];


tabBarControllers.viewControllers = @[_navigationControllerBookShelf,_navigationControllerBookStore,_navigationControllerAbout];
    self.window.rootViewController = tabBarControllers;

    for(UIViewController* viewControllerItem in  tabBarControllers.viewControllers)
        
    {
        [viewControllerItem.tabBarController.navigationController.navigationBar setTitleTextAttributes: dict];//顶部title的颜色无效
        [viewControllerItem.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Helvetica" size:15.0], NSFontAttributeName, nil]forState:UIControlStateNormal];
    }
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
