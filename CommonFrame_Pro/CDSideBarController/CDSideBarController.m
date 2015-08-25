//
//  ICSideMenuController.m
//  CDSideBar
//
//  Created by ionitech on 15/6/4.
//  Copyright (c) 2015年 Christophe Dellac. All rights reserved.
//

#import "CDSideBarController.h"

@interface CDSideBarController()
{
    NSIndexPath*    _indexTime;
    NSIndexPath*    _indexType;
}


@end

@implementation CDSideBarController


@synthesize menuColor = _menuColor;
@synthesize isOpen = _isOpen;


#pragma mark -
#pragma mark TableViewDelaget

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SliderTypeCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    for(UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    NSInteger index = indexPath.row;
    
    Mark* m = [_nameList objectAtIndex:index];
    
    UIImageView* img = [[UIImageView alloc] initWithFrame:CGRectMake(14, 13, 15, 15)];
    [img setBackgroundColor:[UIColor clearColor]];
    [img setImage:[UIImage imageNamed:m.labelImage]];
    
    [cell.contentView addSubview:img];
    
    UILabel* name = [[UILabel alloc] initWithFrame:CGRectMake(37, 13, 200, 13)];
    [name setBackgroundColor:[UIColor clearColor]];
    [name setText:m.labelName];
    [name setTextColor:[UIColor grayColor]];
    [name setFont:[UIFont systemFontOfSize:13]];
    name.tag = 1020;
    [cell.contentView addSubview:name];
    
    cell.contentView.backgroundColor = [UIColor blackColor];
    
    UILabel* bottomLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 40.5, tableView.frame.size.width, 0.5)];
    [bottomLine setBackgroundColor:[UIColor grayColor]];
    [cell.contentView addSubview:bottomLine];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 41;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count  = _nameList.count;
    return count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = indexPath.row;
    if (index != 0 && index != 6) {
        UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        
        for (UIControl* control in cell.contentView.subviews) {
            if (control.tag == 1020) {
                ((UILabel*)control).textColor = [UIColor whiteColor];
                break;
            }
        }
        
        if (index > 0 && index < 6) {
            
            if (_indexTime != nil) {
                cell = [tableView cellForRowAtIndexPath:_indexTime];
                
                for (UIControl* control in cell.contentView.subviews) {
                    if (control.tag == 1020) {
                        ((UILabel*)control).textColor = [UIColor grayColor];
                        break;
                    }
                }
            }
            
            
            _indexTime = indexPath;
        }
        if (index > 6) {
            
            if (_indexType != nil) {
                cell = [tableView cellForRowAtIndexPath:_indexType];
                
                for (UIControl* control in cell.contentView.subviews) {
                    if (control.tag == 1020) {
                        ((UILabel*)control).textColor = [UIColor grayColor];
                        break;
                    }
                }
            }
            
            _indexType = indexPath;
        }
        
    }
   
    
    
    if ([self.delegate respondsToSelector:@selector(cdSliderCellClicked:)])
        [self.delegate cdSliderCellClicked:indexPath.row];
    //[self dismissMenu];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 
#pragma mark Init

- (CDSideBarController*)initWithImages:(NSArray*)images  names:(NSArray*)nameList  menuButton:(UIButton*)button
{
    //UIButton *button  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    
    [button setImage:[UIImage imageNamed:@"btn_gengduo"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    
    //barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    //[barButton setAction:@selector(showMenu)];
    
    _menuButton = button;
    
    _backgroundMenuView = [[UIView alloc] init];
    _menuColor = [UIColor whiteColor];
    _buttonList = [[NSMutableArray alloc] initWithArray:images];
    _nameList = [[NSMutableArray alloc] initWithArray:nameList];


    return self;
}

- (void)insertMenuButtonOnView:(UIView*)view atPosition:(CGPoint)position
{
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissMenu)];
    [view addGestureRecognizer:singleTap];
    
    singleTap.delegate = self;
    
    _viewWidth = view.frame.size.width;
    
    CGRect tableFrame = CGRectMake(_viewWidth - 106, 0 , 106, [UIApplication sharedApplication].delegate.window.bounds.size.height - 60 - 120);
    
    _mainTableView = [[UITableView alloc]  initWithFrame:tableFrame];
    [_mainTableView setSeparatorColor:[UIColor colorWithRed:150/255.0f green:161/255.0f blue:177/255.0f alpha:1.0f]];
    [_mainTableView setBackgroundColor:[UIColor blackColor]];
    [_mainTableView setDataSource:self];
    [_mainTableView setDelegate: self];
    [_mainTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

    [_backgroundMenuView addSubview:_mainTableView];
    
    _backgroundMenuView.frame = CGRectMake(_viewWidth, 64, _viewWidth, view.frame.size.height);
    _backgroundMenuView.backgroundColor = [UIColor clearColor];
    [view addSubview:_backgroundMenuView];
    
}

- (void)bgTap
{
    [self dismissMenu];
    
}

#pragma mark -
#pragma mark Gesture recognizer action

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    NSLog(@"%@", NSStringFromClass([touch.view class]));
    
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    else if ([NSStringFromClass([touch.view class]) isEqualToString:@"PPDragDropBadgeView"]) {
        //UIView* cView = touch.view;
        UIView* pView = touch.view.superview;
        for (UIControl* control in pView.subviews) {
            if ([control isKindOfClass:[UIButton class]]) {
                UIButton* btn = (UIButton*)control;
                [btn sendActionsForControlEvents:UIControlEventTouchUpInside];

                break;
            }
        }
        return NO;
    }
    else if ([NSStringFromClass([touch.view class]) isEqualToString:@"ZYQTapAssetView"]) {
        return NO;
    }

    return YES;
}

#pragma mark -
#pragma mark Menu button action

- (void)dismissMenuWithSelection:(UIButton*)button
{
    [UIView animateWithDuration:0.3f
                          delay:0.0f
         usingSpringWithDamping:.2f
          initialSpringVelocity:10.f
                        options:0 animations:^{
                            button.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
                        }
                     completion:^(BOOL finished) {
                         [self dismissMenu];
                     }];
}

- (void)dismissMenu
{
    //[_bgView setHidden:YES];
    if (_isOpen)
    {
        _isOpen = !_isOpen;
       [self performDismissAnimation];
    }
}

- (void)showMenu
{
    if (!_isOpen)
    {
        //[_bgView setHidden:NO];
        _isOpen = YES;
        [self performSelectorInBackground:@selector(performOpenAnimation) withObject:nil];
    }
    else
    {
        [self dismissMenu];
    }
    
    if ([self.delegate respondsToSelector:@selector(partfarmButtonClicked:)]) {
        [self.delegate partfarmButtonClicked:@"2"];
    }
}

- (void)onMenuButtonClick:(UIButton*)button
{
    if ([self.delegate respondsToSelector:@selector(cdSliderCellClicked:)])
        [self.delegate cdSliderCellClicked:button.tag];
    [self dismissMenuWithSelection:button];
}

#pragma mark -
#pragma mark - Animations

- (void)performDismissAnimation
{
    [UIView animateWithDuration:0.4 animations:^{
        _menuButton.alpha = 1.0f;
        _menuButton.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0);
        _backgroundMenuView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0);
    }];
}

- (void)performOpenAnimation
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.4 animations:^{
            _backgroundMenuView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, -_viewWidth, 0);
        }];
    });
}

@end

