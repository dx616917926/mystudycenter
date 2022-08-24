//
//  HXDayCell.m
//  HXMinedu
//
//  Created by mac on 2022/8/12.
//

#import "HXDayCell.h"

@interface HXDayCell ()

@property(nonatomic,strong) UIView *bgView;
@property(nonatomic,strong) UILabel *dayLabel;
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
#pragma mark - Setter
-(void)setKejieCalendarModel:(HXKejieCalendarModel *)kejieCalendarModel{
    
    _kejieCalendarModel = kejieCalendarModel;
    
    
    
    if (kejieCalendarModel.Date.length>=8) {
        self.dayLabel.text = [kejieCalendarModel.Date substringFromIndex:8];
    }
    
    if (kejieCalendarModel.Qty>0) {
        self.numLabel.text = [NSString stringWithFormat:@"%ld节",(long)kejieCalendarModel.Qty];
    }else{
        self.numLabel.text = @"";
    }
    
    
    if (kejieCalendarModel.IsSelect) {
        self.bgView.backgroundColor = COLOR_WITH_ALPHA(0x4988FD, 1);
        self.dayLabel.textColor = self.numLabel.textColor = COLOR_WITH_ALPHA(0xFFFFFF, 1);
    }else{
        self.bgView.backgroundColor = UIColor.clearColor;
        if (kejieCalendarModel.IsMonth==1) {
            self.dayLabel.textColor = (kejieCalendarModel.Qty>0?COLOR_WITH_ALPHA(0x4988FD, 1):COLOR_WITH_ALPHA(0x181414, 1));
            self.numLabel.textColor = COLOR_WITH_ALPHA(0x4988FD, 1);
        }else{
            self.numLabel.textColor = self.dayLabel.textColor = COLOR_WITH_ALPHA(0x9F9F9F, 1);
        }
    }
}

#pragma mark - UI
-(void)createUI{
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.dayLabel];
    [self.bgView addSubview:self.numLabel];
    
    self.bgView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 5, 0, 5));
    self.bgView.sd_cornerRadius = @2;
    
    
    self.dayLabel.sd_layout
    .topSpaceToView(self.bgView, 0)
    .leftEqualToView(self.bgView)
    .rightEqualToView(self.bgView)
    .heightIs(22);
    
    self.numLabel.sd_layout
    .bottomEqualToView(self.bgView).offset(-4)
    .leftEqualToView(self.bgView)
    .rightEqualToView(self.bgView)
    .heightIs(18);
}



#pragma mark - LazyLoad
-(UIView *)bgView{
    if(!_bgView){
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = COLOR_WITH_ALPHA(0xFFFFFF, 1);
        _bgView.clipsToBounds = YES;
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
    }
    return _numLabel;
}

@end
