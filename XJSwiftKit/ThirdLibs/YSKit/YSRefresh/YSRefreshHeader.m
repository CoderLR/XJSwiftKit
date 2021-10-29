//
//  YSRefreshHeader.m
//  MyChat
//
//  Created by Mr.Yang on 2017/6/27.
//  Copyright © 2017年 jiankangzhan. All rights reserved.
//

#import "YSRefreshHeader.h"
#import <Foundation/Foundation.h>

@interface YSRefreshHeader ()

@property (nonatomic, strong) UILabel *tipLabel;

@end

@implementation YSRefreshHeader

#pragma mark - 重写方法
#pragma mark 基本设置
- (void)prepare {
    [super prepare];
    
    // 添加label
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor redColor];
    label.text = @"松开进入二楼";
    label.hidden = YES;
    label.font = [UIFont boldSystemFontOfSize:12.f];
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    self.tipLabel = label;
    
    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (int i = 0; i <= 24; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"pulling_%02d", i]];
        [idleImages addObject:image];
    }
    [self setImages:idleImages forState:MJRefreshStateIdle];
    
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *pullingImages = [NSMutableArray array];

    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"pulling_%02d", 25]];
    [pullingImages addObject:image];
    [self setImages:pullingImages forState:MJRefreshStatePulling];
    
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (int i = 1; i <= 12; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"refreshing_%02d", i]];
        [refreshingImages addObject:image];
    }

    // 设置正在刷新状态的动画图片
    [self setImages:refreshingImages duration:0.7 forState:MJRefreshStateRefreshing];
}

- (void)placeSubviews {
    [super placeSubviews];
    
    self.tipLabel.mj_size = CGSizeMake(200, 25);
    self.tipLabel.mj_y = -200 + self.mj_h;
    self.tipLabel.mj_x = (self.mj_w - 200) * 0.5;
}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change {
    [super scrollViewContentOffsetDidChange:change];
    
    CGPoint point = [change[@"new"] CGPointValue];
    NSLog(@"%.2f",point.y);
    self.pullingY = point.y;
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change{
    [super scrollViewContentSizeDidChange:change];
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change {
    [super scrollViewPanStateDidChange:change];
}

#pragma mark 监听拖拽比例（控件被拖出来的比例）
- (void)setPullingPercent:(CGFloat)pullingPercent {
    [super setPullingPercent:pullingPercent];
    //    NSLog(@"%f",pullingPercent);
}

@end
