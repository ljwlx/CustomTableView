//
//  ViewController.m
//  CustomTable
//
//  Created by wei on 2019/3/25.
//  Copyright © 2019年 wei. All rights reserved.
//

#import "ViewController.h"
#import "JSTableView.h"
#import "JSTableCell.h"

@interface ViewController ()<JSTableViewDelegate,JSTableViewDataSource>{
    JSTableView*tableView;
    NSMutableArray*array;
    UITableView*a;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    tableView = [[JSTableView alloc] initWithFrame:self.view.bounds];
    tableView.jsDataSource=self;
    tableView.jsDelegate  =self;
    [self.view addSubview:tableView];
    
    array = [NSMutableArray array];
    NSString*testString = @"秋天，一个金色美好的季节，它带走的不仅仅是酷暑，也为大地换上了别具一格的新装。我对秋天印象最深的不是一望无际的丰收稻田，也不是果实累累的果园，而是那最平凡不过的树叶了。作为秋天树叶的象征，满山遍野的红枫成为最醒目的主角。远远眺望，那一团团熊熊燃烧的烈火，显示出它们顽强的生命力。走进枫林，片片宛如小手掌似的枫叶环绕在你的周围。一阵清爽的秋风吹过，带着万般眷恋的树叶，悄然无声地投进大地母亲温暖的环抱。调皮的树叶有时也会与风姑娘玩起捉迷藏游戏，伴随着山鸣谷应和树叶们演奏的沙沙乐曲，跟随着小鸟动听的歌喉，尽情地展示自己，沐浴着阳光在翩翩起舞。若你拾起一片枫叶，夹杂着泥土馨香的味道就会扑鼻而来。从枫叶清晰的叶脉、色彩的变化中我对唐代著名诗人杜牧的：“停车坐爱枫林晚，霜叶红于二月花”有了颇深的体会。最常见的梧桐树叶在沐浴阳光的同时也为写生者创建了一幅瑰丽的油画。从树叶的经脉处透露出秋的萧瑟，而与此不和谐的是绿油油的叶子，它们衬托出了秋的生机勃勃，构成了一幅鲜明的对比画。数不胜数的银杏叶也不亚于梧桐，它们奇特的小扇形树叶引人注目。当你漫步在银杏的“海洋”中时，就会被金色之秋所吸引，甚至自己也会化成片片被秋风摇曳的树叶，在风中回旋";
    NSInteger length = testString.length;
    for(int i=0;i<200;i++){
        NSInteger len = arc4random()%10+10;
        NSInteger loc = arc4random()%(length-len);
        [array addObject:[NSString stringWithFormat:@"%d.%@",i,[testString substringWithRange:NSMakeRange(loc, len)]]];
    }
    [tableView reloadData]; 
}

#pragma mark -JSTableViewDataSource-
- (NSInteger)cellNumbersWithTableView:(JSTableView *)tableView{
    return array.count;
}
- (CGFloat)tableView:(JSTableView *)tableView cellHightForRow:(NSInteger)row{
    return 40;
}
- (JSTableCell *)tableView:(JSTableView *)tableView cellForRow:(NSInteger)row{
    JSTableCell*cell = [tableView dequeueReusableCell];
    if(!cell){
        cell = [[JSTableCell alloc] init];
    }
    cell.lb.text = array[row];
    return cell;
}
#pragma mark -JSTableViewDelegate-
- (void)tableView:(JSTableView *)tableView didSelectRow:(NSInteger)row{
    NSLog(@"点击了 %ld 个",row);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
