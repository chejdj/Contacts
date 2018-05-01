//
//  DetailViewController.h
//  second01
//
//  Created by OurEDA on 2018/3/18.
//  Copyright © 2018年 zyy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "new_peopleViewController.h"
#import "People+CoreDataProperties.h"
#import "People+CoreDataClass.h"
@interface DetailViewController : UIViewController{
    UIButton *username;
    UIButton *phone;
    UIButton *email;
    UIButton *address;
    UIButton *back;
    UILabel *username_l;
    UILabel *phone_l;
    UILabel *email_l;
    UILabel *address_l;
    NSManagedObjectContext *context;
    NSPersistentStoreCoordinator *psc;
}//莲塘一中
@property(strong,nonatomic) NSString *name;
@property(strong,nonatomic) NSString *email;
@property(strong,nonatomic) NSString *phone;
@property(strong,nonatomic) NSString *local;
@end
