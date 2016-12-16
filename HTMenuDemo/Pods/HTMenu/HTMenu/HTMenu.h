//
//  HTMenu.h
//  Pods
//
//  Created by cxq on 16/3/30.
//
//
#import <UIKit/UIKit.h>
#import "HTMenuAnimator.h"
#import "HTMenuLocationDecider.h"

/*!
 *  HTMenu是提供列表项的一个容器，HTMenu是基类，没有具体的实现。提供子类HTArrowBoxMenu作为默认的实现。
 */
@interface HTMenu : UIView

/*!
 *  初始化方法，可提供位置决策
 *
 *  @param frame           menu的整体大小包
 *  @param locationDecider 传入的位置决策器
 *
 *  @return 返回实例menu
 */
- (instancetype)initWithFrame:(CGRect)frame locationDecider:(HTMenuLocationDecider *)locationDecider;

/*!
 *  menu显示和消失的动画
 */
@property (nonatomic, strong) HTMenuAnimator *animator;

/*!
 *  menu的位置决策器
 */
@property (nonatomic, strong) HTMenuLocationDecider *locationDecider;

/*!
 *  menu显示的调用接口，需要传入显示的位置信息fromRect，用于通过决策器HTMenuLocationDecider自适应调整menu位置
 *
 *  @param fromRect 从何处显示的位置信息，即点击的区域。fromRect在子类HTArrowBoxMenu中的值必须是相对于window
 */
- (void)showFromRect:(CGRect)fromRect;

/*!
 *  隐藏menu
 */
- (void)hide;

@end

/*!
 *  HTMenu的子类，用于显示箭头并且自适应位置的menu
 */
@interface HTArrowBoxMenu : HTMenu

/*!
 *  menu与fromRect的位置关系
 */
@property (nonatomic, assign) HTMenuPosition menuPosition;

/*!
 *  是否需要自适应位置
 */
@property (nonatomic, assign) BOOL needAutoAdjustLocation;

/*!
 *  不建议用户修改，如若需要毛玻璃等效果可替换,内部会自动增加点击隐藏的事件
 */
@property (nonatomic, strong) UIWindow *modalWindow;

/*!
 *  显示箭头的图片，可不设置，默认情况下箭头与背景是一体的
 */
@property (nonatomic, strong, readonly) UIImageView *arrowImageView;

/*!
 *  箭头图片
 */
@property (nonatomic, strong) UIImage *arrowImage;

/*!
 *  箭头的高度
 */
@property (nonatomic, assign) CGFloat arrowHeight;
/*!
 *  箭头的角度，即等腰三角形顶角角度
 */
@property (nonatomic, assign) CGFloat angle;

/*!
 *  menu的圆角设置
 */
@property (nonatomic, assign) CGFloat cornerRadius;


/*!
 *  设置箭头的helper接口
 *
 *  @param angle  箭头角度
 *  @param height 箭头高度
 */
- (void)setArrowAngle:(CGFloat)angle arrowHeight:(CGFloat)height;

/*!
 *  添加menu显示的详细内容，可以是tableView或者是其它自定义view
 *
 *  @param detailView 显示的具体view
 */
- (void)addMenuDetailView:(UIView *)detailView;

@end


@interface UIView (HTMenu)

/*!
 *  helper接口，直接将控件映射到window作为fromRect显示menu
 *
 *  @param menu 所要显示的menu
 */
- (void)showMenu:(HTMenu *)menu;

@end