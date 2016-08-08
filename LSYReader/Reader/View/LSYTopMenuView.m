//
//  LSYTopMenuView.m
//  LSYReader
//
//  Created by Labanotation on 16/6/1.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import "LSYTopMenuView.h"
#import "LSYMenuView.h"
@interface LSYTopMenuView ()
@property (nonatomic,strong) UIButton *back;
@property (nonatomic,strong) UIButton *more;
@end
@implementation LSYTopMenuView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}
-(void)setup
{
    [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]];
    [self addSubview:self.back];
    [self addSubview:self.more];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetBookMarks:) name:@"BookMarkReset" object:nil];
}

-(void)resetBookMarks:(NSNotification *)no
{
    NSString *result = no.object;
    if([result isEqualToString:@"success"]){
        [_more setImage:[UIImage imageNamed:@"RibbonOff"] forState:UIControlStateNormal];

    }
}

-(UIButton *)back
{
    if (!_back) {
        _back = [LSYReadUtilites commonButtonSEL:@selector(backView) target:self];
        [_back setImage:[UIImage imageNamed:@"bg_back_white"] forState:UIControlStateNormal];
    }
    return _back;
}
-(UIButton *)more
{
    if (!_more) {
        _more = [LSYReadUtilites commonButtonSEL:@selector(moreOption) target:self];
        [_more setImage:[UIImage imageNamed:@"RibbonOff"] forState:UIControlStateNormal];
        [_more setImageEdgeInsets:UIEdgeInsetsMake(7.5, 12.5, 7.5, 12.5)];
    }
    return _more;
}
-(void)moreOption
{
    Boolean isSuccess;
    if ([self.delegate respondsToSelector:@selector(menuViewMark:)]) {
        isSuccess = [self.delegate menuViewMark:self];
    }
    if(isSuccess){
        [LSYReadUtilites showAlertTitle:nil content:@"保存书签成功"];
        [_more setImage:[UIImage imageNamed:@"RibbonOn"] forState:UIControlStateNormal];
        
    }else{
        [LSYReadUtilites showAlertTitle:nil content:@"去除书签成功"];
        [_more setImage:[UIImage imageNamed:@"RibbonOff"] forState:UIControlStateNormal];
    }
}
-(void)backView
{
    [[LSYReadUtilites getCurrentVC] dismissViewControllerAnimated:YES completion:nil];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    _back.frame = CGRectMake(0, 24, 40, 40);
    _more.frame = CGRectMake(ViewSize(self).width-50, 24, 40, 40);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
