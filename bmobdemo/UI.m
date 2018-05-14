//
//  ViewController.m
//  bmobdemo
//
//  Created by OurEDA on 2018/4/11.
//  Copyright © 2018年 zyy. All rights reserved.
//
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    float width =[[UIScreen mainScreen]bounds].size.width;
    float height=[[UIScreen mainScreen]bounds].size.height;
    addbtn =[[UIButton alloc]initWithFrame:CGRectMake(width-60, 35, 40, 40)];
    [addbtn setTitle:@"+" forState:UIControlStateNormal];
    [addbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [addbtn addTarget:self action:@selector(addInformation:) forControlEvents:UIControlEventTouchUpInside];
    addbtn.titleLabel.font=[UIFont systemFontOfSize: 30.0f];
    [self.view addSubview:addbtn];
    
    
    searhbar=[[UISearchBar alloc]initWithFrame:CGRectMake(10, 85, width-20,40)];
    searhbar.barTintColor = [UIColor whiteColor];
    searhbar.layer.borderWidth = 0.5;
    searhbar.layer.borderColor=[UIColor grayColor].CGColor;
    searhbar.placeholder=@"搜索";
    searhbar.delegate=self;
    [self.view addSubview:searhbar];
    arraydata=[[NSMutableArray alloc]init];
    mytableview =[[UITableView alloc]initWithFrame:CGRectMake(0, 140, width, height-60)];
    [mytableview setDelegate:self];
    [mytableview setDataSource:self];
    mytableview.contentInset = UIEdgeInsetsMake(0, 0,100, 0);
    [self.view addSubview:mytableview];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar;{
    NSString *name=searchBar.text;
    NSInteger count=0;
    for(int i=0;i<arraydata.count;i++){
        NSManagedObject *s1=arraydata[i];
        if([s1 valueForKey:@"name"]==name){
            count=i;
            break;
        }
    }
    if(count+2<arraydata.count)
        count=count+2;
    [mytableview reloadData];
    NSIndexPath *index=[NSIndexPath indexPathForRow:count inSection:0];
    [mytableview scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}
- (void) viewWillAppear:(BOOL)animated{
    [self initdata];
    [arraydata removeAllObjects];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"People" inManagedObjectContext:context];
    [request setEntity:entity];
    NSError *error = nil;
    NSArray *objs = [context executeFetchRequest:request error:&error];
    if (error) {
        [NSException raise:@"查询错误" format:@"%@", [error localizedDescription]];
    }
    for (NSManagedObject *obj in objs) {
        NSLog(@"name = %@, phonenumber = %@, address = %@", [obj valueForKey:@"name"], [obj valueForKey:@"phonenumber"], [obj valueForKey:@"address"]);
        NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
        [dict setObject:[obj valueForKey:@"name"] forKey:@"name"];
        [dict setObject:[obj valueForKey:@"phonenumber"] forKey:@"phonenumber"];
        [dict setObject:[obj valueForKey:@"email"] forKey:@"email"];
        [dict setObject:[obj valueForKey:@"address"] forKey:@"address"];
        [arraydata addObject:dict];
    }
    if([arraydata count]<=0){
        [self initNetWork];
    }else{
    [mytableview reloadData];
    }
}//优先从本地获取，如果没有才从网络获取
-(void)initdata{
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
    NSLog(@"打开数据库成功");
}
-(void) initNetWork{
    NSLog(@"从网络获取。。。");
    //处理本地的数据比网上多，网上的数据比本地多？
    BmobQuery *bquery=[BmobQuery queryWithClassName:@"People"];
    NSManagedObject *s1 = [NSEntityDescription insertNewObjectForEntityForName:@"People" inManagedObjectContext:context];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        for (BmobObject *obj in array) {
            NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
            [dict setObject:[obj objectForKey:@"name"] forKey:@"name"];
            [dict setObject:[obj objectForKey:@"phonenumber"] forKey:@"phonenumber"];
            [dict setObject:[obj objectForKey:@"email"] forKey:@"email"];
            [dict setObject:[obj objectForKey:@"address"] forKey:@"address"];
            [arraydata addObject:dict];
            [s1 setValue:[obj objectForKey:@"name"] forKey:@"name"];
            [s1 setValue:[obj objectForKey:@"phonenumber"] forKey:@"phonenumber"];
            [s1 setValue:[obj objectForKey:@"address"] forKey:@"address"];
            [s1 setValue:[obj objectForKey:@"email"] forKey:@"email"];
            [context save:nil];
        }
        [mytableview reloadData];
    }];
}
-(void)addInformation:(UIButton *)btn{
    NSLog(@"执行添加命令");
    new_peopleViewController *myNew=[[new_peopleViewController alloc]init];
    myNew.context=context;
    [self.navigationController pushViewController:myNew animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return [arraydata count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier=@"NameIdentifier";    UITableViewCell *cell= [mytableview dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil){
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    NSString *name = [@"" stringByAppendingFormat:@"%@",[arraydata[[indexPath row]] valueForKey:@"name"]];
    cell.textLabel.text = name;
    cell.imageView.image = [UIImage imageNamed:@"Contacts"];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailViewController *detail=[[DetailViewController alloc] init];
    detail.name=[NSString stringWithFormat:@"%@",[arraydata[[indexPath row]] valueForKey:@"name"]];
    detail.phone=[NSString stringWithFormat:@"%@",[arraydata[[indexPath row]] valueForKey:@"phonenumber"]];
    detail.email=[NSString stringWithFormat:@"%@",[arraydata[[indexPath row]] valueForKey:@"email"]];
    detail.local=[NSString stringWithFormat:@"%@",[arraydata[[indexPath row]] valueForKey:@"address"]];
    [self.navigationController pushViewController:detail animated:YES];
}
@end
