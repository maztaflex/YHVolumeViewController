//
//  ViewController.m
//  YHVolumeViewControllerDemo
//
//  Created by Yonghwi Nam on 2015. 12. 2..
//  Copyright © 2015년 Yonghwi Nam. All rights reserved. https://github.com/maztaflex/YHVolumeViewController
//

#import "ViewController.h"
#import "YHVolumeViewController.h"

#define SCREEN_WIDTH                                    [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT                                   [[UIScreen mainScreen] bounds].size.height

@import MediaPlayer;
@import AVFoundation;

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIView *videoPlayContainer;

@property (strong, nonatomic) MPMoviePlayerController *player;
@property (strong, nonatomic) YHVolumeViewController *yhVolumeViewController;
@end

@implementation ViewController

#pragma mark -
#pragma mark - View Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /* Set movie player view */
    [self configureLayout];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    /* Add YHVolueViewController to some subview(videoPlayContainer) */
    [self addYHVolumeViewController];
}

#pragma mark -
#pragma mark - Private Method
- (void)addYHVolumeViewController
{
    if (self.yhVolumeViewController == nil)
    {
        self.yhVolumeViewController = [[YHVolumeViewController alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 414.0f, 30.0f)];
        self.yhVolumeViewController.vCellSpace = 3.0f;
        self.yhVolumeViewController.hCellSpace = 3.0f;
        self.yhVolumeViewController.indicatorColor = [UIColor yellowColor];
        
        [self.videoPlayContainer addSubview:self.yhVolumeViewController.view];
    }
}

- (void)configureLayout
{
    self.player = [[MPMoviePlayerController alloc] initWithContentURL:[self getContentURLInBundleWithFileName:@"Girls' GenerationTeaser" ext:@"mp4"]];
    self.player.scalingMode = MPMovieScalingModeAspectFill;
    self.player.controlStyle = MPMovieControlStyleNone;
    self.player.shouldAutoplay = YES;
    self.player.repeatMode = MPMovieRepeatModeOne;
    [self.player.view setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.player prepareToPlay];
    
    [self.videoPlayContainer addSubview:self.player.view];
}

- (NSURL *)getContentURLInBundleWithFileName:(NSString *)fileName ext:(NSString *)ext
{
    NSString *urlStr = [[NSBundle mainBundle] pathForResource:fileName ofType:ext];
    NSURL *mUrl = [NSURL fileURLWithPath:urlStr];
    
    return mUrl;
}

@end
