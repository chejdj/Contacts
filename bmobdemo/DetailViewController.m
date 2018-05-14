//
//  DetailViewController.m
//  second01
//
//  Created by OurEDA on 2018/3/18.
//  Copyright © 2018年 zyy. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    float width = self.view.bounds.size.width;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    back=[[UIButton alloc]initWithFrame:CGRectMake(25, 35, width-50, 60)];
    [back setTitle:@"< 通讯录" forState:UIControlStateNormal];
    back.font=[UIFont boldSystemFontOfSize:18.0f];
    [back addTarget:self action:@selector(back_ground:) forControlEvents:UIControlEventTouchUpInside];
 back.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    [back setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:back];
    
    
    username_l=[[UILabel alloc] initWithFrame:CGRectMake(25, 100, width-50, 40)];
   // [username_l setBackgroundColor:[UIColor grayColor]];
    
    username_l.text=@"姓名";
    username_l.backgroundColor=[UIColor whiteColor];
    username_l.font=[UIFont boldSystemFontOfSize:16.0];
    username_l.textColor=[UIColor blackColor];
    [self.view addSubview:username_l];
    
    
    username=[[UIButton alloc]initWithFrame:CGRectMake(25, 145, width-50, 40)];
    [username setBackgroundColor:[UIColor grayColor]];
    [username setTitle:self.name forState:UIControlStateNormal];
    NSLog(@"name is%@",self.name); username.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    [username addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:username];
    
    
    phone_l=[[UILabel alloc] initWithFrame:CGRectMake(25, 190, width-50, 40)];
    
    phone_l.text=@"手机";
    phone_l.font=[UIFont boldSystemFontOfSize:16.0];
    phone_l.textColor=[UIColor blackColor];
    [self.view addSubview:phone_l];
    
    phone=[[UIButton alloc]initWithFrame:CGRectMake(25, 235, width-50, 40)];
    [phone setBackgroundColor:[UIColor grayColor]];
   // [phone.layer setBorderColor:color];
    [phone setTitle:self.phone forState:UIControlStateNormal];
    phone.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    [phone addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:phone];
    
    email_l=[[UILabel alloc] initWithFrame:CGRectMake(25, 280, width-50, 40)];
    
    email_l.text=@"Email";
    email_l.font=[UIFont boldSystemFontOfSize:16.0];
    email_l.textColor=[UIColor blackColor];
    [self.view addSubview:email_l];
    
    
    email=[[UIButton alloc]initWithFrame:CGRectMake(25, 335, width-50, 40)];
    [email setBackgroundColor:[UIColor grayColor]];
    [email setTitle:self.email forState:UIControlStateNormal];
   NSLog(@"email is %@ ",self.email); email.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    [email addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:email];
    
    
    address_l=[[UILabel alloc] initWithFrame:CGRectMake(25, 370, width-50, 40)];
    address_l.text=@"地址";
    address_l.font=[UIFont boldSystemFontOfSize:16.0];
    address_l.textColor=[UIColor blackColor];
    [self.view addSubview:address_l];
    
    address=[[UIButton alloc]initWithFrame:CGRectMake(25, 415, width-50, 40)];
    [address setBackgroundColor:[UIColor grayColor]];
    [address setTitle:self.local forState:UIControlStateNormal];
 address.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    [address addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:address];
    [self initDatabase];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
}
-(void)back_ground:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:true];
}
-(IBAction)buttonPressed:(id)sender{
    UIActionSheet *action=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"编辑",@"删除", nil];
    action.actionSheetStyle=UIActionSheetStyleAutomatic;
    [action showInView:self.view];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
  new_peopleViewController  *edit=[[new_peopleViewController alloc] init];
    if(buttonIndex!=2){
        switch (buttonIndex) {
            case 0: //编辑
                edit.name_l=username.currentTitle;
                edit.phone_l=phone.currentTitle;
                edit.email_l=email.currentTitle;
                edit.local_l=address.currentTitle;
                edit.context=context;
                [self.navigationController pushViewController:edit animated:YES];
                break;
            case 1: //删除
                [self delete];
            break;
            default:
                break;
        }
    }
}
-(void)delete{
    NSLog(@"执行删除数据");
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"People" inManagedObjectContext:context];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@",_name];
    request.predicate = predicate;
    NSError *error = nil;
    NSArray *objs = [context executeFetchRequest:request error:&error];
    for(NSManagedObject *obj in objs) {
        NSLog(@"delete  name = %@  address= %@ ", [obj valueForKey:@"name"],[obj valueForKey:@"address"]);
        [context deleteObject:obj];
    }
    if(error){
        NSLog(@"本地数据删除失败 %@",error);
    }
    [context save:nil];
    
    BmobQuery *bquery=[BmobQuery queryWithClassName:@"People"];
    [bquery whereKey:@"name" equalTo:_name];
    bquery.limit=1;
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        for (BmobObject *obj in array) {
            NSLog(@"云上删除数据%@",[obj objectForKey:@"name"]);
            [obj deleteInBackground];
        }
        if(error){
            NSLog(@"有错误%@",error);
        }
    }];
    [self.navigationController popViewControllerAnimated:true];
}
-(void) initDatabase{
    NSError *error = nil;
    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
    psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    NSString *docs = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSURL *url = [NSURL fileURLWithPath:[docs stringByAppendingString:@"People.sqlite"]];
    NSPersistentStore *store = [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error];
    if (store == nil) {
        [NSException raise:@"DB Error" format:@"%@", [error localizedDescription]];
    }
    context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    context.persistentStoreCoordinator = psc;
}
@end
