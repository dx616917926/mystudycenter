//
//  HXHomeViewCell.m
//  HXMinedu
//
//  Created by Mac on 2020/11/9.
//

#import "HXHomeViewCell.h"

@implementation HXHomeViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFrame:(CGRect)frame {
    CGRect f = frame;
    f.origin.x = 12;
    f.size.width = frame.size.width - 24;
    [super setFrame:f];
}

- (void)drawRect:(CGRect)rect {
    
    BOOL addLine = NO;
    // 获取cell的size
    CGRect bounds = CGRectInset(self.bounds, 0, 0);
    
    // 添加分隔线图层
    CALayer *lineLayer = [[CALayer alloc] init];
    CGFloat lineHeight = (2.f / [UIScreen mainScreen].scale);
    lineLayer.frame = CGRectMake(CGRectGetMinX(bounds)+10, bounds.size.height-lineHeight, bounds.size.width-20, lineHeight);
    lineLayer.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1].CGColor;
    
    // view大小与cell一致
    UIImageView *roundView = [[UIImageView alloc] initWithFrame:bounds];
    UIImageView *selectedBackgroundView = [[UIImageView alloc] initWithFrame:bounds];
    
    if (self.indexPath.row == 0 && [self.tableView numberOfRowsInSection:self.indexPath.section] == 1) {
        [roundView setImage:[UIImage imageNamed:@"set_cell_all"]];
        [selectedBackgroundView setImage:[UIImage imageNamed:@"set_cell_all_h"]];
    } else if (self.indexPath.row == 0) {
        [roundView setImage:[UIImage imageNamed:@"set_cell_top"]];
        [selectedBackgroundView setImage:[UIImage imageNamed:@"set_cell_top_h"]];
        addLine = YES;
    } else if (self.indexPath.row == [self.tableView numberOfRowsInSection:self.indexPath.section]-1) {
        [roundView setImage:[UIImage imageNamed:@"set_cell_bottom"]];
        [selectedBackgroundView setImage:[UIImage imageNamed:@"set_cell_bottom_h"]];
    } else {
        addLine = YES;
        [roundView setImage:[UIImage imageNamed:@"set_cell_m"]];
        [selectedBackgroundView setImage:[UIImage imageNamed:@"set_cell_m_h"]];
    }
    
    // 添加自定义圆角后的图层到roundView中
    if (addLine == YES) {
        [roundView.layer insertSublayer:lineLayer atIndex:0];
    }
    //cell的背景view
    roundView.backgroundColor = UIColor.clearColor;
    self.backgroundView = roundView;
    
    //点击效果
    selectedBackgroundView.backgroundColor = UIColor.clearColor;
    self.selectedBackgroundView = selectedBackgroundView;
}

@end
