//
//  NDEmojiAttributedString.h
//  iOS-Education
//
//  Created by apple on 2020/9/27.
//  Copyright © 2020 魏延龙. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NDEmojiAttributedString: NSObject

+ (NSAttributedString *)formatMessageStringWithString:(NSString *)text withTextFont:(UIFont *)textFont;
+ (NSAttributedString *)formatMessageStringWithAttributedString:(NSMutableAttributedString *)mAttributedText withTextFont:(UIFont *)textFont;

@end

NS_ASSUME_NONNULL_END
