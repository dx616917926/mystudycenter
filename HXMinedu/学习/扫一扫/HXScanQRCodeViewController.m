//
//  HXScanQRCodeViewController.m
//  HXMinedu
//
//  Created by mac on 2021/10/19.
//

#import "HXScanQRCodeViewController.h"
#import "HXCommonWebViewController.h"
#import "SGQRCode.h"
#import "NSString+Base64.h"

@interface HXScanQRCodeViewController () {
    SGScanCode *scanCode;
}
@property (nonatomic, strong) SGScanView *scanView;
@property (nonatomic, strong) UILabel *promptLabel;
@property (nonatomic, assign) BOOL isSelectedFlashlightBtn;
@property (nonatomic, assign) BOOL stop;


@end

@implementation HXScanQRCodeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_stop) {
        [scanCode startRunningWithBefore:nil completion:nil];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor blackColor];
    
    scanCode = [SGScanCode scanCode];
    
    //扫一扫设置
    [self setupQRCodeScan];
    //UI
    [self creaetUI];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.scanView startScanning];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.scanView stopScanning];
    [scanCode stopRunning];
}

- (void)dealloc {
    [self removeScanningView];
}

#pragma mark - 扫一扫设置
- (void)setupQRCodeScan {
    BOOL isCameraDeviceRearAvailable = scanCode.isCameraDeviceRearAvailable;
    if (isCameraDeviceRearAvailable == NO) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    //扫码结果回调
    [scanCode scanWithController:self resultBlock:^(SGScanCode *scanCode, NSString *result) {
        if (result) {
            [scanCode stopRunning];
            weakSelf.stop = YES;
            [scanCode playSoundName:@"SGQRCode.bundle/scanEndSound.caf"];
            if (result == nil) {
                [self.view showTostWithMessage:@"暂未识别出二维码"];
            } else {
                //解密
                NSString*base64DecodedString = [result base64DecodedString];
                NSData *jsonData = [base64DecodedString dataUsingEncoding:NSUTF8StringEncoding];
                NSError *error = nil;
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
                [self.navigationController popViewControllerAnimated:NO];
                if (self.scanResultBlock) {
                    self.scanResultBlock(dic);
                }
            }
        }
    }];
    [scanCode startRunningWithBefore:^{
        [self.view showTostWithMessage:@"正在加载..." ];
    } completion:^{
        [self.view hideLoading];
    }];
    
    
}

#pragma mark - UI
- (void)creaetUI{
    self.sc_navigationBar.title = @"扫一扫";
    WeakSelf(weakSelf);
    self.sc_navigationBar.rightBarButtonItem  = [[HXBarButtonItem alloc] initWithTitle:@"相册" style:HXBarButtonItemStyleCustom handler:^(id sender) {
        StrongSelf(strongSelf)
        [strongSelf rightBarButtonItenAction];
    }];
    
    [self.view addSubview:self.scanView];
    [self.view addSubview:self.promptLabel];

}

#pragma mark - 相册
- (void)rightBarButtonItenAction {
    WeakSelf(weakSelf);
    [scanCode readWithResultBlock:^(SGScanCode *scanCode, NSString *result) {
        if (result == nil) {
            [self.view showTostWithMessage:@"暂未识别出二维码"];
        } else {
            //解密
            NSString*base64DecodedString = [result base64DecodedString];
            NSData *jsonData = [base64DecodedString dataUsingEncoding:NSUTF8StringEncoding];
            NSError *error = nil;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
            [self.navigationController popViewControllerAnimated:NO];
            if (self.scanResultBlock) {
                self.scanResultBlock(dic);
            }
        }
    }];
}

#pragma mark - 移除扫描视图
- (void)removeScanningView {
    [self.scanView stopScanning];
    [self.scanView removeFromSuperview];
    self.scanView = nil;
}

#pragma mark - LazyLoad
- (SGScanView *)scanView {
    if (!_scanView) {
        _scanView = [[SGScanView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        _scanView.scanLineName = @"scanLine";
        _scanView.scanStyle = ScanStyleDefault;
        _scanView.cornerLocation = CornerLoactionOutside;
        _scanView.cornerColor = [UIColor orangeColor];
    }
    return _scanView;
}


- (UILabel *)promptLabel {
    if (!_promptLabel) {
        _promptLabel = [[UILabel alloc] init];
        _promptLabel.backgroundColor = [UIColor clearColor];
        CGFloat promptLabelX = 0;
        CGFloat promptLabelY = 0.73 * self.view.frame.size.height;
        CGFloat promptLabelW = self.view.frame.size.width;
        CGFloat promptLabelH = 25;
        _promptLabel.frame = CGRectMake(promptLabelX, promptLabelY, promptLabelW, promptLabelH);
        _promptLabel.textAlignment = NSTextAlignmentCenter;
        _promptLabel.font = [UIFont boldSystemFontOfSize:13.0];
        _promptLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
        _promptLabel.text = @"将二维码放入框内, 即可自动扫描";
    }
    return _promptLabel;
}


@end

