//
//  HXDayCell.m
//  HXMinedu
//
//  Created by mac on 2022/8/12.
//

#import "HXDayCell.h"

@interface HXDayCell ()

@property(nonatomic,strong) UIView *bgView;

@property(nonatomic,strong) UILabel *numLabel;

@end

@implementation HXDayCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        
        [self createUI];
    }
    return self;
}


#pragma mark - UI
-(void)createUI{
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.dayLabel];
    [self.bgView addSubview:self.numLabel];
    
    self.bgView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    self.bgView.sd_cornerRadius = @2;
    
    
    self.dayLabel.sd_layout
    .topSpaceToView(self.bgView, 0)
    .leftEqualToView(self.bgView)
    .rightEqualToView(self.bgView)
    .heightIs(22);
    
    self.numLabel.sd_layout
    .bottomEqualToView(self.bgView)
    .leftEqualToView(self.bgView)
    .rightEqualToView(self.bgView)
    .heightIs(18);
}



#pragma mark - LazyLoad
-(UIView *)bgView{
    if(!_bgView){
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = COLOR_WITH_ALPHA(0xFFFFFF, 1);
    }
    return _bgView;
}

-(UILabel *)dayLabel{
    if(!_dayLabel){
        _dayLabel = [[UILabel alloc] init];
        _dayLabel.font = HXFont(17);
        _dayLabel.textAlignment = NSTextAlignmentCenter;
        _dayLabel.textColor = COLOR_WITH_ALPHA(0x181414, 1);
    }
    return _dayLabel;
}

-(UILabel *)numLabel{
    if(!_numLabel){
        _numLabel = [[UILabel alloc] init];
        _numLabel.font = HXFont(11);
        _numLabel.textAlignment = NSTextAlignmentCenter;
        _numLabel.textColor = COLOR_WITH_ALPHA(0x4988FD, 1);
        _numLabel.text = @"10节";
    }
    return _numLabel;
}

@end
