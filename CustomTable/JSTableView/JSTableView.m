//
//  JSTableView.m
//  CustomTable
//
//  Created by wei on 2019/3/25.
//  Copyright © 2019年 wei. All rights reserved.
//

#import "JSTableView.h"

@interface JSTableView ()<UIScrollViewDelegate>
//展示中的cell
@property (nonatomic,strong)NSMutableArray*visibleCells;
//未展示的cell
@property (nonatomic,strong)NSMutableArray*invalidCells;
//scrollView-旧的偏移值y
@property (nonatomic,assign)CGFloat original_y;
//数据总数
@property (nonatomic,assign)NSInteger totalCounts;
//记录最小的cell的高度
@property (nonatomic,assign)CGFloat minimumCellHight;
@end

@implementation JSTableView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.showsVerticalScrollIndicator = NO;
        self.delegate = self;
        self.scrollEnabled = YES;
        self.userInteractionEnabled = YES;
        self.original_y = 0.f;
        //初始设置为一个比较大的值
        self.minimumCellHight = self.frame.size.height;
    }
    return self;
}

- (void)reloadData{
    //布局基本数据
    self.totalCounts = [self.jsDataSource cellNumbersWithTableView:self];
    CGFloat start_y = 0.f;
    NSInteger loadNumber = self.totalCounts;
    for(NSInteger i=0;i<self.totalCounts;i++){
        CGFloat cellHight = [self.jsDataSource tableView:self cellHightForRow:i];
        if(self.minimumCellHight>cellHight) self.minimumCellHight=cellHight;
        JSTableCell*cell = [self.jsDataSource tableView:self cellForRow:i];
        cell.row = i;
        cell.frame = CGRectMake(0, start_y, self.frame.size.width, cellHight);
        start_y = start_y + cellHight;
        [self addSubview:cell];
        //将cell加入已展示的数组中
        [self.visibleCells addObject:cell];
        loadNumber = i;
        if(start_y>self.frame.size.height) break;
    }
    [self resetContentSize];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    /*
     * 这里最初只是  [self refreshViewWithOffsety:scrollView.contentOffset.y];即可
     * 考虑到向上或向下快速拉一个很大的范围，会导致cell加载不出来。为了保证滑动中每一个cell都能够被加载，
     * 这里写了一个新旧位置中取点的循环，循环间隔是minimumCellHight（minimumCellHight是cell的最小高度）
     */
    
    CGFloat y = scrollView.contentOffset.y;
    if(y>self.original_y){
        for(CGFloat i = self.original_y+self.minimumCellHight; i<y;i = i + self.minimumCellHight){
            [self refreshViewWithOffsety:i];
        }
        [self refreshViewWithOffsety:y];
    }else{
        for(CGFloat i = self.original_y-self.minimumCellHight; i>y;i = i - self.minimumCellHight){
            [self refreshViewWithOffsety:i];
        }
        [self refreshViewWithOffsety:y];
    }
}
- (void)refreshViewWithOffsety:(CGFloat)contentOffsety{
    if(contentOffsety>self.original_y){
        //向上滑动
        self.original_y = contentOffsety;
        JSTableCell*firstCell = self.visibleCells.firstObject;
        JSTableCell*lastCell  = self.visibleCells.lastObject;
        if(lastCell.row>=self.totalCounts){
            return;
        }
        if(firstCell.frame.origin.y+firstCell.frame.size.height<contentOffsety){
            [self.invalidCells addObject:firstCell];//回收
            [self.visibleCells removeObject:firstCell];//从已展示中移除
        }
        if(lastCell.frame.size.height+lastCell.frame.origin.y>contentOffsety+self.frame.size.height){
            return;
        }else{
            //底部添加1个cell
            NSInteger newRow = lastCell.row + 1;
            if(newRow>self.totalCounts-1){
                [self resetContentSize];
                return;
            }
            CGFloat cellHight = [self.jsDataSource tableView:self cellHightForRow:newRow];
            if(self.minimumCellHight>cellHight) self.minimumCellHight=cellHight;
            JSTableCell*cell = [self.jsDataSource tableView:self cellForRow:newRow];
            cell.row = newRow;
            cell.frame = CGRectMake(0, lastCell.frame.origin.y+lastCell.frame.size.height, self.frame.size.width, cellHight);
            if(cell.superview){ //有父视图说明不是新建的
                [self.invalidCells removeObject:cell];
            }else{
                [self addSubview:cell];
            }
            [self.visibleCells addObject:cell];
            [self resetContentSize];
        }
    }else{
        //向下滑动
        self.original_y = contentOffsety;
        if(contentOffsety<0){
            return;
        }
        JSTableCell*firstCell = self.visibleCells.firstObject;
        JSTableCell*lastCell  = self.visibleCells.lastObject;
        if(lastCell.frame.origin.y>contentOffsety+self.frame.size.height){
            [self.invalidCells addObject:lastCell];
            [self.visibleCells removeObject:lastCell];
        }
        if(firstCell.frame.origin.y+firstCell.frame.size.height<contentOffsety){
            return;
        }else{
            //顶部添加1个cell
            NSInteger newRow = firstCell.row - 1;
            if(newRow<0){
                [self resetContentSize];
                return;
            }
            CGFloat cellHight = [self.jsDataSource tableView:self cellHightForRow:newRow];
            if(self.minimumCellHight>cellHight) self.minimumCellHight=cellHight;
            JSTableCell*cell = [self.jsDataSource tableView:self cellForRow:newRow];
            cell.row = newRow;
            cell.frame = CGRectMake(0, firstCell.frame.origin.y-cellHight, self.frame.size.width, cellHight);
            if(cell.superview){
                [self.invalidCells removeObject:cell];
            }else{
                [self addSubview:cell];
            }
            [self.visibleCells insertObject:cell atIndex:0];
            [self resetContentSize];
        }
    }
    self.original_y = contentOffsety;
}



- (void)resetContentSize{
    JSTableCell*cell = self.visibleCells.lastObject;
    CGFloat needHight = cell.frame.origin.y+cell.frame.size.height;
    if(needHight<self.frame.size.height) needHight=self.frame.size.height + 1;
    self.contentSize = CGSizeMake(self.frame.size.width,needHight);
}

- (NSMutableArray*)visibleCells{
    if(!_visibleCells){
        _visibleCells = [[NSMutableArray alloc] init];
    }
    return _visibleCells;
}
- (NSMutableArray*)invalidCells{
    if(!_invalidCells){
        _invalidCells = [[NSMutableArray alloc] init];
    }
    return _invalidCells;
}

- (JSTableCell*)dequeueReusableCell{
    //如果未展示的数组中有数据，则返回一条重用
    if(self.invalidCells.count>0) return self.invalidCells.firstObject;
    return nil;
}

@end
