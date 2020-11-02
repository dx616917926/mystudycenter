//
//  TestColorViewController.m
//  RSColorPicker
//
//  Created by Ryan Sullivan on 7/14/13.
//

#import "TestColorViewController.h"
#import "RSBrightnessSlider.h"
#import "RSOpacitySlider.h"

@implementation TestColorViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view setBackgroundColor:[UIColor colorWithWhite:0.906 alpha:1.000]];
    
    CGFloat marginX;
    
    CGRect pickerViewFrame;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.view.frame = CGRectMake(0, 0, 320, 460);
        marginX = 20;
        pickerViewFrame = CGRectMake(marginX, 10.0, 280.0, 280.0);
        
    }else
    {
        self.view.frame = CGRectMake(0, 0, 250, 330);
        marginX = 5.0;
        pickerViewFrame = CGRectMake(marginX, 5.0, 240.0, 240.0);
    }

    // View that displays color picker (needs to be square)
    _colorPicker = [[RSColorPickerView alloc] initWithFrame:pickerViewFrame];

    // Optionally set and force the picker to only draw a circle
	[_colorPicker setCropToCircle:YES]; // Defaults to NO (you can set BG color)

    // Set the selection color - useful to present when the user had picked a color previously
    
    //RSRandomColorOpaque(YES);
    if (_defaultColor) {
        [_colorPicker setSelectionColor:_defaultColor];
    }

	//    [_colorPicker setSelectionColor:[UIColor colorWithRed:1 green:0 blue:0.752941 alpha:1.000000]];
	//    [_colorPicker setSelection:CGPointMake(269, 269)];

    // Set the delegate to receive events
    [_colorPicker setDelegate:self];

    [self.view addSubview:_colorPicker];
    
    // View that controls brightness
    _brightnessSlider = [[RSBrightnessSlider alloc] initWithFrame:CGRectMake(marginX, CGRectGetMaxY(_colorPicker.frame)+10, self.view.frame.size.width - 2*marginX , 30.0)];
    [_brightnessSlider setColorPicker:_colorPicker];
    [self.view addSubview:_brightnessSlider];

    // View that controls opacity
    _opacitySlider = [[RSOpacitySlider alloc] initWithFrame:CGRectMake(marginX, CGRectGetMaxY(_brightnessSlider.frame)+10, self.view.frame.size.width - 2*marginX, 30.0)];
    [_opacitySlider setColorPicker:_colorPicker];
    [self.view addSubview:_opacitySlider];

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        return;
    }
    
    //
    CGFloat frame_y = CGRectGetMaxY(_opacitySlider.frame)+10;
    CGFloat margin = 11.66;
    // Buttons for testing
    UIButton *selectRed = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    selectRed.frame = CGRectMake(marginX, frame_y, 30.0, 30.0);
    [selectRed setBackgroundColor:[UIColor redColor]];
    [selectRed addTarget:self action:@selector(selectRed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:selectRed];

    UIButton *selectGreen = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    selectGreen.frame = CGRectMake(CGRectGetMaxX(selectRed.frame) + margin, frame_y, 30.0, 30.0);
    [selectGreen setBackgroundColor:[UIColor greenColor]];
    [selectGreen addTarget:self action:@selector(selectGreen:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:selectGreen];

    UIButton *selectBlue = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    selectBlue.frame = CGRectMake(CGRectGetMaxX(selectGreen.frame) + margin, frame_y, 30.0, 30.0);
    [selectBlue setBackgroundColor:[UIColor blueColor]];
    [selectBlue addTarget:self action:@selector(selectBlue:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:selectBlue];

    UIButton *selectBlack = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    selectBlack.frame = CGRectMake(CGRectGetMaxX(selectBlue.frame) + margin, frame_y, 30.0, 30.0);
    [selectBlack setBackgroundColor:[UIColor blackColor]];
    [selectBlack addTarget:self action:@selector(selectBlack:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:selectBlack];

    UIButton *selectWhite = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    selectWhite.frame = CGRectMake(CGRectGetMaxX(selectBlack.frame) + margin, frame_y, 30.0, 30.0);
    [selectWhite setBackgroundColor:[UIColor whiteColor]];
    [selectWhite addTarget:self action:@selector(selectWhite:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:selectWhite];

    UIButton *selectPurple = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    selectPurple.frame = CGRectMake(CGRectGetMaxX(selectWhite.frame) + margin, frame_y, 30.0, 30.0);
    [selectPurple setBackgroundColor:[UIColor purpleColor]];
    [selectPurple addTarget:self action:@selector(selectPurple:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:selectPurple];

    UIButton *selectCyan = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    selectCyan.frame = CGRectMake(CGRectGetMaxX(selectPurple.frame) + margin, frame_y, 30.0, 30.0);
    [selectCyan setBackgroundColor:[UIColor cyanColor]];
    [selectCyan addTarget:self action:@selector(selectCyan:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:selectCyan];
    
    
    // View that shows selected color
    _colorPatch = [[UIView alloc] initWithFrame:CGRectMake(marginX, CGRectGetMaxY(selectCyan.frame)+10, 280, 30.0)];
    [self.view addSubview:_colorPatch];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(colorViewWillDismiss:)]) {
        
        [self.delegate colorViewWillDismiss:self.colorPatch.backgroundColor];
    }
}

#pragma mark - RSColorPickerView delegate methods

- (void)colorPickerDidChangeSelection:(RSColorPickerView *)cp {

    // Get color data
    UIColor *color = [cp selectionColor];

    CGFloat r, g, b, a;
    [[cp selectionColor] getRed:&r green:&g blue:&b alpha:&a];

    // Update important UI
    _colorPatch.backgroundColor = color;
    _brightnessSlider.value = [cp brightness];
    _opacitySlider.value = [cp opacity];


    // Debug
    NSString *colorDesc = [NSString stringWithFormat:@"rgba: %f, %f, %f, %f", r, g, b, a];
    NSLog(@"%@", colorDesc);
    int ir = r * 255;
    int ig = g * 255;
    int ib = b * 255;
    int ia = a * 255;
    colorDesc = [NSString stringWithFormat:@"rgba: %d, %d, %d, %d", ir, ig, ib, ia];
    NSLog(@"%@", colorDesc);

    NSLog(@"%@", NSStringFromCGPoint(cp.selection));
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(colorViewDidSelectColor:)]) {
        [self.delegate colorViewDidSelectColor:color];
    }
}

#pragma mark - User action

- (void)selectRed:(id)sender {
    [_colorPicker setSelectionColor:[UIColor redColor]];
}
- (void)selectGreen:(id)sender {
    [_colorPicker setSelectionColor:[UIColor greenColor]];
}
- (void)selectBlue:(id)sender {
    [_colorPicker setSelectionColor:[UIColor blueColor]];
}
- (void)selectBlack:(id)sender {
    [_colorPicker setSelectionColor:[UIColor blackColor]];
}
- (void)selectWhite:(id)sender {
    [_colorPicker setSelectionColor:[UIColor whiteColor]];
}
- (void)selectPurple:(id)sender {
    [_colorPicker setSelectionColor:[UIColor purpleColor]];
}
- (void)selectCyan:(id)sender {
    [_colorPicker setSelectionColor:[UIColor cyanColor]];
}

#pragma mark - Generated methods

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
