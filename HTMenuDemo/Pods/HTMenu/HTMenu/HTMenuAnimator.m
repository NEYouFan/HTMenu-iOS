//
//  HTMenuAnimator.m
//  Pods
//
//  Created by cxq on 16/3/30.
//
//

#import "HTMenuAnimator.h"
#import "HTMenu.h"

@interface HTMenuAnimator ()
@end

@implementation HTMenuAnimator

- (instancetype)initWithMenu:(HTMenu *)menu
{
    self = [super init];
    
    if (self) {
        _menu = menu;
    }
    
    return self;
}

- (void)showWithCompleteBlock:(void (^)(void))completeBlock
{
    NSAssert(NO, @"cannot be here");
}

- (void)hideWithCompleteBlock:(void (^)(void))completeBlock
{
    NSAssert(NO, @"cannot be here");
}
@end


@implementation HTMenuAlphaAnimator

- (instancetype)initWithMenu:(HTMenu *)menu
{
    self = [super initWithMenu:menu];
    
    if (self) {
        _duration = 1.0;
    }
    
    return self;
}

- (void)showWithCompleteBlock:(void (^)(void))completeBlock
{
    self.menu.alpha = 0;
    [UIView animateWithDuration:_duration animations:^{
        self.menu.alpha = 1;
    } completion:^(BOOL finished) {
        if (completeBlock) {
            completeBlock();
        }
    }];
}

- (void)hideWithCompleteBlock:(void (^)(void))completeBlock
{
    [UIView animateWithDuration:_duration animations:^{
        self.menu.alpha = 0;
    } completion:^(BOOL finished) {
        if (completeBlock) {
            completeBlock();
        }
    }];
}

@end
