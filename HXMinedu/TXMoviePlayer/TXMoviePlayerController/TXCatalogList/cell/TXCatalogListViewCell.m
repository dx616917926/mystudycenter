//
//  TXCatalogListViewCell.m
//  TXMoviePlayer
//
//  Created by Mac on 2019/5/24.
//  Copyright © 2019 华夏大地教育网. All rights reserved.
//

#import "TXCatalogListViewCell.h"

@interface TXCatalogListViewCell()

@property(nonatomic, strong) UILabel *contentLabel;     //课件名称
@property(nonatomic, strong) UILabel *timeLabel;        //课件时长
@property(nonatomic, strong) UIImageView *iconView;     //播放图标

@end

@implementation TXCatalogListViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
//        self.backgroundColor = [UIColor clearColor];
//        self.contentView.backgroundColor = [UIColor clearColor];
        
        CGFloat leftPadding = 20;
        
        //播放图标
        self.iconView = [[UIImageView alloc] init];
        [self.iconView setImage:[UIImage imageNamed:@"sp_list_play_icon_n"]];
        [self.contentView addSubview:self.iconView];
        [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-leftPadding);
            make.centerY.offset(0);
            make.size.mas_equalTo(CGSizeMake(28, 28));
        }];
        
        //课件时长
        self.timeLabel = [[UILabel alloc] init];
        self.timeLabel.font = [UIFont systemFontOfSize:14];
        self.timeLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.timeLabel];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.iconView.mas_left).offset(-6);
            make.centerY.mas_equalTo(self.iconView.mas_centerY);
        }];
        [self.timeLabel setContentCompressionResistancePriority:UILayoutPriorityRequired
                                                        forAxis:UILayoutConstraintAxisHorizontal];
        [self.timeLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        
        //课件名称
        self.contentLabel = [[UILabel alloc] init];
        self.contentLabel.numberOfLines = 0;
        self.contentLabel.textColor = [UIColor blackColor];
        self.contentLabel.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:self.contentLabel];
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(leftPadding);
            make.right.mas_equalTo(self.timeLabel.mas_left).offset(-6);
            make.top.offset(10);
            make.bottom.offset(-10);
        }];
    }
    return self;
}

- (void)setCatalogModel:(TXCatalog *)catalogModel {
    
    _catalogModel = catalogModel;
    self.contentLabel.text = catalogModel.name;
    
    if (catalogModel.isMedia) {
        self.timeLabel.hidden = NO;
        self.iconView.hidden = NO;
        self.timeLabel.text = [self timeFormat:catalogModel.mediaDuration];
        self.contentLabel.font = [UIFont systemFontOfSize:16];
    }else
    {
        self.timeLabel.hidden = YES;
        self.iconView.hidden = YES;
        self.contentLabel.font = [UIFont boldSystemFontOfSize:16];
    }
}

- (NSString *)timeFormat:(NSInteger)totalTime {
    if (totalTime < 0) {
        return @"";
    }
    NSInteger durHour = totalTime / 3600;
    NSInteger durMin = (totalTime / 60) % 60;
    NSInteger durSec = totalTime % 60;
    
    if (durHour > 0) {
        return [NSString stringWithFormat:@"%zd:%02zd:%02zd", durHour, durMin, durSec];
    } else {
        return [NSString stringWithFormat:@"%02zd:%02zd", durMin, durSec];
    }
}

- (void)setIsSelected:(BOOL)selected {
    
    if (selected) {
        [self.iconView setImage:[UIImage imageNamed:@"sp_list_play_icon_s"]];
        self.timeLabel.textColor = [UIColor colorWithRed:0.29 green:0.53 blue:0.95 alpha:1.00];
        self.contentLabel.textColor = [UIColor colorWithRed:0.29 green:0.53 blue:0.95 alpha:1.00];
    }else
    {
        [self.iconView setImage:[UIImage imageNamed:@"sp_list_play_icon_n"]];
        self.timeLabel.textColor = [UIColor blackColor];
        self.contentLabel.textColor = [UIColor blackColor];
    }
}

- (void)setIsDownload:(BOOL)isDownload {
    
    if (isDownload) {
        [self.iconView setImage:[UIImage imageNamed:@"sp_list_play_download_icon"]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
