YHVolumeViewController
=======================
I created a volume view controller like 'Snapchat'.

This is first time that I made it

## Features
- Customizing layoout and colors

## Screen shots
![screen shot1](https://github.com/maztaflex/YHVolumeViewController/blob/master/Assets/screenshot_00.jpg)
![screen shot2](https://github.com/maztaflex/YHVolumeViewController/blob/master/Assets/screenshot_01.jpg)

## Requirements
- XCode 7
- iOS 7.1 or higher
- ARC

## Installation

#import "YHVolumeViewController.h"


## Usage
#### Default Layout 
```Objective-C
- (void)viewDidAppear:(BOOL)animated
{
    if (self.yhVolumeViewController == nil)
    {
        self.yhVolumeViewController = [[YHVolumeViewController alloc] init];

        [self.videoPlayContainer addSubview:self.yhVolumeViewController.view];
    }
}
```

#### Custom Layout 
```Objective-C
- (void)viewDidAppear:(BOOL)animated
{
    if (self.yhVolumeViewController == nil)
    {
        self.yhVolumeViewController = [[YHVolumeViewController alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 414, 30.0f)];
        self.yhVolumeViewController.vCellSpace = 3.0f;
        self.yhVolumeViewController.hCellSpace = 3.0f;
        self.yhVolumeViewController.indicatorColor = [UIColor yellowColor];
        
        [self.videoPlayContainer addSubview:self.yhVolumeViewController.view];
    }
}
```
## Contact
If you find bug or have good idea, please pull reqeust me :
e-mail : maztaflex@nate.com

## License
YHViewController is available under the MIT license. See the LICENSE file for more info.

