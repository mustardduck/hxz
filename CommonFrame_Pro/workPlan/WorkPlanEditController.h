//
//  WorkPlanEditController.h
//  CommonFrame_Pro
//
//  Created by 倩 莫 on 15/12/29.
//  Copyright © 2015年 ionitech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WorkPlanEditController : UIViewController

@property (nonatomic, strong) NSString * workGroupId;
@property (nonatomic, strong) NSString * workGroupName;
@property (nonatomic, strong) NSMutableArray * rows;

@end