//
//  ICGroupListViewController.h
//  CommonFrame_Pro
//
//  Created by ionitech on 15/6/24.
//  Copyright (c) 2015年 ionitech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICGroupDetailViewController.h"
#import "ICMemberTableViewController.h"
#import "ICPublishMissionViewController.h"
#import "ICPublishSharedAndNotifyViewController.h"

typedef enum{
    GroupTypeDepartment     = 0,    //部门列表
    GroupTypeProject        = 1,    //项目列表
    GroupTypeMission        = 2,     //责任人
    GroupTypeSharedAndNotify        = 4     //分享与通知
}GroupType;

@interface ICGroupListViewController : UITableViewController

@property (nonatomic,assign) GroupType currentViewGroupType;
@property (nonatomic,strong) id icPublishMissionResponsibleController;
@property (nonatomic,strong) NSArray* responsibleDictionaryToPublish;
@property (nonatomic,assign) NSString* hasValue;
@property (nonatomic,assign) BOOL isShared; //1: NO; 0: YES
@property(nonatomic,strong) NSString* loginUserID;
@property(nonatomic,strong) NSString* groupId;

@property (nonatomic,strong) id icMainViewController;

@end
