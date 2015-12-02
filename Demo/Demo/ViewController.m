//
//  ViewController.m
//  Demo
//
//  Created by DEV_TEAM1_IOS on 2015. 12. 2..
//  Copyright © 2015년 DEV_TEAM1_IOS. All rights reserved.
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
    
    [self configureLayout];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self addYHVolumeViewController];
}

#pragma mark -
#pragma mark - Private Method
- (void)addYHVolumeViewController
{
    if (self.yhVolumeViewController == nil)
    {
        self.yhVolumeViewController = [[YHVolumeViewController alloc] init];
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
