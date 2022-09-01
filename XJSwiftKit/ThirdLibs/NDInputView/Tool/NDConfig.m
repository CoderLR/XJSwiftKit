//
//  NDConfig.m
//  ND
//
//  Created by kennethmiao on 2018/11/5.
//  Copyright © 2018年 Tencent. All rights reserved.
//

#import "NDConfig.h"
#import "NDHeader.h"
#import "NDFaceCell.h"

#import "NDImageCache.h"

@interface NDConfig ()


//提前加载资源（全路径）


@end

@implementation NDConfig

- (id)init
{
    self = [super init];
    if(self){
        [self defaultResourceCache];
        [self defaultFace];
    }
    return self;
}

+ (id)defaultConfig
{
    static dispatch_once_t onceToken;
    static NDConfig *config;
    dispatch_once(&onceToken, ^{
        config = [[NDConfig alloc] init];
    });
    return config;
}

/**
 *  初始化默认表情，并将配默认表情写入本地缓存，方便下一次快速加载
 */
- (void)defaultFace
{
    NSMutableArray *faceGroups = [NSMutableArray array];
    //emoji group
    NSMutableArray *emojiFaces = [NSMutableArray array];
    NSArray *emojis = [NSArray arrayWithContentsOfFile:NDFace(@"emoji/emoji.plist")];
    for (NSDictionary *dic in emojis) {
        TFaceCellData *data = [[TFaceCellData alloc] init];
        NSString *name = [dic objectForKey:@"face_name"];
        NSString *path = [NSString stringWithFormat:@"emoji/%@", name];
        data.name = name;
        data.path = NDFace(path);
        [self addFaceToCache:data.path];
        [emojiFaces addObject:data];
    }
    if(emojiFaces.count != 0){
        TFaceGroup *emojiGroup = [[TFaceGroup alloc] init];
        emojiGroup.groupIndex = 0;
        emojiGroup.groupPath = NDFace(@"emoji/");
        emojiGroup.faces = emojiFaces;
        emojiGroup.rowCount = 3;
        emojiGroup.itemCountPerRow = 9;
        emojiGroup.needBackDelete = YES;
        emojiGroup.menuPath = NDFace(@"emoji/menu");
        [self addFaceToCache:emojiGroup.menuPath];
        [faceGroups addObject:emojiGroup];
        [self addFaceToCache:NDFace(@"del_normal")];
    }
    /*
    //tt group
    NSMutableArray *ttFaces = [NSMutableArray array];
    for (int i = 0; i <= 16; i++) {
        TFaceCellData *data = [[TFaceCellData alloc] init];
        NSString *name = [NSString stringWithFormat:@"tt%02d", i];
        NSString *path = [NSString stringWithFormat:@"tt/%@", name];
        data.name = name;
        data.path = NDFace(path);
        [self addFaceToCache:data.path];
        [ttFaces addObject:data];
    }
    if(ttFaces.count != 0){
        TFaceGroup *ttGroup = [[TFaceGroup alloc] init];
        ttGroup.groupIndex = 1;
        ttGroup.groupPath = NDFace(@"tt/");
        ttGroup.faces = ttFaces;
        ttGroup.rowCount = 2;
        ttGroup.itemCountPerRow = 5;
        ttGroup.menuPath = NDFace(@"tt/menu");
        [self addFaceToCache:ttGroup.menuPath];
        [faceGroups addObject:ttGroup];
    }
    */
    _faceGroups = faceGroups;
   
}





#pragma mark - resource
/**
 *  将配默认配置写入本地缓存，方便下一次快速加载
 */
- (void)defaultResourceCache
{
    //common
    [self addResourceToCache:NDResource(@"more_normal")];
    [self addResourceToCache:NDResource(@"more_pressed")];
    [self addResourceToCache:NDResource(@"face_normal")];
    [self addResourceToCache:NDResource(@"face_pressed")];
    [self addResourceToCache:NDResource(@"keyboard_normal")];
    [self addResourceToCache:NDResource(@"keyboard_pressed")];
    [self addResourceToCache:NDResource(@"voice_normal")];
    [self addResourceToCache:NDResource(@"voice_pressed")];
    //text msg
    [self addResourceToCache:NDResource(@"sender_text_normal")];
    [self addResourceToCache:NDResource(@"sender_text_pressed")];
    [self addResourceToCache:NDResource(@"receiver_text_normal")];
    [self addResourceToCache:NDResource(@"receiver_text_pressed")];
    //void msg
    [self addResourceToCache:NDResource(@"sender_voice")];
    [self addResourceToCache:NDResource(@"receiver_voice")];
    [self addResourceToCache:NDResource(@"sender_voice_play_1")];
    [self addResourceToCache:NDResource(@"sender_voice_play_2")];
    [self addResourceToCache:NDResource(@"sender_voice_play_3")];
    [self addResourceToCache:NDResource(@"receiver_voice_play_1")];
    [self addResourceToCache:NDResource(@"receiver_voice_play_2")];
    [self addResourceToCache:NDResource(@"receiver_voice_play_3")];
    //file msg
    [self addResourceToCache:NDResource(@"msg_file")];
    //video msg
    [self addResourceToCache:NDResource(@"play_normal")];
}


- (void)addResourceToCache:(NSString *)path
{
    [[NDImageCache sharedInstance] addResourceToCache:path];
}


- (void)addFaceToCache:(NSString *)path
{
    [[NDImageCache sharedInstance] addFaceToCache:path];
}


@end
