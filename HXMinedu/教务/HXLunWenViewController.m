//
//  HXLunWenViewController.m
//  HXMinedu
//
//  Created by mac on 2021/12/6.
//

#import "HXLunWenViewController.h"
#import "HXStudentPaperModel.h"
#import <QuickLook/QuickLook.h>

@interface HXLunWenViewController ()<UIDocumentPickerDelegate,QLPreviewControllerDataSource>

@property(nonatomic,strong) HXBarButtonItem *rightBarButtonItem;

@property(nonatomic,strong) UIScrollView *mainScrollView;

@property(nonatomic,strong) UIImageView *leftImageView;
@property(nonatomic,strong) UILabel *typeLabel;
@property(nonatomic,strong) UILabel *schoolLabel;
@property(nonatomic,strong) UILabel *cengCiLabel;
@property(nonatomic,strong) UILabel *majorLabel;

///答辩开始时间
@property(nonatomic,strong) UIView *beginTimeView;
@property(nonatomic,strong) UILabel *beginTitleLabel;
@property(nonatomic,strong) UILabel *beginTimeLabel;
@property(nonatomic,strong) UIView *line1View;
///答辩结束时间
@property(nonatomic,strong) UIView *endTimeView;
@property(nonatomic,strong) UILabel *endTitleLabel;
@property(nonatomic,strong) UILabel *endTimeLabel;
@property(nonatomic,strong) UIView *line2View;
///论文答辩地址
@property(nonatomic,strong) UIView *addressView;
@property(nonatomic,strong) UILabel *addressTitleLabel;
@property(nonatomic,strong) UILabel *addressLabel;
@property(nonatomic,strong) UIView *line3View;
///论文答辩形式
@property(nonatomic,strong) UIView *modeView;
@property(nonatomic,strong) UILabel *modeTitleLabel;
@property(nonatomic,strong) UILabel *modeLabel;
@property(nonatomic,strong) UIView *line4View;
///答辩进度
@property(nonatomic,strong) UIView *progressView;
@property(nonatomic,strong) UILabel *progressTitleLabel;
@property(nonatomic,strong) UILabel *progressLabel;
@property(nonatomic,strong) UIView *line5View;


@property(nonatomic,strong) UIView *bottomShadowView;
@property(nonatomic,strong) UIView *bottomView;
@property(nonatomic,strong) UIButton *daBianBtn;

@property(nonatomic,strong)HXStudentPaperModel *studentPaperModel;

@property (nonatomic, copy) NSString *downLoadUrl;
@property (nonatomic, strong) QLPreviewController *QLController;
@property (nonatomic, copy) NSURL *fileURL;

@end

@implementation HXLunWenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //UI
    [self createUI];
    //获取学生论文详情
    [self getStudentPaperInfo];
    
    self.QLController = [[QLPreviewController alloc] init];
    self.QLController.dataSource = self;
}

#pragma mark - 获取学生论文详情
-(void)getStudentPaperInfo{
    NSDictionary *dic = @{
        @"version_id":HXSafeString(self.selectMajorModel.versionId),
        @"major_id":HXSafeString(self.selectMajorModel.major_id)
    };
    
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_GetStudentPaperInfo withDictionary:dic success:^(NSDictionary * _Nonnull dictionary) {
        
        BOOL success = [dictionary boolValueForKey:@"Success"];
        if (success) {
            self.studentPaperModel = [HXStudentPaperModel mj_objectWithKeyValues:[dictionary objectForKey:@"Data"]];
            [self refeshUI];
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];

}

//上传论文
-(void)uploadingWithFileData:(NSString *)fileData fileName:(NSString *)fileName{
    [self.view showSuccessWithMessage:@"正在上传..."];
    NSDictionary *dic = @{
        @"version_id":HXSafeString(self.selectMajorModel.versionId),
        @"major_id":HXSafeString(self.selectMajorModel.major_id),
        @"file":HXSafeString(fileData),
        @"fileName":HXSafeString(fileName)
    };
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_UploadStudentPaperFile withDictionary:dic success:^(NSDictionary * _Nonnull dictionary) {
        [self.view hideLoading];
        BOOL success = [dictionary boolValueForKey:@"Success"];
        if (success) {
            //获取学生论文详情
            [self getStudentPaperInfo];
            [self.view showSuccessWithMessage:@"上传成功"];
        }else{
            [self.view showErrorWithMessage:[dictionary stringValueForKey:@"Message"]];
        }
    } failure:^(NSError * _Nonnull error) {
        [self.view hideLoading];
    }];
}


///修改答辩状态
-(void)updatedbStatus{
    [self.view showLoading];
    NSDictionary *dic = @{
        @"version_id":HXSafeString(self.selectMajorModel.versionId),
        @"major_id":HXSafeString(self.selectMajorModel.major_id)
    };
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_UpdatedbStatus withDictionary:dic success:^(NSDictionary * _Nonnull dictionary) {
        [self.view hideLoading];
        BOOL success = [dictionary boolValueForKey:@"Success"];
        if (success) {
            self.progressLabel.text = @"已答辩";
            self.bottomShadowView.hidden = self.bottomView.hidden = YES;
        }else{
            [self.view showErrorWithMessage:[dictionary stringValueForKey:@"Message"]];
        }
    } failure:^(NSError * _Nonnull error) {
        [self.view hideLoading];
    }];
}


#pragma Mark - Event
//上传论文
-(void)upLoadLunWen{
    
    NSArray *types = @[@"public.item"];
    UIDocumentPickerViewController *documentPicker = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:types inMode:UIDocumentPickerModeOpen];
    documentPicker.delegate = self;
    documentPicker.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:documentPicker animated:YES completion:nil];
}

#pragma mark - 下载查看论文
-(void)downLoadLunwen{
    NSString *downLoadUrl = [HXCommonUtil stringEncoding:self.studentPaperModel.paperUrl];
    if ([HXCommonUtil isNull:downLoadUrl]){
        [self.view showTostWithMessage:@"资源无效"];
        return;
    }
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    // 1. 创建会话管理者
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    // 2. 创建下载路径和请求对象
    NSURL *URL = [NSURL URLWithString:downLoadUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSString *generateStr = [HXCommonUtil generateTradeNO:5];//生成指定长度的字符串
    NSString *fileName = [generateStr stringByAppendingString:[downLoadUrl lastPathComponent]]; //获取文件名称
    [self.view showLoadingWithMessage:@"正在下载..."];

    //下载文件
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress *downloadProgress){
        
    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        NSURL *url = [documentsDirectoryURL URLByAppendingPathComponent:fileName];
        return url;
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        [self.view hideLoading];
        self.fileURL = filePath;
        [self presentViewController:self.QLController animated:YES completion:nil];
        //刷新界面,如果不刷新的话，不重新走一遍代理方法，返回的url还是上一次的url
        [self.QLController refreshCurrentPreviewItem];
    }];
    [downloadTask resume];
}


#pragma mark - QLPreviewControllerDataSource
/// 文件路径
- (id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index {
    return self.fileURL;
}
/// 文件数
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller {
    return 1;
}

#pragma mark - <UIDocumentPickerDelegate>选择文件回调
- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentsAtURLs:(NSArray<NSURL *> *)urls {
    //获取授权
    BOOL fileUrlAuthozied = [urls.firstObject startAccessingSecurityScopedResource];
    if (fileUrlAuthozied) {
        //通过文件协调工具来得到新的文件地址，以此得到文件保护功能
        NSFileCoordinator *fileCoordinator = [[NSFileCoordinator alloc] init];
        NSError *error;
        [fileCoordinator coordinateReadingItemAtURL:urls.firstObject options:0 error:&error byAccessor:^(NSURL *newURL) {
            //读取文件
            NSString *fileName = [newURL lastPathComponent];
            NSError *error = nil;
            NSData *fileData = [NSData dataWithContentsOfURL:newURL options:NSDataReadingMappedIfSafe error:&error];
            if (error) {
                //读取出错
                [self.view showErrorWithMessage:@"读取出错"];
            } else {
                //上传
                NSLog(@"fileData --- %@",fileData);
                NSString *base64Str = [fileData base64EncodedStringWithOptions:0];
                [self uploadingWithFileData:base64Str fileName:fileName];
            }
            [self dismissViewControllerAnimated:YES completion:NULL];
        }];
        [urls.firstObject stopAccessingSecurityScopedResource];
    } else {
        //授权失败
        [self.view showErrorWithMessage:@"授权失败"];
    }
}


#pragma mark - 刷新UI
-(void)refeshUI{
    //1001成人高考   1002自学考试   1003国家开放大学   1004网络教育   1005职业资格证书   1006全日制学历
    if ([self.studentPaperModel.version_id integerValue] == 1001) {
        self.typeLabel.text = [NSString stringWithFormat:@"成人高考  %@",self.studentPaperModel.enterDate];
    }else if ([self.studentPaperModel.version_id integerValue] == 1002) {
        self.typeLabel.text = [NSString stringWithFormat:@"自学考试  %@",self.studentPaperModel.enterDate];
    }else if ([self.studentPaperModel.version_id integerValue] == 1003) {
        self.typeLabel.text = [NSString stringWithFormat:@"国家开放大学  %@",self.studentPaperModel.enterDate];
    }else if ([self.studentPaperModel.version_id integerValue] == 1004) {
        self.typeLabel.text = [NSString stringWithFormat:@"网络教育  %@",self.studentPaperModel.enterDate];
    }else if ([self.studentPaperModel.version_id integerValue] == 1005) {
        self.typeLabel.text = [NSString stringWithFormat:@"职业资格证书  %@",self.studentPaperModel.enterDate];
    }else if ([self.studentPaperModel.version_id integerValue] == 1006) {
        self.typeLabel.text = [NSString stringWithFormat:@"全日制学历  %@",self.studentPaperModel.enterDate];
    }
    
    self.schoolLabel.text = HXSafeString(self.studentPaperModel.BkSchool);
    self.cengCiLabel.text = HXSafeString(self.studentPaperModel.educationName);
    self.majorLabel.text = HXSafeString(self.studentPaperModel.majorName);
    self.beginTimeLabel.text = HXSafeString(self.studentPaperModel.defenseBDateText);
    self.endTimeLabel.text = HXSafeString(self.studentPaperModel.defenseEDateText);
    self.addressLabel.text =HXSafeString(self.studentPaperModel.defenseAddr);
    self.modeLabel.text = HXSafeString(self.studentPaperModel.defenseType);
    ///等于1 我已答辩 等于0则用时间判断是否开始或结束
    /*未开始：还没有到答辩时间
      进行中：到了答辩时间这一天
      已结束：已经过了答辩时间，但是学生还没点“我已答辩”
      已答辩：学生点了“我已答辩”按钮之后
   */
    if (self.studentPaperModel.defenseStatus == 1) {
        self.progressLabel.text = @"已答辩";
        self.bottomShadowView.hidden = self.bottomView.hidden = YES;
    }else{
        self.bottomShadowView.hidden = self.bottomView.hidden = NO;
        NSString *currentDateStr = [HXCommonUtil getCurrentDateWithFormatterStr:@""];
        if ([HXCommonUtil compareDate:currentDateStr withDate:self.studentPaperModel.defenseBDateText formatterStr:@""]==1) {
            self.progressLabel.text = @"未开始";
            self.bottomShadowView.hidden = self.bottomView.hidden = YES;
        }else if ([HXCommonUtil compareDate:currentDateStr withDate:self.studentPaperModel.defenseBDateText formatterStr:@""]==-1&&[HXCommonUtil compareDate:currentDateStr withDate:self.studentPaperModel.defenseEDateText formatterStr:@""]==1) {
            self.progressLabel.text = @"进行中";
            self.bottomShadowView.hidden = self.bottomView.hidden = NO;
        }else if ([HXCommonUtil compareDate:currentDateStr withDate:self.studentPaperModel.defenseEDateText formatterStr:@""]==-1) {
            self.progressLabel.text = @"已结束";
            self.bottomShadowView.hidden = self.bottomView.hidden = NO;
        }
    }
}

#pragma mark - 布局子视图
-(void)createUI{
    
    self.sc_navigationBar.title = @"我的毕业";
    
    self.rightBarButtonItem = [[HXBarButtonItem alloc] initWithTitle:@"重新上传" style:HXBarButtonItemStylePlain handler:^(id sender) {
        [self upLoadLunWen];
    }];
    
    self.sc_navigationBar.rightBarButtonItem = self.rightBarButtonItem;
    
    
    [self.view addSubview:self.mainScrollView];
    
    [self.mainScrollView addSubview:self.leftImageView];
    [self.mainScrollView addSubview:self.typeLabel];
    [self.mainScrollView addSubview:self.schoolLabel];
    [self.mainScrollView addSubview:self.cengCiLabel];
    [self.mainScrollView addSubview:self.majorLabel];
    
    [self.mainScrollView addSubview:self.beginTimeView];
    [self.beginTimeView addSubview:self.beginTitleLabel];
    [self.beginTimeView addSubview:self.beginTimeLabel];
    [self.beginTimeView addSubview:self.line1View];
    
    [self.mainScrollView addSubview:self.endTimeView];
    [self.endTimeView addSubview:self.endTitleLabel];
    [self.endTimeView addSubview:self.endTimeLabel];
    [self.endTimeView addSubview:self.line2View];
    
    [self.mainScrollView addSubview:self.addressView];
    [self.addressView addSubview:self.addressTitleLabel];
    [self.addressView addSubview:self.addressLabel];
    [self.addressView addSubview:self.line3View];
    
    [self.mainScrollView addSubview:self.modeView];
    [self.modeView addSubview:self.modeTitleLabel];
    [self.modeView addSubview:self.modeLabel];
    [self.modeView addSubview:self.line4View];
    
    [self.mainScrollView addSubview:self.progressView];
    [self.progressView addSubview:self.progressTitleLabel];
    [self.progressView addSubview:self.progressLabel];
    [self.progressView addSubview:self.line5View];
    
    ///我已答辩
    [self.view addSubview:self.bottomShadowView];
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.daBianBtn];
    
    self.mainScrollView.sd_layout
        .topSpaceToView(self.view, kNavigationBarHeight)
        .leftEqualToView(self.view)
        .rightEqualToView(self.view)
        .bottomEqualToView(self.view);
    
    self.leftImageView.sd_layout
        .topSpaceToView(self.mainScrollView, 20)
        .leftSpaceToView(self.mainScrollView, 20)
        .widthIs(125)
        .heightIs(167);
    
    self.typeLabel.sd_layout
        .topSpaceToView(self.mainScrollView, 40)
        .leftSpaceToView(self.leftImageView, 28)
        .rightSpaceToView(self.mainScrollView, 20)
        .heightIs(25);
    
    self.schoolLabel.sd_layout
        .topSpaceToView(self.typeLabel, 10)
        .leftEqualToView(self.typeLabel)
        .rightEqualToView(self.typeLabel)
        .heightRatioToView(self.typeLabel, 1);
    
    self.cengCiLabel.sd_layout
        .topSpaceToView(self.schoolLabel, 10)
        .leftEqualToView(self.typeLabel)
        .rightEqualToView(self.typeLabel)
        .heightRatioToView(self.typeLabel, 0.9);
    
    self.majorLabel.sd_layout
        .topSpaceToView(self.cengCiLabel, 10)
        .leftEqualToView(self.typeLabel)
        .rightEqualToView(self.typeLabel)
        .heightRatioToView(self.typeLabel, 0.9);
    
    //答辩开始时间
    self.beginTimeView.sd_layout
        .topSpaceToView(self.leftImageView, 10)
        .leftSpaceToView(self.mainScrollView, 20)
        .rightSpaceToView(self.mainScrollView, 20)
        .heightIs(62);
    
    self.beginTitleLabel.sd_layout
        .leftEqualToView(self.beginTimeView)
        .centerYEqualToView(self.beginTimeView)
        .heightIs(20)
        .widthIs(100);
    
    self.beginTimeLabel.sd_layout
        .leftSpaceToView(self.beginTitleLabel, 20)
        .rightEqualToView(self.beginTimeView)
        .centerYEqualToView(self.beginTimeView)
        .heightIs(22);
    
    self.line1View.sd_layout
        .leftEqualToView(self.beginTimeView)
        .rightEqualToView(self.beginTimeView)
        .bottomEqualToView(self.beginTimeView)
        .heightIs(1);
    
    //答辩结束时间
    self.endTimeView.sd_layout
        .topSpaceToView(self.beginTimeView, 0)
        .leftEqualToView(self.beginTimeView)
        .rightEqualToView(self.beginTimeView)
        .heightRatioToView(self.beginTimeView, 1);
    
    self.endTitleLabel.sd_layout
        .leftEqualToView(self.endTimeView)
        .centerYEqualToView(self.endTimeView)
        .heightRatioToView(self.beginTitleLabel, 1)
        .widthRatioToView(self.beginTitleLabel, 1);
    
    self.endTimeLabel.sd_layout
        .leftSpaceToView(self.endTitleLabel, 20)
        .rightEqualToView(self.endTimeView)
        .centerYEqualToView(self.endTimeView)
        .heightRatioToView(self.beginTimeLabel, 1);
    
    self.line2View.sd_layout
        .leftEqualToView(self.endTimeView)
        .rightEqualToView(self.endTimeView)
        .bottomEqualToView(self.endTimeView)
        .heightRatioToView(self.line1View, 1);
    
    
    //论文答辩地址
    self.addressView.sd_layout
        .topSpaceToView(self.endTimeView, 0)
        .leftEqualToView(self.beginTimeView)
        .rightEqualToView(self.beginTimeView)
        .heightRatioToView(self.beginTimeView, 1);
    
    self.addressTitleLabel.sd_layout
        .leftEqualToView(self.addressView)
        .centerYEqualToView(self.addressView)
        .heightRatioToView(self.beginTitleLabel, 1)
        .widthRatioToView(self.beginTitleLabel, 1);
    
    self.addressLabel.sd_layout
        .leftSpaceToView(self.addressTitleLabel, 20)
        .rightEqualToView(self.addressView)
        .centerYEqualToView(self.addressView)
        .heightRatioToView(self.beginTimeLabel, 1);
    
    self.line3View.sd_layout
        .leftEqualToView(self.addressView)
        .rightEqualToView(self.addressView)
        .bottomEqualToView(self.addressView)
        .heightRatioToView(self.line1View, 1);
    
    //论文答辩形式
    self.modeView.sd_layout
        .topSpaceToView(self.addressView, 0)
        .leftEqualToView(self.beginTimeView)
        .rightEqualToView(self.beginTimeView)
        .heightRatioToView(self.beginTimeView, 1);
    
    self.modeTitleLabel.sd_layout
        .leftEqualToView(self.modeView)
        .centerYEqualToView(self.modeView)
        .heightRatioToView(self.beginTitleLabel, 1)
        .widthRatioToView(self.beginTitleLabel, 1);
    
    self.modeLabel.sd_layout
        .leftSpaceToView(self.modeTitleLabel, 20)
        .rightEqualToView(self.modeView)
        .centerYEqualToView(self.modeView)
        .heightRatioToView(self.beginTimeLabel, 1);
    
    self.line4View.sd_layout
        .leftEqualToView(self.modeView)
        .rightEqualToView(self.modeView)
        .bottomEqualToView(self.modeView)
        .heightRatioToView(self.line1View, 1);
    
    //答辩进度
    self.progressView.sd_layout
        .topSpaceToView(self.modeView, 0)
        .leftEqualToView(self.beginTimeView)
        .rightEqualToView(self.beginTimeView)
        .heightRatioToView(self.beginTimeView, 1);
    
    self.progressTitleLabel.sd_layout
        .leftEqualToView(self.progressView)
        .centerYEqualToView(self.progressView)
        .heightRatioToView(self.beginTitleLabel, 1)
        .widthRatioToView(self.beginTitleLabel, 1);
    
    self.progressLabel.sd_layout
        .leftSpaceToView(self.progressTitleLabel, 20)
        .rightEqualToView(self.progressView)
        .centerYEqualToView(self.progressView)
        .heightRatioToView(self.beginTimeLabel, 1);
    
    self.line5View.sd_layout
        .leftEqualToView(self.progressView)
        .rightEqualToView(self.progressView)
        .bottomEqualToView(self.progressView)
        .heightRatioToView(self.line1View, 1);
    
    [self.mainScrollView setupAutoContentSizeWithBottomView:self.progressView bottomMargin:150];
    
    
    
    ///我已答辩
    self.bottomShadowView.sd_layout
        .leftEqualToView(self.view)
        .rightEqualToView(self.view)
        .bottomEqualToView(self.view)
        .heightIs(132);
    
    self.bottomView.sd_layout
        .leftEqualToView(self.bottomShadowView)
        .rightEqualToView(self.bottomShadowView)
        .topEqualToView(self.bottomShadowView)
        .bottomEqualToView(self.bottomShadowView);
    
    [self.bottomView updateLayout];
    UIBezierPath * bPath = [UIBezierPath bezierPathWithRoundedRect:self.bottomView.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(22, 22)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.path = bPath.CGPath;
    self.bottomView.layer.mask = maskLayer;
    
    
    self.daBianBtn.sd_layout
        .topSpaceToView(self.bottomView, 30)
        .centerXEqualToView(self.bottomView)
        .widthIs(_kpw(335))
        .heightIs(48);
    self.daBianBtn.sd_cornerRadiusFromHeightRatio = @0.5;
    [self.daBianBtn updateLayout];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.bounds = self.daBianBtn.bounds;
    gradientLayer.startPoint = CGPointMake(0, 0.5);
    gradientLayer.endPoint = CGPointMake(1, 0.5);
    gradientLayer.anchorPoint = CGPointMake(0, 0);
    NSArray *colorArr = @[(id)COLOR_WITH_ALPHA(0x3EADFF, 1).CGColor,(id)COLOR_WITH_ALPHA(0x15E88D, 1).CGColor];
    gradientLayer.colors = colorArr;
    [self.daBianBtn.layer insertSublayer:gradientLayer below:self.daBianBtn.titleLabel.layer];
    
    
}

#pragma mark - LazyLoad



-(UIScrollView *)mainScrollView{
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc] init];
    }
    return _mainScrollView;
}

-(UIImageView *)leftImageView{
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] init];
        _leftImageView.contentMode = UIViewContentModeScaleAspectFit;
        _leftImageView.userInteractionEnabled = YES;
        _leftImageView.image = [UIImage imageNamed:@"word_icon"];
        _leftImageView.clipsToBounds = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(downLoadLunwen)];
        [_leftImageView addGestureRecognizer:tap];
    }
    return _leftImageView;
}

- (UILabel *)typeLabel{
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc] init];
        _typeLabel.textColor = COLOR_WITH_ALPHA(0x5699FF, 1);
        _typeLabel.font = HXBoldFont(18);
        
    }
    return _typeLabel;
}

- (UILabel *)schoolLabel{
    if (!_schoolLabel) {
        _schoolLabel = [[UILabel alloc] init];
        _schoolLabel.textColor = COLOR_WITH_ALPHA(0x5D5D63, 1);
        _schoolLabel.font = HXBoldFont(18);
       
    }
    return _schoolLabel;
}

- (UILabel *)cengCiLabel{
    if (!_cengCiLabel) {
        _cengCiLabel = [[UILabel alloc] init];
        _cengCiLabel.textColor = COLOR_WITH_ALPHA(0x5D5D63, 1);
        _cengCiLabel.font = HXFont(16);
       
    }
    return _cengCiLabel;
}

- (UILabel *)majorLabel{
    if (!_majorLabel) {
        _majorLabel = [[UILabel alloc] init];
        _majorLabel.textColor = COLOR_WITH_ALPHA(0x5D5D63, 1);
        _majorLabel.font = HXFont(16);
        
    }
    return _majorLabel;
}


-(UIView *)beginTimeView{
    if (!_beginTimeView) {
        _beginTimeView = [[UIView alloc] init];
    }
    return _beginTimeView;
}

-(UILabel *)beginTitleLabel{
    if (!_beginTitleLabel) {
        _beginTitleLabel = [[UILabel alloc] init];
        _beginTitleLabel.textColor = COLOR_WITH_ALPHA(0x5D5D63, 1);
        _beginTitleLabel.font = HXFont(14);
        _beginTitleLabel.text = @"答辩开始时间";
    }
    return _beginTitleLabel;
}

-(UILabel *)beginTimeLabel{
    if (!_beginTimeLabel) {
        _beginTimeLabel = [[UILabel alloc] init];
        _beginTimeLabel.textAlignment = NSTextAlignmentRight;
        _beginTimeLabel.textColor = COLOR_WITH_ALPHA(0x5D5D63, 1);
        _beginTimeLabel.font = HXFont(16);
       
    }
    return _beginTimeLabel;
}

-(UIView *)line1View{
    if (!_line1View) {
        _line1View = [[UIView alloc] init];
        _line1View.backgroundColor = COLOR_WITH_ALPHA(0xEFEFEF, 1);
    }
    return _line1View;
}


-(UIView *)endTimeView{
    if (!_endTimeView) {
        _endTimeView = [[UIView alloc] init];
    }
    return _endTimeView;
}

-(UILabel *)endTitleLabel{
    if (!_endTitleLabel) {
        _endTitleLabel = [[UILabel alloc] init];
        _endTitleLabel.textColor = COLOR_WITH_ALPHA(0x5D5D63, 1);
        _endTitleLabel.font = HXFont(14);
        _endTitleLabel.text = @"答辩结束时间";
    }
    return _endTitleLabel;
}

-(UILabel *)endTimeLabel{
    if (!_endTimeLabel) {
        _endTimeLabel = [[UILabel alloc] init];
        _endTimeLabel.textAlignment = NSTextAlignmentRight;
        _endTimeLabel.textColor = COLOR_WITH_ALPHA(0x5D5D63, 1);
        _endTimeLabel.font = HXFont(16);
        
    }
    return _endTimeLabel;
}

-(UIView *)line2View{
    if (!_line2View) {
        _line2View = [[UIView alloc] init];
        _line2View.backgroundColor = COLOR_WITH_ALPHA(0xEFEFEF, 1);
    }
    return _line2View;
}


-(UIView *)addressView{
    if (!_addressView) {
        _addressView = [[UIView alloc] init];
    }
    return _addressView;
}

-(UILabel *)addressTitleLabel{
    if (!_addressTitleLabel) {
        _addressTitleLabel = [[UILabel alloc] init];
        _addressTitleLabel.textColor = COLOR_WITH_ALPHA(0x5D5D63, 1);
        _addressTitleLabel.font = HXFont(14);
        _addressTitleLabel.text = @"论文答辩地址";
    }
    return _addressTitleLabel;
}

-(UILabel *)addressLabel{
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.textAlignment = NSTextAlignmentRight;
        _addressLabel.textColor = COLOR_WITH_ALPHA(0x5D5D63, 1);
        _addressLabel.font = HXFont(16);
        
    }
    return _addressLabel;
}

-(UIView *)line3View{
    if (!_line3View) {
        _line3View = [[UIView alloc] init];
        _line3View.backgroundColor = COLOR_WITH_ALPHA(0xEFEFEF, 1);
    }
    return _line3View;
}

-(UIView *)modeView{
    if (!_modeView) {
        _modeView = [[UIView alloc] init];
    }
    return _modeView;
}

-(UILabel *)modeTitleLabel{
    if (!_modeTitleLabel) {
        _modeTitleLabel = [[UILabel alloc] init];
        _modeTitleLabel.textColor = COLOR_WITH_ALPHA(0x5D5D63, 1);
        _modeTitleLabel.font = HXFont(14);
        _modeTitleLabel.text = @"论文答辩形式";
    }
    return _modeTitleLabel;
}

-(UILabel *)modeLabel{
    if (!_modeLabel) {
        _modeLabel = [[UILabel alloc] init];
        _modeLabel.textAlignment = NSTextAlignmentRight;
        _modeLabel.textColor = COLOR_WITH_ALPHA(0x5D5D63, 1);
        _modeLabel.font = HXFont(16);
        
    }
    return _modeLabel;
}

-(UIView *)line4View{
    if (!_line4View) {
        _line4View = [[UIView alloc] init];
        _line4View.backgroundColor = COLOR_WITH_ALPHA(0xEFEFEF, 1);
    }
    return _line4View;
}

-(UIView *)progressView{
    if (!_progressView) {
        _progressView = [[UIView alloc] init];
    }
    return _progressView;
}

-(UILabel *)progressTitleLabel{
    if (!_progressTitleLabel) {
        _progressTitleLabel = [[UILabel alloc] init];
        _progressTitleLabel.textColor = COLOR_WITH_ALPHA(0x5D5D63, 1);
        _progressTitleLabel.font = HXFont(14);
        _progressTitleLabel.text = @"答辩进度";
    }
    return _progressTitleLabel;
}

-(UILabel *)progressLabel{
    if (!_progressLabel) {
        _progressLabel = [[UILabel alloc] init];
        _progressLabel.textAlignment = NSTextAlignmentRight;
        _progressLabel.textColor = COLOR_WITH_ALPHA(0xFFC02C, 1);
        _progressLabel.font = HXFont(16);
        
    }
    return _progressLabel;
}

-(UIView *)line5View{
    if (!_line5View) {
        _line5View = [[UIView alloc] init];
        _line5View.backgroundColor = COLOR_WITH_ALPHA(0xEFEFEF, 1);
    }
    return _line5View;
}


-(UIView *)bottomShadowView{
    if (!_bottomShadowView) {
        _bottomShadowView = [[UIView alloc] init];
        _bottomShadowView.backgroundColor = [UIColor whiteColor];
        _bottomShadowView.layer.shadowColor = COLOR_WITH_ALPHA(0x000000, 0.15).CGColor;
        _bottomShadowView.layer.shadowOffset = CGSizeMake(0, -2);
        _bottomShadowView.layer.shadowRadius = 6;
        _bottomShadowView.layer.shadowOpacity = 1;
        _bottomShadowView.layer.cornerRadius = 22;
        
    }
    return _bottomShadowView;
}

-(UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor whiteColor];
        _bottomView.clipsToBounds = YES;
    }
    return _bottomView;
}




-(UIButton *)daBianBtn{
    if (!_daBianBtn) {
        _daBianBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _daBianBtn.titleLabel.font = HXFont(15);
        [_daBianBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_daBianBtn setTitle:@"我已答辩" forState:UIControlStateNormal];
        [_daBianBtn addTarget:self action:@selector(updatedbStatus) forControlEvents:UIControlEventTouchUpInside];
    }
    return _daBianBtn;
}


@end
