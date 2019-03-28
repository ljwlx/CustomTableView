//
//  JSTableView.h
//  CustomTable
//
//  Created by wei on 2019/3/25.
//  Copyright © 2019年 wei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSTableCell.h"
@class JSTableView;

@protocol JSTableViewDelegate<NSObject>
-(void)tableView:(JSTableView *)tableView didSelectRow:(NSInteger)row;
@end


@protocol JSTableViewDataSource<NSObject>
@required
- (NSInteger)cellNumbersWithTableView:(JSTableView*)tableView;
- (JSTableCell*)tableView:(JSTableView*)tableView cellForRow:(NSInteger)row;
- (CGFloat)tableView:(JSTableView*)tableView cellHightForRow:(NSInteger)row;
@end



@interface JSTableView : UIScrollView
@property (nonatomic,weak)id<JSTableViewDelegate>jsDelegate;
@property (nonatomic,weak)id<JSTableViewDataSource>jsDataSource;

- (JSTableCell*)dequeueReusableCell;
- (void)reloadData;

@end
