//
//  DTGroupHeaderView.h
//  DTGroupHeaderView
//
//  Created by sunshuaikun on 16/3/21.
//  Copyright (c) 2016. All rights reserved.
//

#import "DTGroupHeaderView.h"

@implementation DTGroupHeaderView

+ (DTGroupHeaderView *)headerView {
    DTGroupHeaderView *headerView = [[NSBundle mainBundle] loadNibNamed:@"DTGroupHeaderView" owner:self options:nil][0];
    return headerView;
}

@end
