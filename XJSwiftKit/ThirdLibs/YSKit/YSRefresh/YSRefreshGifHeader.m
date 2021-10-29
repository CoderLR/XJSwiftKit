//
//  YSRefreshGifHeader.m
//  MyChat
//
//  Created by Mr.Yang on 2017/6/27.
//  Copyright © 2017年 jiankangzhan. All rights reserved.
//

#import "YSRefreshGifHeader.h"

@interface YSRefreshGifHeader () {
    __unsafe_unretained UIImageView *_gifView;
}
/** 所有状态对应的动画图片 */
@property (strong, nonatomic) NSMutableDictionary *stateImages;
/** 所有状态对应的动画时间 */
@property (strong, nonatomic) NSMutableDictionary *stateDurations;

@end

@implementation YSRefreshGifHeader

#pragma mark - 懒加载
- (UIImageView *)gifView {
    if (!_gifView) {
        UIImageView *gifView = [[UIImageView alloc] init];
        [self addSubview:_gifView = gifView];
    }
    return _gifView;
}

- (NSMutableDictionary *)stateImages {
    if (!_stateImages) {
        self.stateImages = [NSMutableDictionary dictionary];
    }
    return _stateImages;
}

- (NSMutableDictionary *)stateDurations {
    if (!_stateDurations) {
        self.stateDurations = [NSMutableDictionary dictionary];
    }
    return _stateDurations;
}

#pragma mark - 公共方法
- (instancetype)setImages:(NSArray *)images duration:(NSTimeInterval)duration forState:(MJRefreshState)state {
    if (images == nil) return nil;
    
    self.stateImages[@(state)] = images;
    self.stateDurations[@(state)] = @(duration);
    
    /* 根据图片设置控件的高度 */
    UIImage *image = [images firstObject];
    if (image.size.height > self.mj_h) {
        self.mj_h = image.size.height;
    }
    return self;
}

- (instancetype)setImages:(NSArray *)images forState:(MJRefreshState)state {
    return [self setImages:images duration:images.count * 0.1 forState:state];
}

#pragma mark - 实现父类的方法
- (void)prepare {
    [super prepare];
    
    self.mj_h = 60.f;
    
    // 初始化间距
    self.labelLeftInset = 20;
    self.stateLabel.font = [UIFont systemFontOfSize:13.f];
    
    // 设置文字
    [self setTitle:@"下拉刷新..." forState:MJRefreshStateIdle];
    [self setTitle:@"松开刷新..." forState:MJRefreshStatePulling];
    [self setTitle:@"正在加载..." forState:MJRefreshStateRefreshing];
    
    
    // logo icon_mine_bg_image
    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_launchImage_top"]];
    logo.contentMode = UIViewContentModeScaleToFill;
    logo.backgroundColor = [UIColor whiteColor];
    [self insertSubview:logo atIndex:0];
    self.logo = logo;
}

- (void)setPullingPercent:(CGFloat)pullingPercent {
    [super setPullingPercent:pullingPercent];
    NSArray *images = self.stateImages[@(MJRefreshStateIdle)];
    if (self.state != MJRefreshStateIdle || images.count == 0) return;
    // 停止动画
    [self.gifView stopAnimating];
    // 设置当前需要显示的图片
    NSUInteger index =  images.count * pullingPercent;
    if (index >= images.count) index = images.count - 1;
    self.gifView.image = images[index];
}

- (void)placeSubviews {
    [super placeSubviews];
    
    self.logo.mj_size = CGSizeMake(self.mj_w, 287.f);
    self.logo.mj_y = -self.logo.mj_h + self.mj_h;
    self.logo.mj_x = 0;
    
    if (self.gifView.constraints.count) return;
    
    self.gifView.frame = self.bounds;
    if (self.stateLabel.hidden && self.lastUpdatedTimeLabel.hidden) {
        self.gifView.contentMode = UIViewContentModeCenter;
    } else {
        self.gifView.mj_size = CGSizeMake(30.f, 30.f);
        CGFloat stateWidth = self.stateLabel.mj_textWidth;
        self.stateLabel.mj_size = CGSizeMake(stateWidth, 30.f);
        
        self.gifView.mj_y = (self.mj_h - 30.f) * 0.5;
        self.stateLabel.mj_y = (self.mj_h - 30.f) * 0.5;
        
        self.gifView.mj_x = (self.mj_w - 30.f - self.labelLeftInset - stateWidth) * 0.5;
        self.stateLabel.mj_x = CGRectGetMaxX(self.gifView.frame) + self.labelLeftInset;
    }
}

- (void)setState:(MJRefreshState)state {
    MJRefreshCheckState
    // 根据状态做事情
    if (state == MJRefreshStatePulling || state == MJRefreshStateRefreshing) {
        NSArray *images = self.stateImages[@(state)];
        if (images.count == 0) return;
        
        [self.gifView stopAnimating];
        if (images.count == 1) { // 单张图片
            self.gifView.image = [images lastObject];
        } else { // 多张图片
            self.gifView.animationImages = images;
            self.gifView.animationDuration = [self.stateDurations[@(state)] doubleValue];
            [self.gifView startAnimating];
        }
    } else if (state == MJRefreshStateIdle) {
        [self.gifView stopAnimating];
    }
}

@end
