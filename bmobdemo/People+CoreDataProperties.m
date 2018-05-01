//
//  People+CoreDataProperties.m
//  bmobdemo
//
//  Created by OurEDA on 2018/4/25.
//  Copyright © 2018年 zyy. All rights reserved.
//
//

#import "People+CoreDataProperties.h"

@implementation People (CoreDataProperties)

+ (NSFetchRequest<People *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"People"];
}

@dynamic address;
@dynamic email;
@dynamic name;
@dynamic phonenumber;

@end
