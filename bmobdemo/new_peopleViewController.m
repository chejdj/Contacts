//
//  new_peopleViewController.m
//  second01
//
//  Created by OurEDA on 2018/3/18.
//  Copyright © 2018年 zyy. All rights reserved.
//

#import "new_peopleViewController.h"

@interface new_peopleViewController ()

@end

@implementation new_peopleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    float width =[[UIScreen mainScreen]bounds].size.width;
   // float  height=[[UIScreen mainScreen]bounds].size.height;
    cancel=[[UIButton alloc]initWithFrame:CGRectMake(20, 40, 60, 40)];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    cancel.titleLabel.font=[UIFont systemFontOfSize: 16.0f];
    [cancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancel];
    
    
    
    save=[[UIButton alloc]initWithFrame:CGRectMake(width-80, 40, 60, 40)];
    [save setTitle:@"保存" forState:UIControlStateNormal];
    [save setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
     save.titleLabel.font=[UIFont systemFontOfSize: 16.0f];
    [save addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:save];
    
    name=[[UILabel alloc]initWithFrame:CGRectMake(25, 100, width-50, 40)];
    [name setText:@"姓名"];
    name.font=[UIFont boldSystemFontOfSize:16.0f];
    [name setTextColor:[UIColor blackColor]];
    [self.view addSubview: name];
    username_in =[[UITextField alloc]initWithFrame:CGRectMake(25, 145, width-50, 40)];
    username_in.borderStyle = UITextBorderStyleRoundedRect;
    [username_in setText:_name_l];
    [username_in setClearButtonMode:UITextFieldViewModeWhileEditing];
    [self.view addSubview:username_in];
    
    phone=[[UILabel alloc]initWithFrame:CGRectMake(25, 190, width-50, 40)];
    [phone setText:@"手机号"];
    phone.font=[UIFont boldSystemFontOfSize:16.0f];
    [phone setTextColor:[UIColor blackColor]];
    [self.view addSubview: phone];
    phone_in =[[UITextField alloc]initWithFrame:CGRectMake(25, 235, width-50, 40)];
    phone_in.borderStyle = UITextBorderStyleRoundedRect;
    [phone_in setClearButtonMode:UITextFieldViewModeWhileEditing];
    [phone_in setText: _phone_l];
    [self.view addSubview:phone_in];
    
    mail=[[UILabel alloc]initWithFrame:CGRectMake(25, 280, width-50, 40)];
    [mail setText:@"邮箱"];
    mail.font=[UIFont boldSystemFontOfSize:16.0f];
    [mail setTextColor:[UIColor blackColor]];
    [self.view addSubview: mail];
    mail_in =[[UITextField alloc]initWithFrame:CGRectMake(25, 325, width-50, 40)];
    mail_in.borderStyle = UITextBorderStyleRoundedRect;
    [mail_in setText:_email_l];
    [mail_in setClearButtonMode:UITextFieldViewModeWhileEditing];
    [self.view addSubview:mail_in];
   
    address=[[UILabel alloc]initWithFrame:CGRectMake(25, 370, width-50, 40)];
    [address setText:@"地址"];
    address.font=[UIFont boldSystemFontOfSize:16.0f];
    [address setTextColor:[UIColor blackColor]];
    [self.view addSubview: address];
    address_in =[[UITextField alloc]initWithFrame:CGRectMake(25, 415, width-50, 40)];
    [address_in setText:_local_l];
    address_in.borderStyle = UITextBorderStyleRoundedRect;
    [address_in setClearButtonMode:UITextFieldViewModeWhileEditing];
    [self.view addSubview:address_in];
    
    //NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  //  NSString *documentsPath = [path objectAtIndex:0];
   // plistpath = [documentsPath stringByAppendingPathComponent:@"contact.plist"];
   // NSLog(@"new people add     %@",plistpath);
   // plistpath =[[NSBundle mainBundle]pathForResource:@"provinces_cities" ofType:@"plist"];
    //dictionary =[[NSMutableDictionary alloc]initWithContentsOfFile:plistpath];
    
}
-(void)back:(UIButton *)btn{
    NSLog(@"添加用户取消！");
    [self.navigationController popViewControllerAnimated:true];
}
//coredata竟然不支持主键设置。。。
-(void)save:(UIButton *)btn{
    NSLog(@"添加用户");
    NSString * name = username_in.text;
    NSString * phone=phone_in.text;
    NSString * mail =mail_in.text;
    NSString * address=address_in.text;
    //NSArray * array =[[NSArray alloc]initWithObjects:phone,mail,address, nil];
    if(name.length==0 || phone.length==0){
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"填写错误" message:@"请填完信息" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
    else{
        if(_name_l==NULL){
            NSLog(@"执行增加程序");
        NSManagedObject *s1 = [NSEntityDescription insertNewObjectForEntityForName:@"People" inManagedObjectContext:_context];
        
        [s1 setValue:name forKey:@"name"];
        [s1 setValue:phone forKey:@"phonenumber"];
        [s1 setValue:address forKey:@"address"];
        [s1 setValue:mail forKey:@"email"];
        NSError *error = nil;
        if ([_context save:&error]) {
            NSLog(@"Succeed!");
            BmobObject *obj=[BmobObject objectWithClassName:@"People"];
            [obj setObject:[s1 valueForKey:@"name"] forKey:@"name"];
            [obj setObject:[s1 valueForKey:@"phonenumber"] forKey:@"phonenumber"];
            [obj setObject:[s1 valueForKey:@"address"] forKey:@"address"];
            [obj setObject:[s1 valueForKey:@"email"] forKey:@"email"];
            [obj saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if(isSuccessful){
                    NSLog(@"上传到网络成功！！");
                }
            }];
        }else {
            [NSException raise:@"插入错误" format:@"%@", [error localizedDescription]];
        }
        }else{
            NSLog(@"执行更新数据");
            NSFetchRequest *request = [[NSFetchRequest alloc] init];
            NSEntityDescription *entity=[NSEntityDescription entityForName:@"People" inManagedObjectContext:_context];
            [request setEntity:entity];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@",_name_l];
            request.predicate=predicate;
            
            //本地更新数据
            NSError *error = nil;
            NSArray *objs = [_context executeFetchRequest:request error:&error];
            if (error) {
                [NSException raise:@"查询错误" format:@"%@", [error localizedDescription]];
            }
            for (NSManagedObject *obj in objs) {
                [obj setValue:name forKey:@"name"];
                [obj setValue:phone forKey:@"phonenumber"];
                [obj setValue:address forKey:@"address"];
                [obj setValue:mail forKey:@"email"];
            }
            [_context save:&error];
            //网络更新数据
            BmobQuery *bquery=[BmobQuery queryWithClassName:@"People"];
            [bquery whereKey:@"name" equalTo:_name_l];
            NSLog(@"更新数据 %@",_name_l);
            [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                for (BmobObject *obj in array) {
                    NSLog(@"云上更新数据%@",[obj objectForKey:@"name"]);
                    [obj setObject:name forKey:@"name"];
                    [obj setObject:address forKey:@"address"];
                    [obj setObject:phone forKey:@"phonenumber"];
                    [obj setObject:mail forKey:@"email"];
                    [obj updateInBackground];
                }
            }];
        }
        ViewController *my=[[ViewController alloc]init];
        [self.navigationController pushViewController:my animated:false];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
