//
//  ViewController.m
//  HoveringNavigationBar
//
//  Created by sunshuaikun on 17/3/8.
//  Copyright © 2017年 sunshuaikun. All rights reserved.
//

#import "ViewController.h"
#import "DTGroupHeaderView.h"
#import "SKCalendarView.h"

@interface ViewController (){
    SKCalendarView              *_calendarView;
    DTGroupHeaderView           *_header;
    UIView                      *_navView;
    UIView                      *aCoveringView;
    UITableView                 *_tableView;
}
@property (strong, nonatomic)  NSLayoutConstraint *headerViewHeightConstraint;
@property (strong, nonatomic)  NSLayoutConstraint *headerViewTopConstraint;
@property (strong, nonatomic)  NSLayoutConstraint *coverViewHeightConstraint;
@end

@implementation ViewController


- (void)loadView
{
    //设置当前视图背景色
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_MAIN_WIDTH, SCREEN_MAIN_HEIGHT)];
    self.view.backgroundColor = [UIColor whiteColor];
    _header = [DTGroupHeaderView headerView];
    //添加表视图
    [self addTableView];
    //一周日历图
    [self addWeekCalendarView];
    [self configureHeaderView];
    [self addNavView];
}

- (void)addWeekCalendarView
{
    _calendarView = [[SKCalendarView alloc] init];
    [_header addSubview:_calendarView];
    _calendarView.translatesAutoresizingMaskIntoConstraints = NO;
    [_header addConstraint:[NSLayoutConstraint constraintWithItem:_calendarView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_header attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [_header addConstraint:[NSLayoutConstraint constraintWithItem:_calendarView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_header attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [_header addConstraint:[NSLayoutConstraint constraintWithItem:_calendarView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_header attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [_header addConstraint:[NSLayoutConstraint constraintWithItem:_calendarView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:kFloatingViewMinimumHeight]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _tableView.contentInset = UIEdgeInsetsMake(kFloatingViewMaximumHeight, 0, 0, 0);
    _tableView.contentOffset = CGPointMake(0, -kFloatingViewMaximumHeight);
    [_tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)configureHeaderView {
    aCoveringView = [[UIView alloc] init];
    aCoveringView.backgroundColor = [UIColor blackColor];
    aCoveringView.alpha = .2f;
    [_header.headerImageView addSubview:aCoveringView];
    
    _header.headerImageView.translatesAutoresizingMaskIntoConstraints = NO;
    aCoveringView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [_header.headerImageView addConstraint:[NSLayoutConstraint constraintWithItem:aCoveringView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_header.headerImageView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [_header.headerImageView addConstraint:[NSLayoutConstraint constraintWithItem:aCoveringView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_header.headerImageView attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [_header.headerImageView addConstraint:[NSLayoutConstraint constraintWithItem:aCoveringView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_header.headerImageView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    
    self.coverViewHeightConstraint = [NSLayoutConstraint constraintWithItem:aCoveringView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:kFloatingViewMaximumHeight];
    [aCoveringView addConstraint:self.coverViewHeightConstraint];
    
    _header.translatesAutoresizingMaskIntoConstraints = NO;
    [_header.headerImageView setImage:[UIImage imageNamed:@"home_header"]];
    [_header.headerImageView setContentMode:UIViewContentModeScaleAspectFill];
    _header.headerImageView.clipsToBounds = YES;
    [self.view addSubview:_header];
    
    self.headerViewHeightConstraint = [NSLayoutConstraint constraintWithItem:_header attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:kFloatingViewMaximumHeight];
    [_header addConstraint:self.headerViewHeightConstraint];
    
    self.headerViewTopConstraint = [NSLayoutConstraint constraintWithItem:_header attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_tableView attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    [self.view addConstraint:self.headerViewTopConstraint];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_header attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_header attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
}

- (void)addNavView
{
    _navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_MAIN_WIDTH, 64)];
    _navView.backgroundColor = [UIColor colorWithRed:52/255.0 green:148/255.0 blue:232/255.0 alpha:1.0];
    [self.view addSubview:_navView];
}
- (void)addTableView
{
    //添加表格视图
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorColor = [UIColor whiteColor];
    
    _tableView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    [self.view addSubview:_tableView];
    
    //设置表格视图的footview
    UIView *footview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_MAIN_WIDTH, SCREEN_MAIN_HEIGHT+200)];
    footview.backgroundColor =  [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    _tableView.tableFooterView = footview;
    
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
}

#pragma mark - kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGPoint offset = [change[NSKeyValueChangeNewKey] CGPointValue];
        
        if (offset.y <= 0 && -offset.y >= kFloatingViewMaximumHeight) {
            self.headerViewTopConstraint.constant = 0;
            self.headerViewHeightConstraint.constant = - offset.y;
            self.coverViewHeightConstraint.constant = -offset.y;
            _navView.backgroundColor = [UIColor clearColor];
        } else if (offset.y < 0 && -offset.y < kFloatingViewMaximumHeight && -offset.y > kFloatingViewMinimumHeight) {
            self.headerViewHeightConstraint.constant = kFloatingViewMaximumHeight;
            self.headerViewTopConstraint.constant = -offset.y - kFloatingViewMaximumHeight;
            _navView.backgroundColor = RGBCOLOR(52,148,232,1);
            CGFloat alpha = kFloatingViewMinimumHeight/-offset.y;
            _navView.alpha = alpha;
            if(alpha >0.97){
                [self.view sendSubviewToBack:_navView];
                _calendarView.backgroundColor = RGBCOLOR(52,148,232,1);
            }else{
                [self.view bringSubviewToFront:_navView];
                _calendarView.backgroundColor = [UIColor clearColor];
            }
            
        } else {
            self.headerViewTopConstraint.constant = kFloatingViewMinimumHeight - kFloatingViewMaximumHeight;
            
            [self.view sendSubviewToBack:_navView];
            _calendarView.backgroundColor = RGBCOLOR(52,148,232,1);
        }
    }
}

- (void)dealloc
{
    [_tableView removeObserver:self forKeyPath:@"contentOffset"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
