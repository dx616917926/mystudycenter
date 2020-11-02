#ifdef LITEAV
#import "TXVodPlayer.h"
#import "TXLivePlayer.h"
#import "TXImageSprite.h"
#import "TXLiveBase.h"
#endif

#import "SuperPlayerView.h"
#import "SuperPlayerModel.h"
#import "SuperPlayerControlView.h"
#import "SuperPlayerControlViewDelegate.h"
#import "SPDefaultControlView.h"
#import "SPWeiboControlView.h"

// 屏幕的宽
#define ScreenWidth                         [[UIScreen mainScreen] bounds].size.width
// 屏幕的高
#define ScreenHeight                        [[UIScreen mainScreen] bounds].size.height
// 颜色值RGB
#define RGBA(r,g,b,a)                       [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
// 图片路径
#define SuperPlayerImage(file)              [UIImage imageNamed:[NSString stringWithFormat:@"sp_%@",file]]

#define TintColor RGBA(252, 89, 81, 1)      //播放器进度条颜色

#define LOG_ME NSLog(@"%s", __func__);
