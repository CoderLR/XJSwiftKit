#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "UINavigationController+WXSTransition.h"
#import "UIViewController+WXSTransition.h"
#import "UIViewController+WXSTransitionProperty.h"
#import "WXSPercentDrivenInteractiveTransition.h"
#import "WXSTransitionManager+BoomAnimation.h"
#import "WXSTransitionManager+BrickAnimation.h"
#import "WXSTransitionManager+CoverAnimation.h"
#import "WXSTransitionManager+FragmentAnimation.h"
#import "WXSTransitionManager+InsideThenPushAnimation.h"
#import "WXSTransitionManager+PageAnimation.h"
#import "WXSTransitionManager+SpreadAnimation.h"
#import "WXSTransitionManager+SystermAnimation.h"
#import "WXSTransitionManager+TypeTool.h"
#import "WXSTransitionManager+ViewMoveAnimation.h"
#import "WXSTransitionManager.h"
#import "WXSTransitionProperty.h"
#import "WXSTypedefConfig.h"

FOUNDATION_EXPORT double WXSTransitionVersionNumber;
FOUNDATION_EXPORT const unsigned char WXSTransitionVersionString[];

