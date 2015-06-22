//
//  GAViewController.h
//  AudioTest
//
//  Created by Dave Stitz on 3/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AudioToolbox/AudioToolbox.h>
#import "NotificationController.h"
#import "SlideMenuView.h"
#import "MFSideMenuContainerViewController.h"
#import "MFSideMenu.h"
#import "CommonMethods.h"
#import "ServerCalls.h"
#import "NSObject+SBJson.h"
#import "MZDownloadManagerViewController.h"
#import <AudioToolbox/AudioToolbox.h>

@interface GAViewController : UIViewController<MZDownloadDelegate,AVAudioPlayerDelegate,AVAudioSessionDelegate,UIActionSheetDelegate>
{
  //  AVPlayer *player;
    AVPlayerItem *anItem;
    AVAsset *asset;
	NSTimer *playbackTimer;
    UIView *activityView;
    UIActivityIndicatorView *spinner;
    UIImageView *imageView,*newView;
    NSTimer	*sliderTimer;
    NSUInteger	selectedIndex;
    NSString *islike;
    NSMutableArray *isLikearr,*musicID;
    NSURL *nextsong,*imgURL,*urlFetchtrack,*urlTrackCount;
    UIView *volumeBGview;
    NSMutableArray *dictAllData,*newData;
    NSString *ArtistNm, *Music;
    UILabel *artistName, *trackName;
   
    BOOL interrupted;
	BOOL repeatOne;
	BOOL shuffle;
    
    NSMutableDictionary  *dictData;
    NSMutableData *reqData;
    NSURL *urlFavourite;
}
@property (nonatomic, strong) NSMutableArray *soundFiles;
@property (retain, nonatomic) IBOutlet UIButton *pauseButton;
@property (retain, nonatomic) IBOutlet UIButton *playButton;
@property (retain, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIButton *previousButton;
@property (weak, nonatomic) IBOutlet UIButton *repeatButton;
@property (weak, nonatomic) IBOutlet UIButton *shuffleButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *heartButton;
@property (weak, nonatomic) IBOutlet UIButton *addtolistButton;
@property (weak, nonatomic) IBOutlet UIButton *volumeButton;
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
@property (retain, nonatomic) IBOutlet UISlider *volumeSlider;
@property (weak, nonatomic) IBOutlet UILabel *lblduration;
@property (weak, nonatomic) IBOutlet UILabel *lblcurrentTime;
@property (weak, nonatomic) IBOutlet UIImageView *lineBar;
@property (weak, nonatomic) IBOutlet UIImageView *separetor1;
@property (weak, nonatomic) IBOutlet UIImageView *separetor2;
@property (weak, nonatomic) IBOutlet UIImageView *separetor3;

-(GAViewController *)initWithSoundFiles:(NSMutableArray *)songs atPath:(NSString *)path andSelectedIndex:(int)index andisLike:(NSNumber *)like;

- (IBAction)BtnPrevious:(id)sender;
- (IBAction)BtnPlay:(id)sender;
- (IBAction) BtnPause:(id)sender;
- (IBAction)BtnNext:(id)sender;
- (IBAction)BtnShuffle:(id)sender;
- (IBAction)BtnVolume:(id)sender;
- (IBAction)BtnLike:(id)sender;
- (IBAction)BtnRepeat_Click:(id)sender;
-(void) setupAVPlayerForURL: (NSURL*) url;

@end
