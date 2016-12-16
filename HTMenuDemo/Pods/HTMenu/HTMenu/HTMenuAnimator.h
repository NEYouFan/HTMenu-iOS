//
//  HTMenuAnimator.h
//  Pods
//
//  Created by cxq on 16/3/30.
//
//

#import <Foundation/Foundation.h>
@class HTMenu;

@interface HTMenuAnimator : NSObject

- (instancetype)initWithMenu:(HTMenu *)menu;

- (void)showWithCompleteBlock:(void(^)(void))completeBlock;
- (void)hideWithCompleteBlock:(void(^)(void))completeBlock;
@property (nonatomic, weak) HTMenu *menu;

@end

@interface HTMenuAlphaAnimator : HTMenuAnimator

@property (nonatomic, assign) CGFloat duration;

@end
