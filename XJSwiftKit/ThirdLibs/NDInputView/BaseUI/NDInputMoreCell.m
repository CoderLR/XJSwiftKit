//
//  TMoreCell.m
//  UIKit
//
//  Created by annidyfeng on 2019/5/22.
//

#import "NDInputMoreCell.h"
#import "NDHeader.h"
//#import "ND.h"


static NDInputMoreCellData *TUI_Photo_MoreCell;
static NDInputMoreCellData *TUI_Picture_MoreCell;
static NDInputMoreCellData *TUI_Video_MoreCell;
static NDInputMoreCellData *TUI_File_MoreCell;

@implementation NDInputMoreCellData



+ (NDInputMoreCellData *)pictureData
{
    if (!TUI_Picture_MoreCell) {
        TUI_Picture_MoreCell = [[NDInputMoreCellData alloc] init];
        TUI_Picture_MoreCell.title = @"拍摄";
        TUI_Picture_MoreCell.image = [UIImage imageNamed:@"course_icon_more_pz"];

    }
    return TUI_Picture_MoreCell;
}

+ (void)setPictureData:(NDInputMoreCellData *)cameraData
{
    TUI_Picture_MoreCell = cameraData;
}

+ (NDInputMoreCellData *)photoData
{
    if (!TUI_Photo_MoreCell) {
        TUI_Photo_MoreCell = [[NDInputMoreCellData alloc] init];
        TUI_Photo_MoreCell.title = @"相册";
        TUI_Photo_MoreCell.image = [UIImage imageNamed:@"course_icon_more_xc"];
    }
    return TUI_Photo_MoreCell;
}

+ (void)setPhotoData:(NDInputMoreCellData *)pictureData
{
    TUI_Photo_MoreCell = pictureData;
}

+ (NDInputMoreCellData *)videoData
{
    if (!TUI_Video_MoreCell) {
        TUI_Video_MoreCell = [[NDInputMoreCellData alloc] init];
        TUI_Video_MoreCell.title = @"视频";
        TUI_Video_MoreCell.image = [UIImage imageNamed:@"course_icon_more_sp"];
    }
    return TUI_Video_MoreCell;
}

+ (void)setVideoData:(NDInputMoreCellData *)videoData
{
    TUI_Video_MoreCell = videoData;
}

+ (NDInputMoreCellData *)fileData
{
    if (!TUI_File_MoreCell) {
        TUI_File_MoreCell = [[NDInputMoreCellData alloc] init];
        TUI_File_MoreCell.title = @"课程文件";
        TUI_File_MoreCell.image = [UIImage imageNamed:@"course_icon_more_kj"];
    }
    return TUI_File_MoreCell;
}

+ (void)setFileData:(NDInputMoreCellData *)fileData
{
    TUI_File_MoreCell = fileData;
}

@end

@implementation NDInputMoreCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self setupViews];
    }
    return self;
}

- (void)setupViews
{
    _image = [[UIImageView alloc] init];
    _image.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_image];

    _title = [[UILabel alloc] init];
    [_title setFont:[UIFont systemFontOfSize:12]];
    [_title setTextColor:[UIColor colorWithRed:92/255.0 green:92/255.0 blue:92/255.0 alpha:1.0]];
    if (@available(iOS 12.0, *)) {
        if (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark){
            [_title setTextColor:[UIColor lightGrayColor]];
        }else{
            [_title setTextColor:[UIColor grayColor]];
        }
    } else {
        // Fallback on earlier versions
       [_title setTextColor:[UIColor grayColor]];
    }
    _title.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_title];
}

- (void)fillWithData:(NDInputMoreCellData *)data
{
    //set data
    _data = data;
    _image.image = data.image;
    [_title setText:data.title];
    //update layout
    CGSize menuSize = TMoreCell_Image_Size;
    _image.frame = CGRectMake(0, 0, menuSize.width, menuSize.height);
    _title.frame = CGRectMake(0, _image.frame.origin.y + _image.frame.size.height+TMoreCell_Title_Image_Margin, _image.frame.size.width, TMoreCell_Title_Height);
}

+ (CGSize)getSize
{
    CGSize menuSize = TMoreCell_Image_Size;
    return CGSizeMake(menuSize.width, menuSize.height + TMoreCell_Title_Height+TMoreCell_Title_Image_Margin+TMoreCell_Bottom);
}
@end
