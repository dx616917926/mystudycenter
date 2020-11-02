//
//  TXDownloadViewCell.m
//  TXMoviePlayer
//
//  Created by Mac on 2019/10/21.
//  Copyright © 2019 华夏大地教育网. All rights reserved.
//

#import "TXDownloadViewCell.h"

@interface TXDownloadViewCell()

@property(nonatomic, strong) UILabel *contentLabel;         //课件名称
@property(nonatomic, strong) UIImageView *iconView;         //播放图标
@property(nonatomic, strong) UILabel *downloadTypeLabel;    //下载状态

@end

@implementation TXDownloadViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
//        self.backgroundColor = [UIColor clearColor];
//        self.contentView.backgroundColor = [UIColor clearColor];
        
        CGFloat leftPadding = 20;
        
        //播放图标
        self.iconView = [[UIImageView alloc] init];
        [self.iconView setImage:[UIImage imageNamed:@"sp_action_download"]];
        [self.contentView addSubview:self.iconView];
        [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-leftPadding);
            make.centerY.offset(0);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
        
        //下载状态
        self.downloadTypeLabel = [[UILabel alloc] init];
        self.downloadTypeLabel.font = [UIFont systemFontOfSize:14];
        self.downloadTypeLabel.textColor = [UIColor blackColor];
        self.downloadTypeLabel.numberOfLines = 0;
        self.downloadTypeLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.downloadTypeLabel];
        [self.downloadTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-leftPadding);
            make.centerY.mas_equalTo(self.iconView.mas_centerY);
            make.width.mas_greaterThanOrEqualTo(@42);
        }];
        [self.downloadTypeLabel setContentCompressionResistancePriority:UILayoutPriorityRequired
                                                        forAxis:UILayoutConstraintAxisHorizontal];
        [self.downloadTypeLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        
        //课件名称
        self.contentLabel = [[UILabel alloc] init];
        self.contentLabel.numberOfLines = 0;
        self.contentLabel.textColor = [UIColor blackColor];
        self.contentLabel.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:self.contentLabel];
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(leftPadding);
            make.right.mas_equalTo(self.downloadTypeLabel.mas_left).offset(-6);
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
        self.downloadTypeLabel.hidden = NO;
        self.iconView.hidden = NO;
        self.downloadTypeLabel.text = @"";
        self.contentLabel.font = [UIFont systemFontOfSize:16];
    }else
    {
        self.downloadTypeLabel.hidden = YES;
        self.iconView.hidden = YES;
        self.contentLabel.font = [UIFont boldSystemFontOfSize:16];
    }
}

- (void)setIsSelected:(BOOL)selected {
    
    if (selected) {
        self.contentLabel.textColor = [UIColor colorWithRed:0.29 green:0.53 blue:0.95 alpha:1.00];
    }else
    {
        self.contentLabel.textColor = [UIColor blackColor];
    }
}

- (void)setDownloadSourceModel:(DownloadSource *)downloadSourceModel {
    
    if (_downloadSourceModel) {
        [_downloadSourceModel removeObserver:self forKeyPath:@"percent"];
    }
    
    _downloadSourceModel = downloadSourceModel;

    if (_downloadSourceModel) {
        
        self.downloadTypeLabel.hidden = NO;
        self.downloadTypeLabel.textColor = [UIColor blackColor];
        self.iconView.hidden = YES;
        
        switch (_downloadSourceModel.downloadStatus) {
            case DownloadTypeStoped:
                self.downloadTypeLabel.text = @"停止";
                break;
            case DownloadTypeWaiting:
                self.downloadTypeLabel.text = @"等待";
                break;
            case DownloadTypeLoading:
                [self setDownloadTypeWithPercent:self.downloadSourceModel.percent];   //下载中
                break;
            case DownloadTypefinish:
                self.downloadTypeLabel.text = @"已下载";
                self.downloadTypeLabel.textColor = [UIColor colorWithRed:0.29 green:0.53 blue:0.95 alpha:1.00];
                break;
            case DownloadTypePrepared:
                self.downloadTypeLabel.text = @"准备完成";
                break;
            case DownloadTypeFailed:
                self.downloadTypeLabel.text = @"失败";
                break;
            default:
                self.downloadTypeLabel.text = @"未知状态";
                break;
        }
        //添加通知
        [_downloadSourceModel addObserver:self
                               forKeyPath:@"percent"
                                  options:NSKeyValueObservingOptionNew
                                  context:NULL];
    }else
    {
        self.downloadTypeLabel.hidden = YES;
        self.iconView.hidden = !self.catalogModel.isMedia;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([keyPath isEqualToString:@"percent"]) {
            if (self.downloadSourceModel.downloadStatus == DownloadTypeLoading) {
                [self setDownloadTypeWithPercent:self.downloadSourceModel.percent];
            }
        }
    });
}

-(void)dealloc
{
    if (_downloadSourceModel) {
        [_downloadSourceModel removeObserver:self forKeyPath:@"percent"];
    }
}

- (void)setDownloadTypeWithPercent:(int)percent {
    NSString *percentStr = [NSString stringWithFormat:@"%d%%",percent];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:@"下载中\n"];
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, 3)];
    NSMutableAttributedString *attributedStr2 = [[NSMutableAttributedString alloc] initWithString:percentStr];
    [attributedStr2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, percentStr.length)];
    [attributedStr appendAttributedString:attributedStr2];
    self.downloadTypeLabel.attributedText = attributedStr;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
