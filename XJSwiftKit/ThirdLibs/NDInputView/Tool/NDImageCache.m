//
//  NDImageCache.m
//  TXIMSDK_ND_iOS
//
//  Created by annidyfeng on 2019/5/15.
//

#import "NDImageCache.h"
#import "NDHelper.h"

@interface NDImageCache()
@property (nonatomic, strong) NSMutableDictionary *resourceCache;
@property (nonatomic, strong) NSMutableDictionary *faceCache;
@end

@implementation NDImageCache

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static NDImageCache *instance;
    dispatch_once(&onceToken, ^{
        instance = [[NDImageCache alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _resourceCache = [NSMutableDictionary dictionary];
        _faceCache = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)addResourceToCache:(NSString *)path
{
    __weak typeof(self) ws = self;
    [NDHelper asyncDecodeImage:path complete:^(NSString *key, UIImage *image) {
        __strong __typeof(ws) strongSelf = ws;
        [strongSelf.resourceCache setValue:image forKey:key];
    }];
}

- (UIImage *)getResourceFromCache:(NSString *)path
{
    if(path.length == 0){
        return nil;
    }
    UIImage *image = [_resourceCache objectForKey:path];
    if(!image){
        image = [UIImage imageNamed:path];
    }
    return image;
}

- (void)addFaceToCache:(NSString *)path
{
    __weak typeof(self) ws = self;
    [NDHelper asyncDecodeImage:path complete:^(NSString *key, UIImage *image) {
        __strong __typeof(ws) strongSelf = ws;
        [strongSelf.faceCache setValue:image forKey:key];
    }];
}

- (UIImage *)getFaceFromCache:(NSString *)path
{
    if(path.length == 0){
        return nil;
    }
    UIImage *image = [_faceCache objectForKey:path];
    if(!image){
        image = [UIImage imageNamed:path];
    }
    return image;
}
@end
