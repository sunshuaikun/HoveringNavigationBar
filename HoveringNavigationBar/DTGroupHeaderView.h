//
//  DTGroupHeaderView.h
//  DTGroupHeaderView
//
//  Created by sunshuaikun on 16/3/21.
//  Copyright (c) 2016. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DTGroupHeaderView : UIView

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *headerTopConstraint;
@property (nonatomic, weak) IBOutlet UIImageView *headerImageView;
@property (nonatomic, weak) IBOutlet UIImageView *heartImageView;
@property (nonatomic,weak) IBOutlet UILabel *titleLabel;
@property (nonatomic,weak) IBOutlet UILabel *promptLabel;
@property (nonatomic,weak) IBOutlet UILabel *dayLabel;
@property (nonatomic,weak) IBOutlet UILabel *likesLabel;
@property (nonatomic,weak) IBOutlet UILabel *dayNameLabel;
//@property (nonatomic, weak) IBOutlet UIView *segmentView;
@property (nonatomic,weak) IBOutlet UIView  *tapView;
@property (nonatomic,weak) IBOutlet UIButton *todayButton;
@property (nonatomic,weak) IBOutlet UIButton *todayMaskButton;
+ (DTGroupHeaderView *)headerView;

@end
