//
//  People+CoreDataProperties.h
//  bmobdemo
//
//  Created by OurEDA on 2018/4/25.
//  Copyright © 2018年 zyy. All rights reserved.
//
//

#import "People+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface People (CoreDataProperties)

+ (NSFetchRequest<People *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *address;
@property (nullable, nonatomic, copy) NSString *email;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *phonenumber;

@end

NS_ASSUME_NONNULL_END
