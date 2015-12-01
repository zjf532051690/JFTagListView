//
//  JFTagListView.m
//  JFTagListView
//
//  Created by 张剑锋 on 15/11/30.
//  Copyright © 2015年 张剑锋. All rights reserved.
//

#import "JFTagListView.h"
#import "UIView+JFExtension.h"

#define K_Tag_Title_H_Marin         10.0f
#define K_Tag_Title_V_Marin         5.0f

#define K_Tag_Left_Margin     10.0f
#define K_Tag_Right_Margin    K_Tag_Left_Margin
#define K_Tag_Top_Margin      10.0f
#define K_Tag_Bottom_Margin   K_Tag_Top_Margin

#define Image_Width  10
#define Image_Height  Image_Width

#define KTapLabelTag       10086
#define KButtonTag         12580

#define KTagCornerWidth    10.0f
#define KTagFont           15.0f


//设备屏幕尺寸
#define JF_Screen_Height       ([UIScreen mainScreen].bounds.size.height)
#define JF_Screen_Width        ([UIScreen mainScreen].bounds.size.width)


@interface JFTagListView ()<UIAlertViewDelegate>{
    
    CGRect  previousFrame ;
    float   tagView_height ;
    NSInteger tagIndex;
}

@end

@implementation JFTagListView

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.frame = frame;
    }
    return self;
}


#pragma mark- 初始化UI

-(void)creatUI:(NSMutableArray *)tagArr{
    
    self.tagArr = [NSMutableArray arrayWithArray:[tagArr mutableCopy]];
    
    if (self.is_can_addTag) {//如果可以添加标签，那么数组就多一个添加标签按钮
        [self.tagArr addObject:self.addTagStr.length>0?self.addTagStr:@"添加标签"];
    }
    tagView_height = 0;
    
    self.backgroundColor = self.tagViewBackgroundColor?self.tagViewBackgroundColor:[UIColor whiteColor];
    
    previousFrame = CGRectZero;
    
    [self.tagArr enumerateObjectsUsingBlock:^(id value, NSUInteger idx, BOOL *stop) {
        
        //Tag标题（看传入的是字典还是字符串）
        NSMutableString *titleStr = [NSMutableString stringWithString:self.tagStateType==1?@"  ":@""];
        if ([value isKindOfClass:[NSString class]]) {
            [titleStr appendString:value];
        }else if([value isKindOfClass:[NSDictionary class]]){
            if (!self.tagArrkey) {
                //获取不到Value，因为没传入Key
                NSLog(@"获取不到Value，因为没传入Key");
                return ;
            }
            [titleStr appendString:[value valueForKey:self.tagArrkey]];
        }
        
        //创建Label
        UILabel*tagLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        [self creatTagUI:tagLabel];
        tagLabel.text = titleStr;
        tagLabel.tag = KTapLabelTag+idx;
        
        //计算label的大小
        NSDictionary *attrs = @{NSFontAttributeName : [UIFont systemFontOfSize:self.tagFont?self.tagFont:KTagFont]};
        CGSize Size_str = [titleStr sizeWithAttributes:attrs];
        Size_str.width += K_Tag_Title_H_Marin*2;
        Size_str.height += K_Tag_Title_V_Marin*2;
        
        CGRect newRect = CGRectZero;
        
        if (previousFrame.origin.x + previousFrame.size.width + Size_str.width + K_Tag_Right_Margin > JF_Screen_Width) {
            
            newRect.origin = CGPointMake(10, previousFrame.origin.y + Size_str.height + K_Tag_Bottom_Margin);
            tagView_height += Size_str.height + K_Tag_Bottom_Margin;
        }
        else {
            newRect.origin = CGPointMake(previousFrame.origin.x + previousFrame.size.width + K_Tag_Right_Margin, previousFrame.origin.y);
            
        }
        newRect.size = Size_str;
        [tagLabel setFrame:newRect];
        previousFrame=tagLabel.frame;
        
        //改变控件高度
        if (idx==self.tagArr.count-1) {
            [self setHight:self andHight:tagView_height+Size_str.height + K_Tag_Bottom_Margin];
        }
        [self addSubview:tagLabel];
        
        
        //新增删除、添加功能
        if (self.is_can_addTag&&idx==self.tagArr.count-1) {//能添加状态&&最后一个-->(进入添加tag界面不用显示删除图片)
            
        }else{
            if (self.tagStateType==1) {
                //移除的图片
                UIImageView *removeImage = [[UIImageView alloc] initWithFrame:CGRectMake(tagLabel.jf_right-Image_Width*1.5, tagLabel.jf_top+(tagLabel.jf_height-Image_Height)/2, Image_Width, Image_Height)];
                //删除图片可以换成自己的图片
                removeImage.image = [UIImage imageNamed:@"btn_removeTag"];
                [self addSubview:removeImage];
            }
        }
        
        
        //点击按钮
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(tagLabel.frame.origin.x, tagLabel.frame.origin.y, tagLabel.frame.size.width, tagLabel.frame.size.height)];
        [button setTag:KButtonTag+idx];
        [button addTarget:self action:@selector(clickTag:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        
    }];
}

//初始化Tag的UI
-(void)creatTagUI:(UILabel *)tagLabel{
    
    tagLabel.backgroundColor = self.tagBackgroundColor?self.tagBackgroundColor:[UIColor whiteColor];
    
    tagLabel.textAlignment = self.tagStateType==1?NSTextAlignmentLeft:NSTextAlignmentCenter;
    
    tagLabel.textColor = self.tagTextColor?self.tagTextColor:[UIColor lightGrayColor];
    
    tagLabel.font = [UIFont systemFontOfSize:self.tagFont?self.tagFont:KTagFont];
    
    tagLabel.layer.cornerRadius = self.tagCornerRadius?self.tagCornerRadius:KTagCornerWidth;
    tagLabel.layer.masksToBounds = YES;
    
    tagLabel.layer.borderColor = self.tagBorderColor?[self.tagBorderColor CGColor]:[[UIColor lightGrayColor] CGColor];
    
    tagLabel.layer.borderWidth = self.tagBorderWidth?self.tagBorderWidth:1;
    
    tagLabel.clipsToBounds = YES;
}

#pragma mark- 改变控件高度

- (void)setHight:(UIView *)view andHight:(CGFloat)height
{
    [UIView animateWithDuration:0.0 animations:^{
        CGRect tempFrame = view.frame;
        tempFrame.size.height = height;
        view.frame = tempFrame;
        if ([self.delegate respondsToSelector:@selector(tagList:heightForView:)]) {
            [self.delegate tagList:self heightForView:height];
        }
    }];
}

#pragma mark- 刷新数据

//刷新数据（默认时间0.5秒）
- (void)reloadData:(NSMutableArray *)newTagArr{
    
    [self reloadData:newTagArr andTime:0.5];
}

//刷新数据（时间为time）
- (void)reloadData:(NSMutableArray *)newTagArr andTime:(float)time{
    
    [UIView animateWithDuration:time animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        [UIView animateWithDuration:time animations:^{
            self.alpha = 1;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self creatUI:newTagArr];
            });
        }];
    }];
}

#pragma mark- 点击事件

//点击标签
- (void)clickTag:(UIButton *)sender{
    tagIndex = sender.tag-KButtonTag;
    
    if (self.is_can_addTag) {
        if (tagIndex == self.tagArr.count-1) {
            //进入添加Tag的界面
            if ([self.delegate respondsToSelector:@selector(showAddTagView)]) {
                [self.delegate showAddTagView];
            }else{
                NSLog(@"没有添加添加Tag的页面");
            }
            return;
        }
    }
    
    if (self.tagStateType == TagStateSelect) {
        //选择tag
        if ([self.delegate respondsToSelector:@selector(tagList:clickedButtonAtIndex:)]) {
            [self.delegate tagList:self clickedButtonAtIndex:tagIndex];
        }
        return;
    }
    
    
    if (self.tagStateType == TagStateEdit) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否删除标签?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
}

#pragma mark- AlertView 代理

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex==1) {
        //删除tag
        [self.delegate tagList:self clickedButtonAtIndex:tagIndex];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
