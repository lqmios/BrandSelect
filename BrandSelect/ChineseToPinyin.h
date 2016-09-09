//
//  ChineseToPinyin.h
//  BrandSelect
//
//  Created by lqm on 16/9/8.
//  Copyright © 2016年 LQM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChineseToPinyin : NSObject

+(NSString *)pinyinFromChiniseString:(NSString *)string;
+(char) sortSectionTitle:(NSString *)string;

char pinyinFirstLetter(unsigned short hanzi);


@end
