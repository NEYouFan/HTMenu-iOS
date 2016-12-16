//
//  HTMenuLocationDecider.m
//  Pods
//
//  Created by cxq on 16/3/30.
//
//

#import "HTMenuLocationDecider.h"
#import "HTMenu.h"

@implementation HTMenuLocationDecider

- (CGRect)decideLocationWithMenu:(HTMenu *)menu fromRect:(CGRect)rect
{
    NSAssert(NO, @"cannot be here");
    return CGRectZero;
}

@end

@interface HTArrowMenuLocationDecider ()

@property (nonatomic, assign) CGRect fromRect;
@property (nonatomic, assign) CGSize downBlank;
@property (nonatomic, assign) CGSize upBlank;
@property (nonatomic, assign) CGSize leftBlank;
@property (nonatomic, assign) CGSize rightBlank;
@property (nonatomic, weak) HTArrowBoxMenu *menu;

@end

@implementation HTArrowMenuLocationDecider

- (instancetype)init
{
    self = [self initWithPositionPriority:@[@(HTMenuPositionDown),@(HTMenuPositionUp),@(HTMenuPositionRight),@(HTMenuPositionLeft)]];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithPositionPriority:(NSArray<NSNumber *> *)positionPriority
{
    self = [super init];
    if (self) {
        self.positionPriority = [NSMutableArray arrayWithArray:positionPriority];
        
    }
    return self;
}

- (CGRect)decideLocationWithMenu:(HTArrowBoxMenu *)menu fromRect:(CGRect)rect
{
    _menu = menu;
    _fromRect = rect;
    if (CGRectEqualToRect(self.limitBounds, CGRectZero)) {
        self.limitBounds = [UIScreen mainScreen].bounds;
    }else{
        NSAssert(CGRectContainsRect(self.limitBounds,rect), @"Limit bounds need to contain fromRect");
    }
    _menuDirection = [self direction];
    [self decideArrowLocationWithMenuDirection:_menuDirection];
    return [self decideRectWithArrowDirection:_menuDirection];
}

- (CGRect)decideRectWithArrowDirection:(HTMenuPosition)direction
{
    CGRect menuBounds;
    switch (direction) {
        case HTMenuPositionDefault:
        case HTMenuPositionDown: {
            CGFloat tempWidth = _menu.frame.size.width - _fromRect.size.width;
            
            if (_leftBlank.width > tempWidth/2 && _rightBlank.width > tempWidth/2) {
                menuBounds = CGRectMake(_fromRect.origin.x + _fromRect.size.width/2 - _menu.frame.size.width/2,
                                        _fromRect.origin.y + _fromRect.size.height,
                                        _menu.frame.size.width, _menu.frame.size.height);
            }else if(_leftBlank.width > tempWidth/2){
                menuBounds = CGRectMake(_fromRect.origin.x - (tempWidth - _rightBlank.width),
                                        _fromRect.origin.y + _fromRect.size.height,
                                        _menu.frame.size.width, _menu.frame.size.height);
            }else if(_rightBlank.width > tempWidth/2){
                menuBounds = CGRectMake(_fromRect.origin.x - _leftBlank.width,
                                        _fromRect.origin.y + _fromRect.size.height,
                                        _menu.frame.size.width, _menu.frame.size.height);
            }else{
                NSAssert(NO, @"Limit bounds less than menu bounds");
            }
            
            break;
        }
        case HTMenuPositionUp: {
            
            CGFloat tempWidth = _menu.frame.size.width - _fromRect.size.width;
            
            if (_leftBlank.width > tempWidth/2 && _rightBlank.width > tempWidth/2) {
                menuBounds = CGRectMake(_fromRect.origin.x + _fromRect.size.width/2 - _menu.frame.size.width/2,
                                        _fromRect.origin.y - _menu.frame.size.height, _menu.frame.size.width, _menu.frame.size.height);
            }else if(_leftBlank.width > tempWidth/2){
                menuBounds = CGRectMake(_fromRect.origin.x - (tempWidth - _rightBlank.width),
                                        _fromRect.origin.y - _menu.frame.size.height, _menu.frame.size.width, _menu.frame.size.height);
            }else if(_rightBlank.width > tempWidth/2){
                menuBounds = CGRectMake(_fromRect.origin.x - _leftBlank.width,
                                        _fromRect.origin.y - _menu.frame.size.height, _menu.frame.size.width, _menu.frame.size.height);
            }else{
                NSAssert(NO, @"Limit bounds less than menu bounds");
            }
            break;
        }
        case HTMenuPositionRight: {
            
            CGFloat tempHeight = _menu.frame.size.height - _fromRect.size.height;
            
            if (_upBlank.height > tempHeight/2 && _downBlank.height > tempHeight/2) {
                menuBounds = CGRectMake(_fromRect.origin.x + _fromRect.size.width,
                                        _fromRect.origin.y + _fromRect.size.height/2 - _menu.frame.size.height/2,
                                        _menu.frame.size.width, _menu.frame.size.height);
            }else if(_upBlank.width > tempHeight/2){
                menuBounds = CGRectMake(_fromRect.origin.x + _fromRect.size.width,
                                        _fromRect.origin.y - (tempHeight - _downBlank.height),
                                        _menu.frame.size.width, _menu.frame.size.height);
            }else if(_downBlank.width > tempHeight/2){
                menuBounds = CGRectMake(_fromRect.origin.x + _fromRect.size.width,
                                        _fromRect.origin.y - _upBlank.height,
                                        _menu.frame.size.width, _menu.frame.size.height);
            }else{
                NSAssert(NO, @"Limit bounds less than menu bounds");
            }
            
            break;
        }
        case HTMenuPositionLeft: {
            
            CGFloat tempHeight = _menu.frame.size.height - _fromRect.size.height;
            
            if (_upBlank.height > tempHeight/2 && _downBlank.height > tempHeight/2) {
                menuBounds = CGRectMake(_fromRect.origin.x - _menu.frame.size.width ,
                                        _fromRect.origin.y + _fromRect.size.height/2 - _menu.frame.size.height/2,
                                        _menu.frame.size.width, _menu.frame.size.height);
            }else if(_upBlank.width > tempHeight/2){
                menuBounds = CGRectMake(_fromRect.origin.x - _menu.frame.size.width,
                                        _fromRect.origin.y - (tempHeight - _downBlank.height),
                                        _menu.frame.size.width, _menu.frame.size.height);
            }else if(_downBlank.width > tempHeight/2){
                menuBounds = CGRectMake(_fromRect.origin.x - _menu.frame.size.width,
                                        _fromRect.origin.y - _upBlank.height,
                                        _menu.frame.size.width, _menu.frame.size.height);
            }else{
                NSAssert(NO, @"Limit bounds less than menu bounds");
            }
            
            break;
        }
    }
    return menuBounds;
}

- (void)decideArrowLocationWithMenuDirection:(HTMenuPosition)direction
{
    CGFloat arrowWidth = tan(_menu.angle*M_PI/360)*_menu.arrowHeight*2;
    switch (direction) {
        case HTMenuPositionDefault:
        case HTMenuPositionDown: {
            _arrowLocation = CGRectMake(_fromRect.origin.x + _fromRect.size.width/2 - arrowWidth/2,
                                        _fromRect.origin.y + _fromRect.size.height,
                                        arrowWidth, _menu.arrowHeight);
            break;
        }
        case HTMenuPositionUp: {
            _arrowLocation = CGRectMake(_fromRect.origin.x + _fromRect.size.width/2 - arrowWidth/2,
                                        _fromRect.origin.y - _menu.arrowHeight,
                                        arrowWidth, _menu.arrowHeight);
            
            break;
        }
        case HTMenuPositionRight: {
            _arrowLocation = CGRectMake(_fromRect.origin.x + _fromRect.size.width,
                                        _fromRect.origin.y + _fromRect.size.height/2 - arrowWidth/2,
                                        _menu.arrowHeight, arrowWidth);
            break;
        }
        case HTMenuPositionLeft: {
            _arrowLocation = CGRectMake(_fromRect.origin.x - _menu.arrowHeight,
                                        _fromRect.origin.y + _fromRect.size.height/2 - arrowWidth/2,
                                        _menu.arrowHeight, arrowWidth);
            break;
        }
    }
}

- (HTMenuPosition)direction
{
    CGRect menuBounds = _menu.bounds;
    HTMenuPosition menuPosition = HTMenuPositionDefault;
    
    _downBlank = CGSizeMake(self.limitBounds.size.width,
                            self.limitBounds.origin.y + self.limitBounds.size.height - (_fromRect.origin.y + _fromRect.size.height));
    _upBlank = CGSizeMake(self.limitBounds.size.width,
                          _fromRect.origin.y - self.limitBounds.origin.y);
    
    _leftBlank = CGSizeMake(_fromRect.origin.x - self.limitBounds.origin.x,
                            self.limitBounds.size.height);
    
    _rightBlank = CGSizeMake(self.limitBounds.origin.x + self.limitBounds.size.width - (_fromRect.origin.x + _fromRect.size.width),
                             self.limitBounds.size.height);
    
    HTMenuPosition (^positionDown)(void) = ^{
        if (_downBlank.height > menuBounds.size.height) {
            return HTMenuPositionDown;
        }
        return HTMenuPositionDefault;
    };
    
    HTMenuPosition (^positionUp)(void) = ^{
        if (_upBlank.height > menuBounds.size.height) {
            return HTMenuPositionUp;
        }
        return HTMenuPositionDefault;
    };
    
    HTMenuPosition (^positionRight)(void) = ^{
        if (_rightBlank.width > menuBounds.size.width) {
            return HTMenuPositionRight;
        }
        return HTMenuPositionDefault;
    };
    
    HTMenuPosition (^positionLeft)(void) = ^{
        if (_leftBlank.width > menuBounds.size.width) {
            return HTMenuPositionLeft;
        }
        return HTMenuPositionDefault;
    };
    
    HTMenuPosition (^tempPosition)(void) = nil;
    
    NSDictionary *menuPositions = @{@(HTMenuPositionDown):positionDown,@(HTMenuPositionUp):positionUp,@(HTMenuPositionRight):positionRight,@(HTMenuPositionLeft):positionLeft};
    
    for (NSNumber *number in _positionPriority) {
        tempPosition = [menuPositions objectForKey:number];
        menuPosition = tempPosition();
        if (menuPosition != HTMenuPositionDefault) {
            return menuPosition;
        }
    }
    
    return HTMenuPositionDefault;
}

- (void)setPositionPriority:(NSMutableArray<NSNumber *> *)positionPriority
{
    if (_positionPriority != positionPriority) {
        _positionPriority = [NSMutableArray arrayWithArray:positionPriority];
        [self handelPositonPriority];
    }
}

- (void)handelPositonPriority
{
    NSSet *positionPrioritySet = [NSSet setWithArray:_positionPriority];
    
    NSAssert(_positionPriority.count == positionPrioritySet.count, @"Can not delivery repeated number！");
    
    for (NSInteger i = 1; i < 5; i++) {
        if (![positionPrioritySet containsObject:@(i)]) {
            [_positionPriority addObject:@(i)];
        }
    }
    
    NSAssert(_positionPriority.count == 4, @"Beyond the positionPriority limited count");
}

@end
