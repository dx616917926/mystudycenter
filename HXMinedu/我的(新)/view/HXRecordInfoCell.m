//
//  HXRecordInfoCell.m
//  HXMinedu
//
//  Created by mac on 2021/4/7.
//

#import "HXRecordInfoCell.h"

@interface HXRecordInfoCell ()



@end

@implementation HXRecordInfoCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
    
        [self createUI];
    }
    return self;
}



-(void)createUI{
    [self addSubview:self.titleLabel];
    [self addSubview:self.contentLabel];
    
    self.titleLabel.sd_layout
    .leftEqualToView(self)
    .topSpaceToView(self, 0)
    .heightIs(16)
    .widthIs(50);
    
    self.contentLabel.sd_layout
    .topEqualToView(self.titleLabel)
    .leftSpaceToView(self.titleLabel, 5)
    .rightSpaceToView(self, 0)
    .autoHeightRatio(0);
    [self.contentLabel setMaxNumberOfLinesToShow:2];
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _titleLabel.font = HXFont(12);
    }
    return _titleLabel;
}

-(UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.numberOfLines = 0;
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.textColor = COLOR_WITH_ALPHA(0x4BA4FE, 1);
        _contentLabel.font = HXBoldFont(12);
    }
    return _contentLabel;
}
@end
