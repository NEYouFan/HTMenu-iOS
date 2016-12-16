//
//  HTMenuViewController.m
//  HTUIDemo
//
//  Created by cxq on 16/4/6.
//  Copyright © 2016年 HT. All rights reserved.
//

#import "HTMenuViewController.h"
#import "ColorUtils.h"
#import "HTImageAndTextTableViewCell.h"
#import "HTSegmentsView.h"
#import "HTMenu.h"

@interface HTMenuViewController ()<UITableViewDataSource,UITableViewDelegate,HTSegmentsViewDatasource,HTSegmentsViewDelegate>

@property (nonatomic, strong) HTArrowBoxMenu *menu;
@property (nonatomic, strong) HTArrowMenuLocationDecider *decider;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) HTArrowBoxMenu *horizontalMenu;
@property (nonatomic, strong) HTArrowMenuLocationDecider *horizontalDecider;
@property (nonatomic, strong) HTHorizontalSegmentsView *segmentView;
@property (nonatomic, strong) HTStringToLabelDataSource *horizontalDataSource;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSArray *texts;
@property (nonatomic, strong) NSArray *strings;
@property (nonatomic, strong) UIWindow *window;
@end

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@implementation HTMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadMenus];
    [self loadData];
    [self loadTableView];
    [self loadSegmentView];
    [self loadButtons];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData
{
    _texts = @[@"发起群聊",@"添加朋友",@"扫一扫",@"收钱"];
    _images = @[[UIImage imageNamed:@"contacts_add_newmessage"],
      [UIImage imageNamed:@"contacts_add_friend"],
      [UIImage imageNamed:@"contacts_add_scan"],
      [UIImage imageNamed:@"contacts_add_money"]];
    
    _strings = @[@"拷贝",@"复制",@"粘帖",@"复制",@"粘帖",@"复制"];
}

- (void)loadMenus
{
    _decider = [[HTArrowMenuLocationDecider alloc] init];
    CGRect rect = [UIScreen mainScreen].bounds;
    _decider.limitBounds = CGRectMake(10, 10, rect.size.width-20, rect.size.height-20);
    _menu = [[HTArrowBoxMenu alloc] initWithFrame:CGRectMake(0, 0, 130, 166) locationDecider:_decider];
    [_menu setArrowAngle:90 arrowHeight:6];
    _menu.layer.contents = (id)[UIImage imageNamed:@"graybg"];
    
    HTMenuAlphaAnimator *animator = [[HTMenuAlphaAnimator alloc] initWithMenu:_menu];
    animator.duration = 0.3;
    
    _menu.animator = animator;
    
    _horizontalDecider = [[HTArrowMenuLocationDecider alloc] initWithPositionPriority:@[@(HTMenuPositionUp)]];
    _horizontalMenu = [[HTArrowBoxMenu alloc] initWithFrame:CGRectMake(0, 0, 230, 53) locationDecider:_horizontalDecider];
    animator = [[HTMenuAlphaAnimator alloc] initWithMenu:_horizontalMenu];
    animator.duration = 0.3;
    _horizontalMenu.animator = animator;
    _horizontalMenu.layer.contents = (id)[UIImage imageNamed:@"graybg"];
    [_horizontalMenu setArrowAngle:90 arrowHeight:3];
}

-  (void)loadTableView
{
    _tableView = [[UITableView alloc] init];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.scrollEnabled = NO;
    [_tableView registerClass:[HTImageAndTextTableViewCell class] forCellReuseIdentifier:NSStringFromClass([HTImageAndTextTableViewCell class])];
    [_menu addMenuDetailView:_tableView];
}

- (void)loadSegmentView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    _segmentView = [[HTHorizontalSegmentsView alloc] initWithFrame:CGRectMake(100, 200, 230, 50)];
    _segmentView.contentInset = UIEdgeInsetsZero;
    _horizontalDataSource = [self createSegmentsViewDataSource];
    _segmentView.segmentsDataSource = _horizontalDataSource;
    _segmentView.segmentsDelegate = self;
    _segmentView.needAdjustToCenter = YES;
    _segmentView.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:_segmentView];
    [_horizontalMenu addMenuDetailView:_segmentView];
}

- (id<HTSegmentsViewDatasource>)createSegmentsViewDataSource
{
    HTStringToLabelDataSource *dataSource = [[HTStringToLabelDataSource alloc] initWithArray:_strings segmentCellClass:nil];
    dataSource.fontSize = 8;
    dataSource.selectedFontSize = 10;
    dataSource.textColor = [UIColor whiteColor];
    dataSource.cellWidth = 50;//width/[self stringArray].count;
    dataSource.cellHeight = 50;//height;
    
    return dataSource;
}

- (void)loadButtons
{
    UIButton *upLeftArrowButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 80, 90, 40)];
    upLeftArrowButton.backgroundColor = [UIColor randomRGBColor];
    [upLeftArrowButton setTitle:@"UpL" forState:UIControlStateNormal];
    [upLeftArrowButton addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:upLeftArrowButton];
    
    UIButton *upCenterArrowButton = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth/2 - ScreenWidth/8, 80, 90, 40)];
    upCenterArrowButton.backgroundColor = [UIColor randomRGBColor];
    [upCenterArrowButton setTitle:@"UpC" forState:UIControlStateNormal];
    [upCenterArrowButton addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:upCenterArrowButton];
    
    UIButton *upRightArrowButton = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - ScreenWidth/4 - 10, 80, 90, 40)];
    upRightArrowButton.backgroundColor = [UIColor randomRGBColor];
    [upRightArrowButton setTitle:@"UpR" forState:UIControlStateNormal];
    [upRightArrowButton addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:upRightArrowButton];
    
    UIButton *leftArrowButton = [[UIButton alloc] initWithFrame:CGRectMake(10, ScreenHeight/2, 90, 40)];
    leftArrowButton.backgroundColor = [UIColor randomRGBColor];
    [leftArrowButton setTitle:@"LeftC" forState:UIControlStateNormal];
    [leftArrowButton addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftArrowButton];
    
    
    UIButton *centerButton = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth/2 - ScreenWidth/8 , ScreenHeight/2, 90, 40)];
    centerButton.backgroundColor = [UIColor randomRGBColor];
    [centerButton setTitle:@"CenterU" forState:UIControlStateNormal];
    [centerButton addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:centerButton];
    
    UIButton *rightArrowButton = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - ScreenWidth/4 - 10 , ScreenHeight/2, 90, 40)];
    rightArrowButton.backgroundColor = [UIColor randomRGBColor];
    [rightArrowButton setTitle:@"RightC" forState:UIControlStateNormal];
    [rightArrowButton addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightArrowButton];
    
    UIButton *downArrowButton = [[UIButton alloc] initWithFrame:CGRectMake(10, ScreenHeight - 80, ScreenWidth/4, 40)];
    downArrowButton.backgroundColor = [UIColor randomRGBColor];
    [downArrowButton setTitle:@"DownL" forState:UIControlStateNormal];
    [downArrowButton addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:downArrowButton];
    
    UIButton *downLeftArrowButton = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth/2 - ScreenWidth/8, ScreenHeight - 80, 90, 40)];
    downLeftArrowButton.backgroundColor = [UIColor randomRGBColor];
    [downLeftArrowButton setTitle:@"DownC" forState:UIControlStateNormal];
    [downLeftArrowButton addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:downLeftArrowButton];
    
    UIButton *downRightArrowButton = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - ScreenWidth/4 - 10, ScreenHeight - 80, 90, 40)];
    downRightArrowButton.backgroundColor = [UIColor randomRGBColor];
    [downRightArrowButton setTitle:@"DownR" forState:UIControlStateNormal];
    [downRightArrowButton addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:downRightArrowButton];
    
}

- (void)showMenu:(UIButton *)button
{
    if ([button.titleLabel.text isEqualToString:@"UpL"]) {
        _decider.positionPriority = @[@(HTMenuPositionDown)];
        _decider.limitBounds = [UIScreen mainScreen].bounds;
        _menu.locationDecider = _decider;
        [button showMenu:_menu];

    }

    if ([button.titleLabel.text isEqualToString:@"UpC"]) {
        _decider.positionPriority = @[@(HTMenuPositionDown)];
        _menu.locationDecider = _decider;
        [button showMenu:_menu];
        
    }

    if ([button.titleLabel.text isEqualToString:@"UpR"]) {
        _decider.positionPriority = @[@(HTMenuPositionDown)];
        _menu.locationDecider = _decider;
        [button showMenu:_menu];

    }

    if ([button.titleLabel.text isEqualToString:@"LeftC"]) {
        _horizontalDecider.positionPriority = @[@(HTMenuPositionUp)];
        _horizontalMenu.locationDecider = _horizontalDecider;
        [button showMenu:_horizontalMenu];

    }

    if ([button.titleLabel.text isEqualToString:@"CenterU"]) {
        _horizontalDecider.positionPriority = @[@(HTMenuPositionDown)];
        _horizontalMenu.locationDecider = _horizontalDecider;
        [button showMenu:_horizontalMenu];
    }

    if ([button.titleLabel.text isEqualToString:@"RightC"]) {
        _horizontalDecider.positionPriority = @[@(HTMenuPositionLeft)];
        _horizontalMenu.locationDecider = _horizontalDecider;
        [button showMenu:_horizontalMenu];
    }

    if ([button.titleLabel.text isEqualToString:@"DownL"]) {
        CGRect rect = [UIScreen mainScreen].bounds;
        _decider.limitBounds = CGRectMake(10, 10, rect.size.width-20, rect.size.height-20);
        _decider.positionPriority = @[@(HTMenuPositionUp)];
        _menu.locationDecider = _decider;
        [button showMenu:_menu];
    }

    if ([button.titleLabel.text isEqualToString:@"DownC"]) {
        CGRect rect = [UIScreen mainScreen].bounds;
        _decider.limitBounds = CGRectMake(10, 10, rect.size.width-20, rect.size.height-20);
        _decider.positionPriority = @[@(HTMenuPositionRight)];
        _menu.locationDecider = _decider;
        [button showMenu:_menu];
    }

    if ([button.titleLabel.text isEqualToString:@"DownR"]) {
        CGRect rect = [UIScreen mainScreen].bounds;
        _decider.limitBounds = CGRectMake(10, 10, rect.size.width-20, rect.size.height-20);
        _decider.positionPriority = @[@(HTMenuPositionLeft)];
        _menu.locationDecider = _decider;
        [button showMenu:_menu];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HTImageAndTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(HTImageAndTextTableViewCell.class)];
    cell.itemText = _texts[indexPath.row];
    cell.itemImage = _images[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    if (indexPath.row == 3) {
        cell.line.hidden = YES;
    }
    return cell;
}
#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}



@end
