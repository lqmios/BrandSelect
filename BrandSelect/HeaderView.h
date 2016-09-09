//
//  HeaderView.h
//  BrandSelect
//
//  Created by lqm on 16/9/8.
//  Copyright © 2016年 LQM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderView : UIView

@property(nonatomic,strong)UIView *titleView;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)NSString *titleString;
-(void)setTitleString:(NSString *)titleString;


@end
