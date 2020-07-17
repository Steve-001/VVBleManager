//
//  AppDelegate.m
//  VVBleTestDemo
//
//  Created by zhx on 2020/7/7.
//  Copyright © 2020 inno. All rights reserved.
//

#import "AppDelegate.h"
#import "VVMyDeviceViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (UIWindow *)window{
    if (!_window) {
        _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _window.backgroundColor = [UIColor whiteColor];
        [_window makeKeyAndVisible];
    }
    return _window;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    VVMyDeviceViewController * myDeviceVC = [[VVMyDeviceViewController alloc] init];
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:myDeviceVC];
    self.window.rootViewController = nav;
    
    return YES;
}


@end
