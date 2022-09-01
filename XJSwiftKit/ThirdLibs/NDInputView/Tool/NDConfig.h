//
//  NDConfig.h
//  ND
//
//  Created by kennethmiao on 2018/11/5.
//  Copyright © 2018年 Tencent. All rights reserved.
//
/** 腾讯云 NDConfig
 *
 *
 *  本类依赖于腾讯云 IM SDK 实现
 *  ND 中的组件在实现 UI 功能的同时，调用 IM SDK 相应的接口实现 IM 相关逻辑和数据的处理
 *  您可以在ND的基础上做一些个性化拓展，即可轻松接入IM SDK
 *
 *  NDConfig 实现了配置文件的默认初始化，您可以根据您的需求在此更改默认配置，或通过此类修改配置
 *  配置文件包括表情、默认图标等等
 *
 *  需要注意的是 ND 里面的表情包都是有版权限制的，请在上线的时候替换成自己的表情包，否则会面临法律风险
 */

#import <Foundation/Foundation.h>
#import "NDFaceView.h"

@interface NDConfig : NSObject
/**
 * 表情列表（需要注意的是 ND 里面的表情包都是有版权限制的，请在上线的时候替换成自己的表情包，否则会面临法律风险）
 */
@property (nonatomic, strong) NSArray<TFaceGroup *> *faceGroups;


+ (NDConfig *)defaultConfig;

@end
