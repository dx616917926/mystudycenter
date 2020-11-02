/*
 * QRCodeReaderViewController
 *
 * Copyright 2014-present Yannick Loriot.
 * http://yannickloriot.com
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

#import "QRCodeReaderViewController.h"
#import "QRCodeReaderView.h"
#import "UIImage+QRCode.h"

@interface QRCodeReaderViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, strong) HXBarButtonItem      *leftBarItem;
@property (nonatomic, strong) HXBarButtonItem      *rightBarItem;

@property (strong, nonatomic) QRCodeReaderView     *cameraView;
@property (strong, nonatomic) UILabel              *hintLabel;
@property (strong, nonatomic) QRCodeReader         *codeReader;

@property (copy, nonatomic) void (^completionBlock) (NSString *);

@end

@implementation QRCodeReaderViewController

-(void)loadView
{
    [super loadView];
    
    @weakify(self);
    self.leftBarItem = [[HXBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navi_back"] style:HXBarButtonItemStylePlain handler:^(id sender) {
        
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
    
    self.rightBarItem = [[HXBarButtonItem alloc] initWithTitle:@"相册" style:HXBarButtonItemStylePlain handler:^(id sender) {
        
        @strongify(self);
        [self readAction:nil];
    }];
}

- (void)dealloc
{
    [_codeReader stopScanning];
}

- (id)init
{
    return [self initWithHintTitle:nil];
}

- (id)initWithHintTitle:(NSString *)hintTitle
{
    return [self initWithHintTitle:hintTitle metadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
}

- (id)initWithMetadataObjectTypes:(NSArray *)metadataObjectTypes
{
    return [self initWithHintTitle:nil metadataObjectTypes:metadataObjectTypes];
}

- (id)initWithHintTitle:(NSString *)hintTitle metadataObjectTypes:(NSArray *)metadataObjectTypes
{
    QRCodeReader *reader = [QRCodeReader readerWithMetadataObjectTypes:metadataObjectTypes];
    
    return [self initWithHintTitle:hintTitle codeReader:reader];
}

- (id)initWithHintTitle:(NSString *)hintTitle codeReader:(QRCodeReader *)codeReader
{
    if ((self = [super init])) {
        self.view.backgroundColor = [UIColor blackColor];
        self.codeReader           = codeReader;
        
        if (hintTitle == nil) {
            hintTitle = @"";
        }
        
        [self setupUIComponentsWithHintTitle:hintTitle];
        [self setupFrames];
        
        [_cameraView.layer insertSublayer:_codeReader.previewLayer atIndex:0];
        
        __weak typeof(self) weakSelf = self;
        
        [codeReader setCompletionWithBlock:^(NSString *resultAsString) {
            if (weakSelf.completionBlock != nil) {
                weakSelf.completionBlock(resultAsString);
            }
            
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(reader:didScanResult:)]) {
                [weakSelf.delegate reader:weakSelf didScanResult:resultAsString];
            }
        }];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_codeReader startScanning];

    self.sc_navigationBar.leftBarButtonItem = self.leftBarItem;
    self.sc_navigationBar.rightBarButtonItem = self.rightBarItem;
    
    self.sc_navigationBar.title = @"扫一扫";
    
    [self.cameraView beginAnimation];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [_codeReader stopScanning];
    
    [super viewWillDisappear:animated];
}

#pragma mark - Managing the Block

- (void)setCompletionWithBlock:(void (^) (NSString *resultAsString))completionBlock
{
    self.completionBlock = completionBlock;
}

#pragma mark - Initializing the AV Components

- (void)setupUIComponentsWithHintTitle:(NSString *)HintTitle
{
    self.cameraView                                       = [[QRCodeReaderView alloc] init];
    _cameraView.translatesAutoresizingMaskIntoConstraints = NO;
    _cameraView.clipsToBounds                             = YES;
    [self.view addSubview:_cameraView];
    
    [_codeReader.previewLayer setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    if ([_codeReader.previewLayer.connection isVideoOrientationSupported]) {
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        
        _codeReader.previewLayer.connection.videoOrientation = [QRCodeReader videoOrientationFromInterfaceOrientation:orientation];
    }
    
    self.hintLabel = [[UILabel alloc] init];
    self.hintLabel.text = HintTitle;
    self.hintLabel.font = [UIFont systemFontOfSize:15];
    self.hintLabel.textColor = [UIColor whiteColor];
    self.hintLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.hintLabel];
}

- (void)setupFrames
{
    self.cameraView.frame = CGRectMake(0, kNavigationBarHeight, self.view.frame.size.width, self.view.frame.size.height);
    self.hintLabel.frame = CGRectMake(0, self.view.frame.size.width+100, self.view.frame.size.width, 40);
}

- (void)switchDeviceInput
{
    [_codeReader switchDeviceInput];
}

//从相册识别二维码
- (IBAction)readAction:(id)sender {
    
    UIImagePickerController *photoPicker = [[UIImagePickerController alloc] init];
    
    photoPicker.delegate = self;
    photoPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    photoPicker.view.backgroundColor = [UIColor whiteColor];
    [self presentViewController:photoPicker animated:YES completion:NULL];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    UIImage * srcImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    NSString *result = [UIImage readQRCodeFromImage:srcImage];
    
    if (result && ![result isEqualToString:@""])
    {
        if (self.completionBlock != nil) {
            self.completionBlock(result);
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(reader:didScanResult:)]) {
            [self.delegate reader:self didScanResult:result];
        }
    }else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有识别到二维码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - Catching Button Events

- (void)cancelAction:(UIButton *)button
{
    [_codeReader stopScanning];
    
    if (_completionBlock) {
        _completionBlock(nil);
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(readerDidCancel:)]) {
        [_delegate readerDidCancel:self];
    }
}

- (void)switchCameraAction:(UIButton *)button
{
    [self switchDeviceInput];
}

@end
