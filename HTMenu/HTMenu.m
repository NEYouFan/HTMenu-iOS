//
//  HTMenu.m
//  Pods
//
//  Created by cxq on 16/3/30.
//
//

#import "HTMenu.h"

@implementation HTMenu

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [self initWithFrame:frame locationDecider:nil];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame locationDecider:(HTMenuLocationDecider *)locationDecider
{
    self = [super initWithFrame:frame];
    if (self) {
        _locationDecider = locationDecider;
    }
    
    return self;
}

- (void)showFromRect:(CGRect)fromRect
{
    NSAssert(NO, @"cannot be here");
}

- (void)hide
{
    NSAssert(NO, @"cannot be here");
}

@end


@interface HTArrowBoxMenu ()

@property (nonatomic, strong) UIView *detailView;
@property (nonatomic, assign) CGFloat arrowWidth;
@property (nonatomic, assign) CGRect arrowRect;
@property (nonatomic, assign) CGRect menuRect;
@property (nonatomic, strong) UIView *menuTapView;

@end

@implementation HTArrowBoxMenu

- (instancetype)initWithFrame:(CGRect)frame locationDecider:(HTMenuLocationDecider *)locationDecider
{
    self = [super initWithFrame:frame locationDecider:locationDecider];
    if (self)
    {
        _needAutoAdjustLocation = YES;
        self.modalWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)orientationDidChange:(NSNotification *)notification {
    _modalWindow.frame = [UIScreen mainScreen].bounds;
    [self addTapEventAndHandelRoot];
}

- (void)showFromRect:(CGRect)fromRect
{
    if (_needAutoAdjustLocation) {
        _menuRect = [self.locationDecider decideLocationWithMenu:self fromRect:fromRect];
        _arrowRect = ((HTArrowMenuLocationDecider*)self.locationDecider).arrowLocation;
        self.menuPosition = ((HTArrowMenuLocationDecider*)self.locationDecider).menuDirection;
        [self setNeedsDisplay];
        self.frame = _menuRect;
    }
    
    if (_modalWindow) {
        [_modalWindow.rootViewController.view addSubview:self];
        [_modalWindow makeKeyAndVisible];
    }else{
        self.modalWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [_modalWindow.rootViewController.view addSubview:self];
        [_modalWindow makeKeyAndVisible];
    }
    
    if (self.animator) {
        [self.animator showWithCompleteBlock:nil];
    }
    
}

- (void)hide
{
    if (self.animator) {
        __weak HTArrowBoxMenu *weakSelf = self;
        [self.animator hideWithCompleteBlock:^{
            [weakSelf removeFromSuperview];
            weakSelf.modalWindow.hidden = YES;
        }];
        
    }else{
        _modalWindow.hidden = YES;
        [self removeFromSuperview];
    }
}

- (void)setArrowAngle:(CGFloat)angle arrowHeight:(CGFloat)height
{
    _angle = angle;
    _arrowHeight = height;
    _arrowWidth = tan(angle*M_PI/360)*height*2;
}

- (void)addMenuDetailView:(UIView *)detailView
{
    [_detailView removeFromSuperview];
    _detailView = detailView;
    [self addSubview:_detailView];
}

- (void)setArrowImage:(UIImage *)arrowImage
{
    if (_arrowImage != arrowImage) {
        _arrowImage = arrowImage;
        [_arrowImageView removeFromSuperview];
        
        if (_arrowImage == nil) {
            return;
        }
        
        if (!_arrowImageView) {
            _arrowImageView = [[UIImageView alloc] initWithImage:_arrowImage];
        }else{
            _arrowImageView.image = _arrowImage;
        }
        [self addSubview:_arrowImageView];
    }
}

- (void)setModalWindow:(UIWindow *)modalWindow
{
    if (_modalWindow != modalWindow) {
        _modalWindow = modalWindow;
        [self addTapEventAndHandelRoot];
    }
}

- (void)addTapEventAndHandelRoot
{
    if (!_modalWindow.rootViewController) {
        UIViewController *vc = [UIViewController new];
        _modalWindow.rootViewController = vc;
    }
    
    UITapGestureRecognizer *tapGestureRecogizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    tapGestureRecogizer.numberOfTapsRequired = 1;
    
    if (!_menuTapView) {
        _menuTapView = [[UIView alloc] init];
    }
    [_menuTapView removeFromSuperview];
    _menuTapView.frame = _modalWindow.bounds;
    _menuTapView.backgroundColor = [UIColor clearColor];
    [_modalWindow.rootViewController.view addSubview:_menuTapView];;
    [_menuTapView addGestureRecognizer:tapGestureRecogizer];
}

#pragma mark - drawRect

- (void)drawRect:(CGRect)rect
{
    UIColor *color = [UIColor clearColor];
    [color set]; //设置线条为空
    UIBezierPath *menuBezierPath;
    UIBezierPath *arrowBezierPath = [UIBezierPath bezierPath];
    CGRect tempRect = _menuRect;
    CGRect tempArrowRect = _arrowRect;
    CGPoint startPoint;
    CGPoint vertexPoint;
    CGPoint endPoint;
    switch (self.menuPosition) {
        case HTMenuPositionDefault:
        case HTMenuPositionDown: {
            tempRect.origin.x = 0;
            tempRect.origin.y = self.arrowHeight;
            tempRect.size.height = tempRect.size.height - self.arrowHeight;
            
            tempArrowRect.origin.x = _arrowRect.origin.x - _menuRect.origin.x;
            tempArrowRect.origin.y = 0;
            
            startPoint = CGPointMake(tempArrowRect.origin.x, _arrowHeight);
            vertexPoint = CGPointMake(tempArrowRect.origin.x + _arrowWidth/2, 0);
            endPoint = CGPointMake(tempArrowRect.origin.x + _arrowWidth, _arrowHeight);
            break;
        }
        case HTMenuPositionUp: {
            tempRect.origin.x = 0;
            tempRect.origin.y = 0;
            tempRect.size.height = tempRect.size.height - self.arrowHeight;
            
            tempArrowRect.origin.x = _arrowRect.origin.x - _menuRect.origin.x;
            tempArrowRect.origin.y = _arrowRect.origin.y - _menuRect.origin.y;
            
            startPoint =CGPointMake(tempArrowRect.origin.x, tempArrowRect.origin.y);
            vertexPoint = CGPointMake(tempArrowRect.origin.x + _arrowWidth/2, tempArrowRect.origin.y + _arrowHeight);
            endPoint = CGPointMake(tempArrowRect.origin.x + _arrowWidth, tempArrowRect.origin.y);
            break;
        }
        case HTMenuPositionRight: {
            tempRect.origin.x = self.arrowHeight;
            tempRect.origin.y = 0;
            tempRect.size.width = tempRect.size.width - self.arrowHeight;
            
            tempArrowRect.origin.x = 0;
            tempArrowRect.origin.y = _arrowRect.origin.y - _menuRect.origin.y;
            
            startPoint = CGPointMake(tempArrowRect.origin.x + _arrowHeight, tempArrowRect.origin.y);
            vertexPoint = CGPointMake(tempArrowRect.origin.x, tempArrowRect.origin.y + _arrowWidth/2);
            endPoint = CGPointMake(tempArrowRect.origin.x + _arrowHeight, tempArrowRect.origin.y + _arrowWidth);
            
            break;
        }
        case HTMenuPositionLeft: {
            tempRect.origin.x = 0;
            tempRect.origin.y = 0;
            tempRect.size.width = tempRect.size.width - self.arrowHeight;
            
            tempArrowRect.origin.x = _arrowRect.origin.x - _menuRect.origin.x;
            tempArrowRect.origin.y = _arrowRect.origin.y - _menuRect.origin.y;
            
            startPoint = CGPointMake(tempArrowRect.origin.x, tempArrowRect.origin.y);
            vertexPoint =  CGPointMake(tempArrowRect.origin.x  + _arrowHeight, tempArrowRect.origin.y + _arrowWidth/2);
            endPoint = CGPointMake(tempArrowRect.origin.x, tempArrowRect.origin.y + _arrowWidth);
            break;
        }
            
    }
    menuBezierPath = [UIBezierPath bezierPathWithRoundedRect:tempRect cornerRadius:_cornerRadius];
    if (!_arrowImage) {
        arrowBezierPath = [self startPoint:startPoint vertexPoint:vertexPoint endPoint:endPoint];
        [menuBezierPath appendPath:arrowBezierPath];
    }else{
        [menuBezierPath appendPath:[UIBezierPath bezierPathWithRect:tempArrowRect]];
        _arrowImageView.frame = tempArrowRect;
    }
    _detailView.frame = tempRect;
    [menuBezierPath stroke];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = menuBezierPath.CGPath;
    self.layer.mask = shapeLayer;
    self.layer.masksToBounds = YES;
    
}

- (UIBezierPath *)startPoint:(CGPoint)startPoint vertexPoint:(CGPoint)vertexPoint endPoint:(CGPoint)endPoint
{
    UIBezierPath *arrowBezierPath = [UIBezierPath bezierPath];
    [arrowBezierPath moveToPoint:startPoint];
    [arrowBezierPath addLineToPoint:vertexPoint];
    [arrowBezierPath addLineToPoint:endPoint];
    [arrowBezierPath closePath];
    return arrowBezierPath;
}

@end

@implementation UIView (HTMenu)

- (void)showMenu:(HTMenu *)menu
{
    CGRect realRect = [self convertRect:self.bounds toView:nil];
    [menu showFromRect:realRect];
}


@end
