//
//  ViewController.m
//  JFTagListView
//
//  Created by 张剑锋 on 15/11/30.
//  Copyright © 2015年 张剑锋. All rights reserved.
//

#import "ViewController.h"
#import "JFTagListView.h"
#import "AddTagVC.h"
//设备屏幕尺寸
#define JF_Screen_Height       ([UIScreen mainScreen].bounds.size.height)
#define JF_Screen_Width        ([UIScreen mainScreen].bounds.size.width)


@interface ViewController ()<JFTagListDelegate>

@property (strong, nonatomic) JFTagListView    *tagList;     //自定义标签Viwe

@property (strong, nonatomic) NSMutableArray   *tagArray;    //Tag数组

@property (assign, nonatomic) TagStateType     tagStateType; //标签的模式状态（显示、选择、编辑）
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self creatUI];
}


-(void)creatUI{
    //Tag数据
    _tagArray = [NSMutableArray arrayWithObjects:@"第一个",@"2",@"标签",@"长文字标签", nil];
    self.tagStateType = TagStateNormal;//单单显示模式
    
    //TagView
    self.tagList = [[JFTagListView alloc] initWithFrame:CGRectMake(0, 64+10, JF_Screen_Width, JF_Screen_Height)];
    self.tagList.delegate = self;
    [self.tagList creatUI:_tagArray];
    [self.view addSubview:self.tagList];

    //以下属性是可选的
    self.tagList.tagArrkey = @"name";   //如果传的是字典的话，那么key为必传得
    self.tagList.is_can_addTag = YES;    //如果是要有最后一个按钮是添加按钮的情况，那么为Yes
    self.tagList.tagCornerRadius = 12;  //标签圆角的大小，默认10
    self.tagList.tagStateType = self.tagStateType;  //标签模式，默认显示模式
    
    //刷新数据
    [self.tagList reloadData:_tagArray andTime:0];
}

#pragma mark- TagView 代理

//标签的点击事件
-(void)tagList:(JFTagListView *)taglist clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (self.tagStateType == TagStateEdit) {
        //删除Tag
        [self deleteTagRequest:buttonIndex];
    }else if (self.tagStateType == TagStateSelect){
        //选择tag
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:_tagArray[buttonIndex] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(void)tagList:(JFTagListView *)taglist heightForView:(float)listHeight{

}

//进入添加标签界面
-(void)showAddTagView{
    AddTagVC *addtagVC = [AddTagVC new];
    addtagVC.navigationItem.title = @"添加标签界面";
    [self.navigationController pushViewController:addtagVC animated:YES];
}


#pragma mark- 删除Tag

-(void)deleteTagRequest:(NSInteger)index{
    
    NSLog(@"代理事件，点击第%ld个",index);
    [self.tagArray removeObjectAtIndex:index];
    [self.tagList reloadData:self.tagArray andTime:0];
}


#pragma mark- 切换标签显示模式
- (IBAction)changeTagMode:(UISegmentedControl *)sender {
    self.tagStateType = (int)sender.selectedSegmentIndex;
    self.tagList.tagStateType = self.tagStateType;
    [self.tagList reloadData:_tagArray andTime:0.3];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
