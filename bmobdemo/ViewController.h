//
//  ViewController.h
//  bmobdemo
//
//  Created by OurEDA on 2018/4/11.
//  Copyright © 2018年 zyy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "People+CoreDataClass.h"
#import "People+CoreDataProperties.h"
#import "DetailViewController.h"
#import "new_peopleViewController.h"
#import <BmobSDK/Bmob.h>
@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    UIButton *addbtn;
    UITableView *mytableview;
    NSMutableArray *arraydata;
    NSPersistentStoreCoordinator *psc;
    NSManagedObjectContext *context;
    UISearchBar * searhbar;
}


@end

