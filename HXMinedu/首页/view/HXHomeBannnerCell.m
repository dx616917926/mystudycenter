//
//  HXHomeBannnerCell.m
//  HXMinedu
//
//  Created by mac on 2021/5/19.
//

#import "HXHomeBannnerCell.h"

@implementation HXHomeBannnerCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor whiteColor];
        [self createUI];
    }
    return self;
}

-(void)createUI{
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius = 8;
    [self.contentView addSubview:self.showImageView];
    self.showImageView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
}

-(UIImageView *)showImageView{
    if (!_showImageView) {
        _showImageView = [[UIImageView alloc] init];
        _showImageView.backgroundColor = COLOR_WITH_ALPHA(0xEFEFEF, 1);
        _showImageView.contentMode = UIViewContentModeScaleAspectFill;
        _showImageView.userInteractionEnabled = YES;
        _showImageView.layer.masksToBounds = YES;
    }
    return _showImageView;;
}
@end
