//
//  HXRefundVoucherCell.m
//  HXMinedu
//
//  Created by mac on 2021/6/8.
//

#import "HXRefundVoucherCell.h"
#import "SDWebimage.h"
@interface HXRefundVoucherCell ()
@property(nonatomic,nonnull) UILabel *refundVoucherLabel;//退费凭证：
@property(nonatomic,nonnull) UIView *refundVoucherContainerView;


@end

@implementation HXRefundVoucherCell

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
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self createUI];
    }
    return self;
}

#pragma mark - Event
-(void)tapImageView:(UITapGestureRecognizer *)ges{
    UIImageView *imageView = (UIImageView*)ges.view;
    NSInteger index = imageView.tag - 5555;
    if (self.delegate && [self.delegate respondsToSelector:@selector(refundVoucherCell:tapImageView:url:)]) {
        [self.delegate refundVoucherCell:self tapImageView:imageView url:self.studentRefundDetailsModel.appendixList[index]];
    }
}

-(void)setStudentRefundDetailsModel:(HXStudentRefundDetailsModel *)studentRefundDetailsModel{
    _studentRefundDetailsModel = studentRefundDetailsModel;
    [self.refundVoucherContainerView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView *imageView = obj;
        if (idx+1<= studentRefundDetailsModel.appendixList.count) {
            imageView.hidden = NO;
            [imageView sd_setImageWithURL:[NSURL URLWithString:HXSafeString(studentRefundDetailsModel.appendixList[idx])] placeholderImage:nil];
        }else{
            imageView.hidden = YES;
        }
    }];
}


-(void)createUI{
    [self addSubview:self.refundVoucherLabel];
    [self addSubview:self.refundVoucherContainerView];
    
    self.refundVoucherLabel.sd_layout
    .topSpaceToView(self, 16)
    .leftSpaceToView(self, 24)
    .widthIs(76)
    .heightIs(20);
    
    self.refundVoucherContainerView.sd_layout
    .topEqualToView(self.refundVoucherLabel).offset(-2)
    .leftSpaceToView(self.refundVoucherLabel, 5)
    .widthIs(170)
    .heightIs(170);
    CGFloat width = 80;
    CGFloat height = 80;
    NSInteger itemCount = 2;
    for (int i = 0; i<4; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.tag = 5555+i;
        imageView.backgroundColor = COLOR_WITH_ALPHA(0xD8D8D8, 1);
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.userInteractionEnabled = YES;
        imageView.hidden = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
        [imageView addGestureRecognizer:tap];
        [self.refundVoucherContainerView addSubview:imageView];
        imageView.sd_layout
        .topSpaceToView(self.refundVoucherContainerView, (i/itemCount)*(height+5))
        .leftSpaceToView(self.refundVoucherContainerView, (i%itemCount)*(width+5))
        .widthIs(width)
        .heightIs(height);
    }
}


-(UILabel *)refundVoucherLabel{
    if (!_refundVoucherLabel) {
        _refundVoucherLabel = [[UILabel alloc] init];
        _refundVoucherLabel.font = HXFont(14);
        _refundVoucherLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _refundVoucherLabel.textAlignment = NSTextAlignmentLeft;
        _refundVoucherLabel.text = @"退费凭证：";
    }
    return _refundVoucherLabel;
}

-(UIView *)refundVoucherContainerView{
    if (!_refundVoucherContainerView) {
        _refundVoucherContainerView = [[UIView alloc] init];
        _refundVoucherContainerView.backgroundColor = [UIColor clearColor];
    }
    return _refundVoucherContainerView;
}




@end
