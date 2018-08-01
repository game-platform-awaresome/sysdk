//
//  SDK_ADImage.h
//  SY_185SDK
//
//  Created by 燚 on 2017/12/20.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SDK_ADImage;

@protocol ADImageDelegate <NSObject>


- (void)m185ADImage:(SDK_ADImage *)ADImage respondsToCloseButton:(id)info;


@end


@interface SDK_ADImage : NSObject


@property (nonatomic, weak) id<ADImageDelegate> delegate;


+ (BOOL)showADImageWithDelegate:(id)delegate andStatus:(NSString *)status;



@end
