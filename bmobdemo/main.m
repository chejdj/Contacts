//
//  main.m
//  bmobdemo
//
//  Created by OurEDA on 2018/4/11.
//  Copyright © 2018年 zyy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <BmobSDK/Bmob.h>
int main(int argc, char * argv[]) {
    @autoreleasepool {
        NSString *appKey=@"371703b45a8a6023b5ee8cb78527dd8b";
        [Bmob registerWithAppKey:appKey];
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
