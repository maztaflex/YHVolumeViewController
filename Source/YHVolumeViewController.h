//
//  YHVolumeViewController.h
//  VideoPlayer
//
//  Created by DEV_TEAM1_IOS on 2015. 11. 27..
//  Copyright © 2015년 DEV_TEAM1_IOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YHVolumeViewController : UIViewController

/*
 * Using this method if you want to custom view frame.
 * The default view frame is CGRectMake(0, 0, screen width, 18.0f)
 */
- (instancetype)initWithFrame:(CGRect)rect;


/* 
 * The value of between ecah cell space
 * The default value is 1.0f
 */
@property (assign, nonatomic) CGFloat hCellSpace;


/*
 * The value of top and bottom of cell space
 * The default value is 1.0f
 */
@property (assign, nonatomic) CGFloat vCellSpace;


/*
 * The collection view background color
 * The default value is black color
 */
@property (strong, nonatomic) UIColor *opaqueBgColor;


/*
 * The collection view alpha value
 * The default value is 0.5f
 */
@property (assign, nonatomic) CGFloat opaqueBgAlpha;

/*
 * The cell color
 * The default value is white color
 */
@property (strong, nonatomic) UIColor *indicatorColor;


@end
