//
//  JSTableCell.m
//  CustomTable
//
//  Created by wei on 2019/3/25.
//  Copyright © 2019年 wei. All rights reserved.
//

#import "JSTableCell.h" 
@interface JSTableCell (){
    UIView*line;
}
@end

@implementation JSTableCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)init{
    self = [super init];
    if(self){
        self.userInteractionEnabled = YES;
        line = [[UIView alloc] init];
        line.backgroundColor = [UIColor darkGrayColor];
        line.hidden = NO;
        [self addSubview:line];
        
        _lb = [[UILabel alloc] init];
        _lb.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_lb];
    }
    return self;
}

- (void)layoutSubviews{
    line.frame = CGRectMake(20, self.frame.size.height-0.5, self.frame.size.width-30, 0.5);
    _lb.frame =  self.bounds;
}

@end
