//
//  ViewController.m
//  Demo
//
//  Created by DEV_TEAM1_IOS on 2015. 12. 2..
//  Copyright © 2015년 DEV_TEAM1_IOS. All rights reserved.
//

#import "ViewController.h"

@import MediaPlayer;
@import AVFoundation;

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIView *videoPlayContainer;

@property (strong, nonatomic) MPMoviePlayerController *player;

@end

@implementation ViewController

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

#pragma mark - Private Method
- (void)configureLayout
{
    // 비디오 플레이어 설정
    self.player = [[MPMoviePlayerController alloc] initWithContentURL:[self getContentURLInBundleWithFileName:@"sampleVideo" ext:@"mp4"]];
    self.player.scalingMode = MPMovieScalingModeAspectFill;
    self.player.controlStyle = MPMovieControlStyleNone;
    self.player.shouldAutoplay = YES;
    self.player.repeatMode = MPMovieRepeatModeOne;
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    [self.player.view setFrame:CGRectMake(0, 0, screenSize.width, screenSize.height)];
    [self.player prepareToPlay];
    
    // 비디오 플레이어 서브뷰 등록
    [self.videoPlayContainer addSubview:self.player.view];
}

// 번들 비디오 파일 URL
- (NSURL *)getContentURLInBundleWithFileName:(NSString *)fileName ext:(NSString *)ext
{
    NSString *urlStr = [[NSBundle mainBundle] pathForResource:fileName ofType:ext];
    NSURL *mUrl = [NSURL fileURLWithPath:urlStr];
    
    return mUrl;
}

// 원격 비디오 파일 URL
- (NSURL *)getContentURLWithURLString:(NSString *)urlString
{
    NSURL *remoteURL = [NSURL URLWithString:urlString];
    
    return remoteURL;
}

@end
