//
//  new_peopleViewController.h
//  second01
//
//  Created by OurEDA on 2018/3/18.
//  Copyright © 2018年 zyy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "People+CoreDataProperties.h"
#import "People+CoreDataClass.h"
#import "ViewController.h"
@interface new_peopleViewController : UIViewController{
    UIButton * save;
    UIButton * cancel;
    UILabel *name;
    UILabel *phone;
    UILabel *mail;
    UILabel *address;
    UITextField *username_in;
    UITextField *phone_in;
    UITextField *mail_in;
    UITextField *address_in;
    NSString * plistpath;
    
}
@property(weak,nonatomic) NSString *name_l;
@property(weak,nonatomic) NSString *email_l;
@property(weak,nonatomic) NSString *phone_l;
@property(weak,nonatomic) NSString *local_l;
@property(weak,nonatomic)NSManagedObjectContext *context;
@end
