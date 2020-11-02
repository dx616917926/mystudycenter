#import "SuperPlayerModel.h"
#import "SuperPlayer.h"
#import "AFNetworking/AFNetworking.h"
#import <Security/Security.h>
#import "SuperPlayerView+Private.h"

@implementation SuperPlayerModel {
    
}

- (instancetype)init {
    self = [super init];
    if (self) {

    }
    return self;
}

- (void)dealloc {
    
}

- (int)playingDefinitionIndex
{
    for (int i = 0; i < self.playDefinitions.count; i++) {
        if ([self.playDefinitions[i] isEqualToString:self.playingDefinition]) {
            return i;
        }
    }
    return 0;
}

@end
