//
//  JSTableCell.h
//  CustomTable
//
//  Created by wei on 2019/3/25.
//  Copyright © 2019年 wei. All rights reserved.
//

#import <UIKit/UIKit.h>
 
@interface JSTableCell : UIView
//cell的row值
@property (nonatomic,assign)NSInteger row;

@property (nonatomic,strong)UILabel*lb;

@end
