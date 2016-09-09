//
//  HeaderView.m
//  BrandSelect
//
//  Created by lqm on 16/9/8.
//  Copyright © 2016年 LQM. All rights reserved.
//

#import "HeaderView.h"
#define COLOR(RED,GREEN,BLUE,ALPHA)  [UIColor colorWithRed:RED/255.0 green:GREEN/255.0 blue:BLUE/255.0 alpha:ALPHA]
#define UIBounds [[UIScreen mainScreen] bounds]
@implementation HeaderView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        
        _titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _titleView.backgroundColor = COLOR(247,247, 247, 1);
        [self addSubview:_titleView];
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 7, self.frame.size.width-16*2, 14)];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [_titleView addSubview:_titleLabel];

        
                            
    }
    return self;
}

-(void)setTitleString:(NSString *)titleString
{
    _titleLabel.text = titleString;
}


@end
