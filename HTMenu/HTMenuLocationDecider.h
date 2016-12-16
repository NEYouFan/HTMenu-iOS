//
//  HTMenuLocationDecider.h
//  Pods
//
//  Created by cxq on 16/3/30.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, HTMenuPosition){
    HTMenuPositionDefault = 0,
    HTMenuPositionDown,
    HTMenuPositionUp,
    HTMenuPositionRight,
    HTMenuPositionLeft
};

@class HTMenu;
@class HTArrowBoxMenu;

/*!
 *  位置选择器的基类，提供位置决策的接口
 */
@interface HTMenuLocationDecider : NSObject

/*!
 *  位置选择器的限制区域，与fromRect共同确定menu的最终显示位置
 */
@property (nonatomic, assign) CGRect limitBounds;

/*!
 *  menu的位置决策接口
 *
 *  @param menu menu信息
 *  @param rect 从何处显示的位置信息
 *
 *  @return menu显示的具体位置信息
 */
- (CGRect)decideLocationWithMenu:(HTMenu *)menu fromRect:(CGRect)rect;

@end


/*!
 *  与箭头有关的位置决策器，继承与HTMenuLocationDecider
 */
@interface HTArrowMenuLocationDecider : HTMenuLocationDecider

/*!
 *  menu最终确定的方向
 */
@property (nonatomic, assign, readonly) HTMenuPosition menuDirection;

/*!
 *  箭头最终确定的位置信息
 */
@property (nonatomic, assign, readonly) CGRect arrowLocation;

/*!
 *  menu相对于fromRect的方向优先级，
 *  默认位置顺序是@[@(HTMenuPositionDown)，@(HTMenuPositionUp)，@(HTMenuPositionRight)，@(HTMenuPositionLeft)]
 *  用户可只设置@[@(HTMenuPositionRight)]内部会自动添加其它的位置信息
 */
@property (nonatomic, strong) NSMutableArray <NSNumber *> *positionPriority;

/*!
 *  提供位置选择器优先级的初始化方法
 *
 *  @param positionPriority 传入的优先级
 *
 *  @return 返回HTArrowMenuLocationDecider
 */
- (instancetype)initWithPositionPriority:(NSArray <NSNumber *>*)positionPriority;

@end