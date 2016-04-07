//
//  ViewController.h
//  单元格的操作
//
//  Created by zhaohe on 16/4/7.
//  Copyright © 2016年 com.MrHe.Mission. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong)UITableView *gameTableView;
/** 底部删除按钮 */
@property (nonatomic ,strong)UIButton *deleteButton;
/** 数据源 */
@property (nonatomic ,copy)NSMutableArray *gameArrs;
/** 标记是否全选 */
@property (nonatomic ,assign)BOOL isAllSelected;
@end

@implementation ViewController


-(NSMutableArray *)gameArrs
{
    
    if (!_gameArrs) {
        _gameArrs = [NSMutableArray arrayWithArray:@[@"列表1",@"列表2",@"列表3",@"列表4",@"列表5",@"列表6",@"列表7",@"列表8",@"列表9",@"列表10",@"列表11",@"列表12",@"列表13",@"列表14",@"列表15",@"列表16",@"列表17",@"列表18",@"列表19",@"列表20",@"列表21",@"列表22",@"列表23",@"列表24"]];
    }
    return _gameArrs;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"单元格全选/多选操作";
    self.gameTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.gameTableView.delegate = self;
    self.gameTableView.dataSource = self;
    self.gameTableView.tableFooterView = [[UIView alloc] init];
    self.gameTableView.backgroundColor = [UIColor whiteColor];
    self.gameTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.gameTableView];
    
    /*=========================至关重要============================*/
    self.gameTableView.allowsMultipleSelectionDuringEditing = YES;
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(edit)];
    /** 底部删除按钮 */
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.deleteButton = deleteButton;
    [self.view addSubview:deleteButton];
    [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    [deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [deleteButton setBackgroundColor:[[UIColor redColor] colorWithAlphaComponent:0.7f]];
    [deleteButton setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 40)];
    deleteButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [deleteButton addTarget:self action:@selector(deleteArr) forControlEvents:UIControlEventTouchUpInside];
}


-(void)edit
{
    /** 每次点击 rightBarButtonItem 都要取消全选 */
    self.isAllSelected = NO;
    
    NSString *string = !self.gameTableView.editing?@"取消":@"编辑";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:string style:UIBarButtonItemStyleDone target:self action:@selector(edit)];
    
    
    if (self.gameArrs.count) {
        self.navigationItem.leftBarButtonItem = !self.gameTableView.editing? [[UIBarButtonItem alloc]initWithTitle:@"全选" style:UIBarButtonItemStyleDone target:self action:@selector(selectAll)]:nil;
        CGFloat height = !self.gameTableView.editing?40:0;
        
        [UIView animateWithDuration:0.25 animations:^{
            self.deleteButton.frame = CGRectMake(0, self.view.frame.size.height - height, self.view.frame.size.width, 40);
            
        }];
    }else{
        
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem = nil;
        
        [UIView animateWithDuration:0.25 animations:^{
            self.deleteButton.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 40);
            
        }];
    }
    
    self.gameTableView.editing = !self.gameTableView.editing;
    
}
#pragma mark - 多选删除

-(void)deleteArr
{
    
    NSMutableArray *deleteArrarys = [NSMutableArray array];
    for (NSIndexPath *indexPath in self.gameTableView.indexPathsForSelectedRows) {
        [deleteArrarys addObject:self.gameArrs[indexPath.row]];
    }
    
    
    
    [UIView animateWithDuration:0 animations:^{
        [self.gameArrs removeObjectsInArray:deleteArrarys];
        [self.gameTableView reloadData];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.25 animations:^{
            
            if (!self.gameArrs.count) {
                self.navigationItem.leftBarButtonItem = nil;
                self.navigationItem.rightBarButtonItem = nil;
                self.deleteButton.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 40);
                
                
            }
            
        } completion:^(BOOL finished) {
            /** 考虑到全选之后 ，反选几个 再删除  需要将全选置为NO, */
            self.isAllSelected = NO;
            
        }];
    }];
    
    
}

#pragma mark - 全选删除
-(void)selectAll
{
    
    self.isAllSelected = !self.isAllSelected;
    
    for (int i = 0; i<self.gameArrs.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        
        
        if (self.isAllSelected) {
            [self.gameTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        }else{//反选
            
            [self.gameTableView deselectRowAtIndexPath:indexPath animated:YES];
            
        }
    }
}


#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.gameArrs.count;
    
    
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifi = @"gameCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifi];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifi];
    }
    
    /**
     *  单元格的选中类型一定不能设置为 UITableViewCellSelectionStyleNone，如果加上这一句，全选勾选不出来
     */
    
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.textLabel.text = self.gameArrs[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
    
}
#pragma mark - 左滑删除
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.gameArrs removeObjectAtIndex:indexPath.row];
        [self.gameTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}


#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 50.0f;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return UITableViewCellEditingStyleDelete;
    
}





@end
