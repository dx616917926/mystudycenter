//
//  HXCommonSelectCell.m
//  HXXiaoGuan
//
//  Created by mac on 2021/6/28.
//

#import "HXCommonSelectCell.h"

@interface HXCommonSelectCell ()

@property(nonatomic,strong) UILabel *contentLabel;

@end

@implementation HXCommonSelectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

-(void)setCommonSelectModel:(HXCommonSelectModel *)commonSelectModel{
    _commonSelectModel = commonSelectModel;
    self.contentLabel.text = commonSelectModel.content;
    if (commonSelectModel.isSelected) {
        self.contentLabel.textColor = COLOR_WITH_ALPHA(0x5699FF, 1);
        self.contentLabel.font =  HXBoldFont(21);
    }else{
        self.contentLabel.textColor = COLOR_WITH_ALPHA(0x858585, 1);
        self.contentLabel.font =  HXBoldFont(15);
    }

}

-(void)createUI{
    [self.contentView addSubview:self.contentLabel];
    
    self.contentLabel.sd_layout
    .centerYEqualToView(self.contentView)
    .leftSpaceToView(self.contentView, 20)
    .rightSpaceToView(self.contentView, 20)
    .heightIs(40);
}


-(UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.font = HXBoldFont(15);
        _contentLabel.textColor = COLOR_WITH_ALPHA(0x858585, 1);
    }
    return _contentLabel;
}

@end
