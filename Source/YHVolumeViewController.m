//
//  YHVolumeViewController.m
//  YHVolumeViewControllerDemo
//
//  Created by Yonghwi Nam on 2015. 11. 27..
//  Copyright © 2015년 Yonghwi Nam. All rights reserved. https://github.com/maztaflex/YHVolumeViewController
//

#import "YHVolumeViewController.h"
#import "YHVolumeCell.h"

@import MediaPlayer;
@import AVFoundation;

#define DEFAULT_VOLUME_VALUE                    0.062500f  // Default Value of System Volume
#define DEFAULT_CONTAINER_WIDTH                 [UIScreen mainScreen].bounds.size.width
#define DEFAULT_CONTAINER_HEIGHT                12.0f
#define DEFAULT_CELL_HSPACE                     1.0f
#define DEFAULT_CELL_VSPACE                     1.0f
#define DEFAULT_INDICATOR_COUNT                 8
#define MAX_OUTPUT_VOLUME_LEVEL                 1.0f

@interface YHVolumeViewController ()

@property (weak, nonatomic) IBOutlet UIView             *volumeContainer;

@property (weak, nonatomic) IBOutlet UIImageView        *ivOpaqueBackground;

@property (weak, nonatomic) IBOutlet UICollectionView   *volumeIndicatorList;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alcLeadingOfVolumeIndicatorList;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alcTrailingOfVolumeIndicatorList;

@property (weak, nonatomic) AVAudioSession *audioSession;
@property (assign, nonatomic) NSInteger volumeIndex;
@property (assign, nonatomic) CGRect viewRect;
@property (assign, nonatomic) CGFloat cellWidth;
@property (assign, nonatomic) CGFloat cellHeight;

@end

@implementation YHVolumeViewController

#pragma mark -
#pragma mark - Initialize
- (instancetype)init
{
    self.viewRect = CGRectMake(0.0f, 0.0f, DEFAULT_CONTAINER_WIDTH, DEFAULT_CONTAINER_HEIGHT);
    
    NSLog(@"%f, %f, %f, %f",self.viewRect.origin.x, self.viewRect.origin.y, self.viewRect.size.width, self.viewRect.size.height);
    
    return [self initWithFrame:self.viewRect];
}

- (instancetype)initWithFrame:(CGRect)rect
{
    [self setDefaultWithRect:rect];
    
    return [self initWithNibName:@"YHVolumeViewController" bundle:nil];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        self.view.frame = self.viewRect;
    }
    
    return self;
}

#pragma mark -
#pragma mark - View Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.volumeIndicatorList registerNib:[UINib nibWithNibName:@"YHVolumeCell" bundle:nil] forCellWithReuseIdentifier:@"VolumeCell"];
    
    self.audioSession = [AVAudioSession sharedInstance];
    [self.audioSession setActive:YES error:nil];
    [self.audioSession addObserver:self
                        forKeyPath:@"outputVolume"
                           options:0
                           context:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlerForAudioSesseionInterrupted:) name:AVAudioSessionInterruptionNotification object:nil];
    
    if (self.audioSession.outputVolume == MAX_OUTPUT_VOLUME_LEVEL) {
        [self registerNotificationCenterForMaxVolume];
    }
    
    MPVolumeView *volView = [[MPVolumeView alloc] initWithFrame:CGRectMake(INFINITY, INFINITY, CGFLOAT_MIN , CGFLOAT_MIN)];
    [self.view addSubview:volView];
}

#pragma mark -
#pragma mark - Private Method
- (void)setDefaultWithRect:(CGRect)rect
{
    self.viewRect = rect;
    self.cellWidth = (rect.size.width - (DEFAULT_CELL_HSPACE * DEFAULT_INDICATOR_COUNT - 1) - DEFAULT_CELL_HSPACE * 2) / DEFAULT_INDICATOR_COUNT;
    self.cellHeight = rect.size.height - (DEFAULT_CELL_VSPACE * 2);
    self.hCellSpace = DEFAULT_CELL_HSPACE;
    self.vCellSpace = DEFAULT_CELL_VSPACE;
    self.ivOpaqueBackground.backgroundColor = [UIColor blackColor];
    self.ivOpaqueBackground.alpha = 0.5f;
    self.indicatorColor = [UIColor whiteColor];
}

/*
 * Calculate cell width from horizontal spacing
 */
- (void)setHCellSpace:(CGFloat)hCellSpace
{
    _hCellSpace = hCellSpace;
    self.cellWidth = (self.viewRect.size.width - (hCellSpace * (DEFAULT_INDICATOR_COUNT - 1)) - hCellSpace * 2) / DEFAULT_INDICATOR_COUNT;
    self.alcLeadingOfVolumeIndicatorList.constant = hCellSpace;
    self.alcTrailingOfVolumeIndicatorList.constant = hCellSpace;
}

/*
 * Calculate cell width from vertical spacing
 */
- (void)setVCellSpace:(CGFloat)vCellSpace
{
    _vCellSpace = vCellSpace;
    self.cellHeight = self.viewRect.size.height - (vCellSpace * 2);
}

- (void)setOpaqueBgColor:(UIColor *)opaqueBgColor
{
    self.ivOpaqueBackground.backgroundColor = opaqueBgColor;
}

- (void)setOpaqueBgAlpha:(CGFloat)opaqueBgAlpha
{
    self.ivOpaqueBackground.alpha = opaqueBgAlpha;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {

    float vol = self.audioSession.outputVolume;
    
    if (vol == MAX_OUTPUT_VOLUME_LEVEL)
    {
        [self registerNotificationCenterForMaxVolume];
    }
    
    self.volumeIndex = vol / DEFAULT_VOLUME_VALUE;

    if ([keyPath isEqual:@"outputVolume"])
    {
        self.volumeContainer.alpha = 1.0f;
        [self.volumeIndicatorList reloadData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [UIView animateWithDuration:1.0f animations:^{
                self.volumeContainer.alpha = 0.0f;
            } completion:^(BOOL finished) {
                
            }];
        });
    }
}

- (void)handlerForAudioSesseionInterrupted:(NSNotification *)notification
{
    NSString *notifyName = notification.name;
    NSDictionary *userInfo = notification.userInfo;
    
    if ([notifyName isEqualToString:AVAudioSessionInterruptionNotification])
    {
        AVAudioSessionInterruptionType interruptionType = [[userInfo objectForKey:AVAudioSessionInterruptionTypeKey] integerValue];
        
        if (interruptionType == AVAudioSessionInterruptionTypeEnded)
        {
            [self.audioSession setActive:YES error:nil];
        }
    }
}

/*
 * Invoke method when audio session output level max
 */
- (void)volumeDidChange:(NSNotification *)notification
{
    float vol = self.audioSession.outputVolume;
    
    if (vol < MAX_OUTPUT_VOLUME_LEVEL) {
        return;
    }
    
    self.volumeIndex = vol / DEFAULT_VOLUME_VALUE;
    self.volumeContainer.alpha = 1.0f;
    [self.volumeIndicatorList reloadData];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [UIView animateWithDuration:1.0f animations:^{
            self.volumeContainer.alpha = 0.0f;
        } completion:^(BOOL finished) {
            
        }];
    });
}

- (void)registerNotificationCenterForMaxVolume
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(volumeDidChange:)
                                                 name:@"AVSystemController_SystemVolumeDidChangeNotification"
                                               object:nil];
}

#pragma mark - UICollectionView Datasource, Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    NSInteger itemCount = DEFAULT_INDICATOR_COUNT;
    
    return itemCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"VolumeCell";
    
    NSInteger row = indexPath.row;
    
    YHVolumeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    cell.ivVolumeIndicator.backgroundColor = self.indicatorColor;
    NSInteger newVol = self.volumeIndex - 1;
    
    if (newVol < 0) {
        cell.hidden = YES;
        return cell;
    }
    
    if (row <= newVol / 2)
    {
        cell.hidden = NO;
        cell.ivVolumeIndicator.alpha = 1.0f;
        if (row == newVol / 2)
        {
            if (newVol % 2 == 0)
            {
                cell.ivVolumeIndicator.alpha = 0.5f;
            }
        }
    }
    else
    {
        cell.hidden = YES;
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize cellSize = CGSizeMake(self.cellWidth, self.cellHeight);
    
    return cellSize;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets inset = UIEdgeInsetsMake(self.vCellSpace, 0, self.vCellSpace, 0);
    
    return inset;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    CGFloat spacing = self.hCellSpace;
    
    return spacing;
}
@end
