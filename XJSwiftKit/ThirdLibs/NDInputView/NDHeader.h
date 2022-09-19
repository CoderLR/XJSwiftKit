//
//  NDHeader.h
//  UIKit
//
//  Created by kennethmiao on 2018/9/18.
//  Copyright © 2018年 Tencent. All rights reserved.
//

#ifndef NDHeader_h
#define NDHeader_h

#define Screen_Width        [UIScreen mainScreen].bounds.size.width
#define Screen_Height       [UIScreen mainScreen].bounds.size.height
#define Is_Iphone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define Is_IPhoneX (Screen_Width >=375.0f && Screen_Height >=812.0f && Is_Iphone)

#define StatusBar_Height    (Is_IPhoneX ? (44.0):(20.0))
#define TabBar_Height       (Is_IPhoneX ? (49.0 + 34.0):(49.0))
#define NavBar_Height       (44)
#define SearchBar_Height    (55)
#define Bottom_SafeHeight   (Is_IPhoneX ? (34.0):(0))
#define RGBA(r, g, b, a)    [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:a]
#define RGB(r, g, b)    [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.f]


//cell
#define TMessageCell_Head_Width 45
#define TMessageCell_Head_Height 45
#define TMessageCell_Head_Size CGSizeMake(45, 45)
#define TMessageCell_Padding 8
#define TMessageCell_Margin 8
#define TMessageCell_Indicator_Size CGSizeMake(20, 20)

//voice cell
#define TVoiceMessageCell_ReuseId @"TVoiceMessaageCell"
#define TVoiceMessageCell_Max_Duration 60.0
#define TVoiceMessageCell_Height TMessageCell_Head_Size.height
#define TVoiceMessageCell_Margin 12
#define TVoiceMessageCell_Back_Width_Max (Screen_Width * 0.4)
#define TVoiceMessageCell_Back_Width_Min 60
#define TVoiceMessageCell_Duration_Size CGSizeMake(33, 33)

//text view
#define TTextView_Height (49)
#define TTextView_Button_Size CGSizeMake(30, 30)
#define TTextView_Margin 6
#define TTextView_TextView_Height_Min (TTextView_Height - 2 * TTextView_Margin)
#define TTextView_TextView_Height_Max 80
#define TTextView_Line_Height 0.5
#define TTextView_Line_Color [UIColor colorNamed:@"color_BCBCBC_56585A"]
#define TTextView_Background_Color  [UIColor colorNamed:@"Color_F6F6F6"]

//face view
#define TFaceView_Height 180
#define TFaceView_Margin 12
#define TFaceView_Page_Padding 20
#define TFaceView_Page_Height 30
#define TFaceView_Line_Height 0.5
#define TFaceView_Page_Color [UIColor colorNamed:@"Color_BCBCBC_56585A"]
#define TFaceView_Line_Color [[UIColor colorNamed:@"Color_BCBCBC_56585A"] colorWithAlphaComponent:0.6]
#define TFaceView_Background_Color  [UIColor colorNamed:@"Color_F6F6F6"]

//menu view
#define TMenuView_Send_Color RGBA(44, 145, 247, 1.0)
#define TMenuView_Margin 6
#define TMenuView_Menu_Height 40
#define TMenuView_Line_Width 0.5
#define TMenuView_Line_Color [[UIColor colorNamed:@"Color_BCBCBC_56585A"] colorWithAlphaComponent:0.6]

//more view
#define TMoreView_Column_Count 4
#define TMoreView_Section_Padding 30
#define TMoreView_Margin 10
#define TMoreView_Page_Height 30
#define TMoreView_Page_Color [UIColor colorNamed:@"Color_BCBCBC_56585A"]
#define TMoreView_Line_Height 0.5
#define TMoreView_Line_Color [[UIColor colorNamed:@"Color_BCBCBC_56585A"] colorWithAlphaComponent:0.6]
#define TMoreView_Background_Color  [UIColor colorNamed:@"Color_F6F6F6"]

//menu item cell
#define TMenuCell_ReuseId @"TMenuCell"
#define TMenuCell_Margin 6
#define TMenuCell_Line_ReuseId @"TMenuLineCell"
#define TMenuCell_Selected_Background_Color  [UIColor colorNamed:@"Color_F6F6F6"]
#define TMenuCell_UnSelected_Background_Color  RGBA(255, 255, 255, 1.0)

//more item cell
#define TMoreCell_ReuseId @"TMoreCell"
#define TMoreCell_Margin 5
#define TMoreCell_Image_Size CGSizeMake(64, 64)
#define TMoreCell_Title_Height 17
#define TMoreCell_Title_Image_Margin 4
#define TMoreCell_Bottom 39
//face item cell
#define TFaceCell_ReuseId @"TFaceCell"


//input controller
#define TInputView_Background_Color [UIColor colorNamed:@"Color_F2F2F2_0E0E0E"]

//record
#define Record_Background_Color RGBA(0, 0, 0, 0.6)
#define Record_Background_Size CGSizeMake(Screen_Width * 0.4, Screen_Width * 0.4)
#define Record_Title_Height 30
#define Record_Title_Background_Color RGBA(186, 60, 65, 1.0)
#define Record_Margin 8

//resource
#define NDFace(name) [[NSBundle mainBundle] pathForResource:@"NDFace" ofType:@"bundle"] == nil ? ([[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: @"Frameworks/TXIMSDK_ND_iOS.framework/NDFace.bundle"] stringByAppendingPathComponent:name]) : ([[[NSBundle mainBundle] pathForResource:@"NDFace" ofType:@"bundle"] stringByAppendingPathComponent:name])
#define NDResource(name) [[NSBundle mainBundle] pathForResource:@"NDResource" ofType:@"bundle"] == nil ? ([[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: @"Frameworks/TXIMSDK_ND_iOS.framework/NDResource.bundle"] stringByAppendingPathComponent:name]) : ([[[NSBundle mainBundle] pathForResource:@"NDResource" ofType:@"bundle"] stringByAppendingPathComponent:name])

//path
#define ND_DB_Path [NSHomeDirectory() stringByAppendingString:@"/Documents/com_tencent_imsdk_data/"]
#define ND_Image_Path [NSHomeDirectory() stringByAppendingString:@"/Documents/com_tencent_imsdk_data/image/"]
#define ND_Video_Path [NSHomeDirectory() stringByAppendingString:@"/Documents/com_tencent_imsdk_data/video/"]
#define ND_Voice_Path [NSHomeDirectory() stringByAppendingString:@"/Documents/com_tencent_imsdk_data/voice/"]
#define ND_File_Path  [NSHomeDirectory() stringByAppendingString:@"/Documents/com_tencent_imsdk_data/file/"]


// rich
#define kDefaultRichCellHeight 50
#define kDefaultRichCellMargin 8
#define kRichCellDescColor  [UIColor blackColor]
#define kRichCellValueColor [UIColor grayColor]
#define kRichCellTextFont      [UIFont systemFontOfSize:14]

#endif /* NDHeader_h */
