//
//  GAViewController.m
//  AudioTest
//
//  Created by Dave Stitz on 3/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.


#import "GAViewController.h"
#import "Global.h"
#import "SVProgressHUD.h"
#import "UIImageView+AFNetworking.h"
#import "InviteFriendsController.h"
#import "MZUtility.h"
#import "MFSideMenuContainerViewController.h"
#import "RageIAPHelper.h"
#import <Social/Social.h>

@implementation GAViewController 
{
    int remainingTime;
    NSString *iUserID, *productPrice;
    NSURL *imgURLBGBlur, *urlInApp;
    NSArray *_products;
    NSMutableDictionary *dictData1;
    BOOL IsFromBuffering;
    __weak IBOutlet UIButton *btnDownload;
    __weak IBOutlet UILabel *lblDownlaodBadge;
}

@synthesize shareButton,shuffleButton,repeatButton,playButton,nextButton,previousButton,heartButton,addtolistButton,volumeButton,progressSlider,pauseButton,lblcurrentTime,lblduration,lineBar,separetor1,separetor2,separetor3,soundFiles,volumeSlider;

- (GAViewController *)initWithSoundFiles:(NSMutableArray *)songs atPath:(NSString *)path andSelectedIndex:(int)index andisLike:(NSNumber *)like
{
    if (self = [super init])
    {
        soundFiles = songs;
        selectedIndex = index;
        islike = (NSString *)like;
        
        if(IsOffline){
            NSURL* URL = [NSURL fileURLWithPath:path];
            [self setupAVPlayerForURL:URL];
        }else{
            
            imgURL = [NSURL URLWithString:path];
            [self setupAVPlayerForURL:[NSURL URLWithString:path]];
        }
    }
    return self;
}

#pragma mark - setupIslike
-(void)setupisLike:(NSString *)str{
    if([str isEqual: @"0"]){
        [heartButton setImage:[UIImage imageNamed:@"heart2.png"] forState:UIControlStateNormal];
    }else {
        [heartButton setImage:[UIImage imageNamed:@"Heart_Liked.png"] forState:UIControlStateNormal];
    }
}

#pragma mark - setupImageView
-(void)setupImgView:(NSURL *)strURL{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (IS_DEVICE_iPHONE_5)
        {
            UIGraphicsBeginImageContext(self.view.frame.size);
            [[UIImage imageWithData:[NSData dataWithContentsOfURL:strURL]]drawInRect:CGRectMake(-10, -10, 340, 500) ];
        }else{
            UIGraphicsBeginImageContext(self.view.frame.size);
            [[UIImage imageWithData:[NSData dataWithContentsOfURL:strURL]]drawInRect:CGRectMake(-10, -10, 340, 430) ];
        }
    });
}

#pragma mark - viewDidLoad
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    IsInAppBrowse = false;
    IsInAppHint = false;
    IsInAppMusic = true;
    [self reload];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
    [self updateDownloadingTabBadge];
    // lblDownlaodBadge.hidden = true;
    lblDownlaodBadge.layer.cornerRadius = 8.0;
    lblDownlaodBadge.layer.borderWidth=1.0;
    lblDownlaodBadge.layer.borderColor = [UIColor whiteColor].CGColor;
    // Setup Downloading View
    if(IsFromBrowseList == true){
        if(IsBuySong){
            btnDownload.enabled  = true;
            [btnDownload setImage:[UIImage imageNamed:@"buy-icon.png"] forState:UIControlStateNormal];
        }else{
            heartButton.enabled = false;
            btnDownload.enabled = false;
            [btnDownload setImage:[UIImage imageNamed:@"Download_disabled.png"] forState:UIControlStateNormal];
        }
    }else{
        btnDownload.enabled = true;
        
        heartButton.enabled = true;
        [btnDownload setImage:[UIImage imageNamed:@"Download.png"] forState:UIControlStateNormal];
    }
    appDelegate.objDownloadVC.delegate=self;
    if(appDelegate.objDownloadVC.downloadingArray == nil)
    {
        appDelegate.objDownloadVC.downloadingArray = [[NSMutableArray alloc] init];
    }
    appDelegate.objDownloadVC.sessionManager = [appDelegate.objDownloadVC backgroundSession];
    //[appDelegate.objDownloadVC populateOtherDownloadTasks];
    
    [volumeSlider removeFromSuperview];
    
    //All Dictionary
    dictAllData = [DictBrowselist valueForKey:@"getAllDataDict"];
    if(IsOffline){
        NSString *tempStr =  [soundFiles objectAtIndex:selectedIndex];
        TrackNm = [[tempStr stringByReplacingOccurrencesOfString:@".mp3" withString:@""] lastPathComponent];
    }
    else{
        TrackNm = [DictBrowselist valueForKey:@"userTrackName"];
    }
    ArtistNm = [DictBrowselist valueForKey:@"userArtistName"];
    isLikearr = [[DictBrowselist valueForKey:@"userisLike"] mutableCopy];
    musicID = [dictAllData valueForKey:@"iMusicID"];
    Music = [musicID objectAtIndex:selectedIndex];
    iUserID = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"SaveData"] valueForKey:@"iUserID"];
    
    [SVProgressHUD showWithStatus:kPleaseWait maskType:SVProgressHUDMaskTypeGradient];
    
    [self setupisLike:islike];
    if (IS_DEVICE_iPHONE_5)
    {
        activityView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        spinner.frame = CGRectMake(0, 30, 320, 460);
        playButton = [[UIButton alloc] initWithFrame: CGRectMake(130, 470, 60, 60)];
        pauseButton = [[UIButton alloc] initWithFrame:CGRectMake(130, 470, 60, 60)];
        UIGraphicsBeginImageContext(self.view.frame.size);
        imgURL = [NSURL URLWithString:[DictBrowselist valueForKey:@"userTrackImgBig"]];
        
        imgURLBGBlur = [NSURL URLWithString:[DictBrowselist valueForKey:@"userTrackImg"]];
        [self setupImgView:imgURLBGBlur];
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(45, 70, 230, 230)];
        newView = [[UIImageView alloc] initWithFrame:CGRectMake(-12, -15, 345, 500)];
        trackName = [[UILabel alloc] initWithFrame:CGRectMake(20, 300 , 280, 30)];
        artistName = [[UILabel alloc] initWithFrame:CGRectMake(85,335, 150, 20)];
    }
    else
    {
        spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        spinner.frame = CGRectMake(0, 30, 320, 460);
        
        pauseButton = [[UIButton alloc] initWithFrame:CGRectMake(130, 382, 60, 60)];
        
        imgURL = [NSURL URLWithString:[DictBrowselist valueForKey:@"userTrackImgBig"]];
        imgURLBGBlur = [NSURL URLWithString:[DictBrowselist valueForKey:@"userTrackImg"]];
        [self setupImgView:imgURLBGBlur];
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(45, 45, 230, 230)];
        newView = [[UIImageView alloc] initWithFrame:CGRectMake(-10, -10, 340, 400)];
        
        trackName = [[UILabel alloc] initWithFrame:CGRectMake(20, 275 , 280, 30)];
        
        artistName = [[UILabel alloc] initWithFrame:CGRectMake(85, 305 , 150, 20)];
    }
    
    UISwipeGestureRecognizer * swipeleft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeleft:)];
    swipeleft.direction=UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeleft];
    UISwipeGestureRecognizer * swiperight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swiperight:)];
    swiperight.direction=UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swiperight];
    
    [volumeSlider setThumbImage:[UIImage imageNamed:@"Thumb Image.png"] forState:UIControlStateNormal];
    [volumeSlider setMinimumTrackTintColor:[UIColor whiteColor]];
    [volumeSlider setMaximumTrackTintColor:UIColorFromHex(0x91F3F4)];
    [volumeSlider addTarget:self action:@selector(volumeSliderMoved:) forControlEvents:UIControlEventAllEvents];
    CGAffineTransform sliderRotation = CGAffineTransformIdentity;
    sliderRotation = CGAffineTransformRotate(sliderRotation, -(M_PI / 2));
    volumeSlider.transform = sliderRotation;
    
    //Volume BG View
    volumeBGview = [[UIView alloc] init];
    
    if ([[NSUserDefaults standardUserDefaults] floatForKey:@"PlayerVolume"])
        volumeSlider.value = [[NSUserDefaults standardUserDefaults] floatForKey:@"PlayerVolume"];
    else
        volumeSlider.value = player.volume;
    
    //progressBar
    [progressSlider setThumbImage:[UIImage imageNamed:@"Thumb Image.png"] forState:UIControlStateNormal];
    [progressSlider setMinimumTrackTintColor:[UIColor whiteColor]];
    [progressSlider setMaximumTrackTintColor:UIColorFromHex(0x91F3F4)];
    [lineBar setBackgroundColor:UIColorFromHex(0x91F3F4)];
    
    //Play Button
    [playButton setBackgroundImage:[UIImage imageNamed:@"Play.png"] forState:UIControlStateNormal];
    [playButton addTarget:self action:@selector(BtnPlay:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playButton];
    
    //pause Button
    [pauseButton setBackgroundImage:[UIImage imageNamed:@"Pause.png"] forState:UIControlStateNormal];
    [pauseButton addTarget:self action:@selector(BtnPause:) forControlEvents:UIControlEventTouchUpInside];
    
    //duration Time Label
    lblduration.font = timeDuration;
    lblduration.textColor = [UIColor whiteColor];
    
    //Curren Time Label
    lblcurrentTime.font = timeDuration
    lblcurrentTime.textColor = [UIColor whiteColor];
    lblduration.adjustsFontSizeToFitWidth = YES;
    lblcurrentTime.adjustsFontSizeToFitWidth = YES;
    
}
#pragma mark - In-App Purchase
- (void)reload {
    _products = nil;
    [[RageIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        if (success) {
            _products = nil;
            _products = products;
            //             for (SKProduct * skProduct in products) {
            //                [PriceInapp addObject:skProduct.price];
            //             }
        }
    }];
}
- (void)productPurchased:(NSNotification *)notification {
    if(IsInAppMusic){
        dispatch_async(dispatch_get_main_queue(), ^{
            [[ServerCalls sharedObject] executeRequest:urlInApp withData:reqData method:kPOST completionBlock:^(NSData *data, NSError *error){
                if (error)
                {
                    NSLog(@"ERROR!!");
                    DisplayAlert((NSString *)[error localizedDescription]);
                    [SVProgressHUD dismiss];
                }
                else if (data)
                {
                    NSDictionary *responseData = [data JSONValue];
                    BOOL Success = [[responseData valueForKey:@"SUCCESS"] boolValue];
                    if (Success)
                    {
                        ShowAlertWithTitle(@"Congratulation",@"you have purchased the Song Successfully. Now, you can go to Playlist screen to play purchased songs.",@"Ok");
                    }
                }
                
                [SVProgressHUD dismiss];
            }];
        });
    }
}
#pragma mark - viewDidAppear
-(void)viewDidAppear:(BOOL)animated{
    [SVProgressHUD showWithStatus:kPleaseWait maskType:SVProgressHUDMaskTypeGradient];
    if(IsOffline){
        if(soundFiles.count == 1)
        {
            previousButton.enabled = false;
            nextButton.enabled = false;
        }
        if(selectedIndex == 0)
        {
            previousButton.enabled =false;
        }
        else
        {
            if(selectedIndex == [soundFiles count]-1)
            {
                nextButton.enabled =false;
            }
        }
    }else{
        if(dictAllData.count == 1)
        {
            previousButton.enabled = false;
            nextButton.enabled = false;
        }
        if(selectedIndex == 0)
        {
            previousButton.enabled =false;
        }
        else
        {
            if(selectedIndex == [soundFiles count]-1)
            {
                nextButton.enabled =false;
            }
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if([[NSString stringWithFormat:@"%@", imgURL]   isEqual: @""] || imgURL == nil){
            imageView.image = [UIImage imageNamed:@"album-iocn.png"];
        }
        else{
            [imageView setImageWithURL:imgURL];
        }
        
        [SVProgressHUD showWithStatus:kPleaseWait maskType:SVProgressHUDMaskTypeGradient];
        
        //Blur ImageView
        UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        // self.view.backgroundColor = [UIColor colorWithPatternImage:viewImage];
        CIImage *imageToBlur = [CIImage imageWithCGImage:viewImage.CGImage];
        CIFilter *gaussianBlurFilter = [CIFilter filterWithName: @"CIGaussianBlur"];
        [gaussianBlurFilter setValue:imageToBlur forKey: @"inputImage"];
        [gaussianBlurFilter setValue:[NSNumber numberWithFloat: 5] forKey: @"inputRadius"];
        CIImage *resultImage = [gaussianBlurFilter valueForKey: @"outputImage"];
        UIImage *endImage = [[UIImage alloc] initWithCIImage:resultImage];
        
        //Place the UIImage in a UIImageView
        newView.image = endImage;
        [self.view insertSubview:newView belowSubview:self.view];
        
        //ImageView
        //imageView.image =[UIImage imageWithData:[NSData dataWithContentsOfURL:imgURL]];
        
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 113;
        imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        imageView.layer.borderWidth = 3.0f;
        
        //Track name label
        trackName.font = semiBoldFont20;
        if(TrackNm == nil || [TrackNm isEqualToString:@""]){
            NSString *strTrackNm = [soundFiles objectAtIndex:selectedIndex];
            [strTrackNm lastPathComponent];
            trackName.text = [[strTrackNm stringByReplacingOccurrencesOfString:@".mp3" withString:@""]lastPathComponent] ;
        }else{
            trackName.text = TrackNm;
        }
        
        //[trackName sizeToFit];
        trackName.textAlignment = NSTextAlignmentCenter;
        trackName.textColor = [UIColor whiteColor];
        
        //Artist name label
        artistName.font = semiLightFont16;
        artistName.text = ArtistNm;
        artistName.textAlignment = NSTextAlignmentCenter;
        artistName.textColor = [UIColor whiteColor];
        
        UIButton *LeftNavigationBtn = [[UIButton alloc]initWithFrame:CGRectMake(3, 13, 51, 45) ];
        [LeftNavigationBtn setImage:[UIImage imageNamed:@"Back_Btn.png"] forState:UIControlStateNormal];
        
        [LeftNavigationBtn addTarget:self action:@selector(leftbtn) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:LeftNavigationBtn];
        [self.view addSubview:trackName];
        [self.view addSubview:artistName];
        [self.view addSubview:imageView];
        [self setSlider];
    });
    if(IsFromPlaylist){
        if(IsOffline){
            btnDownload.enabled = false;
            heartButton.enabled = false;
        }
    }
    if ([MPNowPlayingInfoCenter class])
    {
        //  MPMediaItemArtwork *albumArt = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:imgURL]]];
        NSDictionary *dictCurrentlyPlaying = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:TrackNm,  nil] forKeys:[NSArray arrayWithObjects:MPMediaItemPropertyTitle,  nil]];
        [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = dictCurrentlyPlaying;
    }
}

#pragma mark - Navigation Buttons
-(void)leftbtn{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightbtn{
    NotificationController *notify = [[NotificationController alloc] initWithNibName:@"NotificationController" bundle:nil];
    
    SlideMenuView *leftSlideMenu = [[SlideMenuView alloc] initWithNibName:@"SlideMenuView" bundle:nil];
    
    MFSideMenuContainerViewController *container = [MFSideMenuContainerViewController
                                                    containerWithCenterViewController:notify
                                                    leftMenuViewController:leftSlideMenu
                                                    rightMenuViewController:nil];
    
    [self.navigationController pushViewController:container animated:YES];
}

#pragma mark - setupAVPlayerForURL
-(void) setupAVPlayerForURL: (NSURL*) url {
    //    [player pause];
    //    [anItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
    //    [anItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
    //    [[NSNotificationCenter defaultCenter]removeObserver:self];
    //    asset = nil;
    //    anItem = nil;
    //    player = nil;
    //    [player addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
    asset = [AVURLAsset URLAssetWithURL:url options:nil];
    anItem = [AVPlayerItem playerItemWithAsset:asset];
    player = [AVPlayer playerWithPlayerItem:anItem];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive: YES error: nil];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    //[player addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [anItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
    [anItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
    if(selectedIndex != soundFiles.count-1){
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(BtnNext:)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:[player currentItem]];
        
    }
    
}
- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    // If it is a remote control event handle it correctly
    if (event.type == UIEventTypeRemoteControl) {
        if (event.subtype == UIEventSubtypeRemoteControlPlay) {
            [player pause];
        } else if (event.subtype == UIEventSubtypeRemoteControlPause) {
            [player pause];
        } else if (event.subtype == UIEventSubtypeRemoteControlTogglePlayPause) {
            [player pause];
        }else if (event.subtype == UIEventSubtypeRemoteControlNextTrack){
            [self BtnNext:nil];
        }
        else if (event.subtype == UIEventSubtypeRemoteControlPreviousTrack) {
            [self BtnPrevious:nil];
        }
    }
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == player && [keyPath isEqualToString:@"status"]) {
        if (player.status == AVPlayerStatusFailed) {
            NSLog(@"AVPlayer Failed");
        } else if (player.status == AVPlayerStatusReadyToPlay) {
            NSLog(@"AVPlayer Ready to Play");
        } else if (player.status == AVPlayerItemStatusUnknown) {
            NSLog(@"AVPlayer Unknown");
        }
    }
    else if (object == anItem && [keyPath isEqualToString:@"playbackLikelyToKeepUp"])
    {
        if (anItem.playbackLikelyToKeepUp)
        {
            if(IsFromBuffering == true){
                NSLog(@"GOOD BUFFERING");
                [player play];
            }
        }
    }
    else if (object == anItem && [keyPath isEqualToString:@"playbackBufferEmpty"])
    {
        if (anItem.playbackBufferEmpty) {
            if(IsFromBuffering == true){
                NSLog(@"NOT BUFFERING");
            }
        }
    }
}

#pragma mark - Track Count WS
-(void)TrackCount{
    reqData = [NSMutableData data];
    reqData = [CommonMethods preparePostData:dictData];
    urlTrackCount = [NSURL URLWithString:[URLBase stringByAppendingString:@"ws/user/play_count/index/format/json"]];
    [[ServerCalls sharedObject] executeRequest:urlTrackCount withData:reqData method:kPOST completionBlock:^(NSData *data, NSError *error) {
        if (error)
        {
            NSLog(@"ERROR!!");
            DisplayAlert((NSString *)[error localizedDescription]);
            [SVProgressHUD dismiss];
        }
        else if (data)
        {
            NSDictionary *responseData = [data JSONValue];
            BOOL Success = [[responseData valueForKey:@"SUCCESS"] boolValue];
            if (Success)
            {
            }
        }
    }];
}

#pragma mark - Swipe Gesture
-(void)swipeleft:(UISwipeGestureRecognizer*)gestureRecognizer
{
    if(selectedIndex != [soundFiles count]-1)
    {
        [self BtnNext:nil];
    }
}

-(void)swiperight:(UISwipeGestureRecognizer*)gestureRecognizer
{
    if(selectedIndex != 0)
    {
        [self BtnPrevious:nil];
    }
}
#pragma mark - MZDownloadManager Delegates
- (void)updateDownloadingTabBadge
{
    lblDownlaodBadge.alpha = 0.0 ;
    int badgeCount = (int)appDelegate.objDownloadVC.downloadingArray.count;
    if(badgeCount == 0)
        lblDownlaodBadge.hidden = true;
    else
        [UIView animateWithDuration:0.3
                              delay:0.0
                            options:UIViewAnimationOptionTransitionCrossDissolve
                         animations:^{
                             lblDownlaodBadge.alpha = 1.0;
                         }
                         completion:^(BOOL finished) {
                         }];
    lblDownlaodBadge.hidden = false;
    [lblDownlaodBadge setText:[NSString stringWithFormat:@"%d",badgeCount]];
}
-(void)downloadRequestStarted:(NSURLSessionDownloadTask *)downloadTask
{
    [self updateDownloadingTabBadge];
}
-(void)downloadRequestFinished:(NSString *)fileName
{
    [self updateDownloadingTabBadge];
    NSString *docDirectoryPath = [fileDest stringByAppendingPathComponent:fileName];
    [[NSNotificationCenter defaultCenter] postNotificationName:DownloadCompletedNotif object:docDirectoryPath];
}
-(void)downloadRequestCanceled:(NSURLSessionDownloadTask *)downloadTask
{
    [self updateDownloadingTabBadge];
}
#pragma mark - Downlaod Button
- (IBAction)btnDownload_Click:(id)sender {
    if(IsBuySong){
        [SVProgressHUD showWithStatus:kPleaseWait maskType:SVProgressHUDMaskTypeGradient];
        SKProduct *product;
        NSString *strSendMail;
        strSendMail = [musicID objectAtIndex:selectedIndex];
        
        product = (SKProduct *)[_products objectAtIndex:0];
        productPrice = @"0.99";
        
        [[RageIAPHelper sharedInstance] buyProduct:product];
        
        dictData1 = [[NSMutableDictionary alloc] init];
        dictData1 = [NSMutableDictionary dictionaryWithObjects:@[strSendMail,@"InApp",@"Purchase from IOS",@"0",@"0",productPrice] forKeys:@[@"iMusicID",@"vType",@"tComment",@"from_game",@"other_userid",@"dAmount"]];
        
        reqData = [NSMutableData data];
        reqData = [CommonMethods preparePostData:dictData1];
        
        urlInApp = [NSURL URLWithString:[URLBase stringByAppendingString:@"ws/user/purchase/index/format/json"]];
    }
    else
    {
        NSString *fileName = [MZUtility getUniqueFileNameForName:[TrackNm stringByAppendingString:@".mp3"]];
        [appDelegate.objDownloadVC addDownloadTask:fileName fileURL:[soundFiles objectAtIndex:selectedIndex]];
    }
}

#pragma mark - Play Button Click
-(IBAction) BtnPlay:(id)sender {
    [player play];
    [playButton removeFromSuperview];
    [self.view addSubview:pauseButton];
    if(IsFromPlaylist){
        dictData = [NSMutableDictionary dictionaryWithObjects:@[Music,iUserID] forKeys:@[@"iMusicID",@"iUserID"]];
        [self TrackCount];
    }
    IsFromBuffering = true;
}

#pragma mark - Pause Bustton Click
-(IBAction) BtnPause:(id)sender {
    [player pause];
    [pauseButton removeFromSuperview];
    /*if(IS_DEVICE_iPHONE_5){
     playButton.frame =  CGRectMake(130, 470, 60, 60);
     }else{
     playButton.frame =  CGRectMake(130, 370, 60, 60);
     }*/
    [self.view addSubview:playButton];
    IsFromBuffering = false;
}

#pragma mark - Set the Progress Bar
-(void)setSlider{
    sliderTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self  selector:@selector(updateSlider) userInfo:nil repeats:YES];
    progressSlider.maximumValue = [self durationInSeconds];
    progressSlider.minimumValue = 0.0;
    progressSlider.continuous = YES;
    
}
- (void)updateSlider {
    progressSlider.maximumValue = [self durationInSeconds];
    progressSlider.value = [self currentTimeInSeconds];
    if(remainingTime==0){
        [volumeBGview removeFromSuperview];
        [volumeSlider removeFromSuperview];
    }else{
        remainingTime--;
    }
}
#pragma mark - Progress Slider Move
-(IBAction)sliding:(id)sender{
    CMTime newTime = CMTimeMakeWithSeconds(progressSlider.value, 1);
    [player seekToTime:newTime];
}

#pragma mark - Duration Time lbl
- (int)durationInSeconds {
    int dur = CMTimeGetSeconds(asset.duration);
    int current = CMTimeGetSeconds([player currentTime]);
    lblduration.text = [NSString stringWithFormat:@"-%d:%02d",(int)((int)(dur - current)) / 60, (int)((int)(dur - current)) % 60];
    return dur;
}

#pragma mark - Current Time lbl
- (int)currentTimeInSeconds {
    [SVProgressHUD dismiss];
    int dur = CMTimeGetSeconds([player currentTime]);
    lblcurrentTime.text = [NSString stringWithFormat:@"%d:%02d",(int)dur / 60, (int)dur % 60];
    return dur;
}

#pragma mark - Shuffle Button Click
- (IBAction)BtnShuffle:(id)sender {
    if (shuffle)
    {
        shuffle = NO;
        [shuffleButton setImage:[UIImage imageNamed:@"shuffle.png"] forState:UIControlStateNormal];
    }
    else
    {
        shuffle = YES;
        
        [shuffleButton setImage:[UIImage imageNamed:@"shuffle_selected.png"] forState:UIControlStateNormal];
        
    }
}
#pragma mark - Repeat Button Click
- (IBAction)BtnRepeat_Click:(id)sender {
    if (repeatOne)
    {
        repeatOne = NO;
        [repeatButton setImage:[UIImage imageNamed:@"repeat_selected.png"] forState:UIControlStateNormal];
    }
    else
    {
        repeatOne = YES;
        [repeatButton setImage:[UIImage imageNamed:@"Repeat.png"] forState:UIControlStateNormal];
    }
}

#pragma mark - NextTrack Button Click
- (IBAction)BtnNext:(id)sender {
    
    [SVProgressHUD showWithStatus:kPleaseWait maskType:SVProgressHUDMaskTypeGradient];
    previousButton.enabled = true;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // NSUInteger newIndex;
        [player pause];
        if (repeatOne)
        {
            selectedIndex = selectedIndex;
        }
        else if (shuffle)
        {
            selectedIndex = rand() % [soundFiles count];
        }
        else
        {
            selectedIndex = selectedIndex + 1;
        }
        if (selectedIndex == [self.soundFiles count])
        {
            if(IsOffline)
            {
                nextsong = [NSURL fileURLWithPath:[soundFiles objectAtIndex:selectedIndex]];
            }
            else
            {
                nextsong = [NSURL URLWithString:[soundFiles objectAtIndex:selectedIndex]];
            }
            nextButton.enabled =false;
        }else
        {
            if(IsOffline)
            {
                nextsong = [NSURL fileURLWithPath:[soundFiles objectAtIndex:selectedIndex]];
            }
            else
            {
                nextsong = [NSURL URLWithString:[soundFiles objectAtIndex:selectedIndex]];
            }
            
        }
        player.volume = volumeSlider.value;
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        // [player removeObserver:self forKeyPath:@"status"];
        [anItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
        [anItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [self updateViewForPlayerState:nextsong];
            newData = [dictAllData objectAtIndex:selectedIndex];
            imgURLBGBlur= [NSURL URLWithString:[newData valueForKeyPath:@"bigthumbmusic"]];
            [self setupImgView:imgURLBGBlur];
            TrackNm = [newData valueForKeyPath:@"vMusicname"];
            ArtistNm = [newData valueForKeyPath:@"artistname"];
            Music = [musicID objectAtIndex:selectedIndex];
            imgURL= [NSURL URLWithString:[newData valueForKeyPath:@"compressthumbmusic"]];
            [self viewDidAppear:YES];
        });
    });
    
}

#pragma mark - Previous Track
- (IBAction)BtnPrevious:(id)sender {
    nextButton.enabled = true;
    [SVProgressHUD showWithStatus:kPleaseWait maskType:SVProgressHUDMaskTypeGradient];
    // [player removeObserver:self forKeyPath:@"status"];
    [anItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
    [anItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
    [player pause];
    
    selectedIndex=selectedIndex - 1;
    
    if(selectedIndex == 0){
        if(IsOffline)
        {
            nextsong = [NSURL fileURLWithPath:[soundFiles objectAtIndex:selectedIndex]];
        }
        else
        {
            nextsong = [NSURL URLWithString:[soundFiles objectAtIndex:selectedIndex]];
        }
        previousButton.enabled=false;
        nextButton.enabled=true;
    }else{
        if(IsOffline)
        {
            nextsong = [NSURL fileURLWithPath:[soundFiles objectAtIndex:selectedIndex]];
        }
        else
        {
            nextsong = [NSURL URLWithString:[soundFiles objectAtIndex:selectedIndex]];
        }
    }
    player.volume = volumeSlider.value;
    [self updateViewForPlayerState:nextsong];
    newData = [dictAllData objectAtIndex:selectedIndex];
    imgURL= [NSURL URLWithString:[newData valueForKeyPath:@"compressthumbmusic"]];
    [self setupImgView:imgURL];
    TrackNm = [newData valueForKeyPath:@"vMusicname"];
    ArtistNm = [newData valueForKeyPath:@"artistname"];
    Music = [musicID objectAtIndex:selectedIndex];
    [self viewDidAppear:YES];
}

#pragma mark - Update Player Information
-(void)updateViewForPlayerState:(NSURL *)songURL{
    islike = [isLikearr objectAtIndex:selectedIndex];
    [self setupisLike:islike];
    [self setupAVPlayerForURL:songURL];
    [self BtnPlay:nil];
}

#pragma mark - Volume button
- (IBAction)BtnVolume:(id)sender {
    
    volumeBGview.frame = CGRectMake(283, 500, 30, 250);
    volumeSlider.frame = CGRectMake(283, 500, 30, 215);
    
    volumeSlider.alpha = 0.0;
    volumeBGview.alpha = 0.0;
    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionTransitionCrossDissolve
                     animations:^{
                         volumeBGview.alpha = 0.6;
                         volumeSlider.alpha = 1.0;
                         
                         CGRect frame = volumeSlider.frame;
                         frame.origin.y = 93; volumeSlider.frame = frame;
                         frame.origin.y = 85; frame.size.height=230; volumeBGview.frame = frame;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
    volumeBGview.backgroundColor = [UIColor grayColor];
    [self.view addSubview:volumeBGview];
    volumeBGview.layer.cornerRadius = 5.0;
    remainingTime = 5;
    [self.view addSubview:volumeSlider];
}

#pragma mark - Like Button WS
- (IBAction)BtnLike:(id)sender
{
    dictData = [NSMutableDictionary dictionaryWithObjects:@[Music] forKeys:@[@"iMusicID"]];
    [SVProgressHUD showWithStatus:kPleaseWait maskType:SVProgressHUDMaskTypeGradient];
    reqData = [NSMutableData data];
    reqData = [CommonMethods preparePostData:dictData];
    urlFavourite = [NSURL URLWithString:[URLBase stringByAppendingString:@"ws/user/like/index/format/json"]];
    
    [[ServerCalls sharedObject] executeRequest:urlFavourite withData:reqData method:kPOST completionBlock:^(NSData *data, NSError *error) {
        if (error)
        {
            NSLog(@"ERROR!!");
            DisplayAlert((NSString *)[error localizedDescription]);
            [SVProgressHUD dismiss];
        }
        else if (data)
        {
            NSDictionary *responseData = [data JSONValue];
            BOOL Success = [[responseData valueForKey:@"SUCCESS"] boolValue];
            if (Success)
            {
                islike = [isLikearr objectAtIndex:selectedIndex];
                if([islike  isEqual: @"0"]){
                    islike = @"1";
                    isLikearr [selectedIndex] = islike;
                }else{
                    islike = @"0";
                    isLikearr [selectedIndex] = islike;
                }
                [self setupisLike:islike];
            }
        }[SVProgressHUD dismiss];
    }];
}

#pragma mark - Volume SLider Move
- (void)volumeSliderMoved:(UISlider *)sender
{
    player.volume = [sender value];
    [[NSUserDefaults standardUserDefaults] setFloat:[sender value] forKey:@"PlayerVolume"];
    remainingTime = 5;
}

#pragma mark - Button Share Click
- (IBAction)btnShare_Click:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Social Sharing" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles: @"Facebook", @"Twitter",nil];
    [actionSheet showInView:self.view];
}
#pragma mark - ActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 0){
        [self shareViaFB:[[[[NSUserDefaults standardUserDefaults] valueForKey:@"userName"] stringByAppendingString:@" is listening "]stringByAppendingString:[TrackNm stringByAppendingString:@" YouSounds Online music store."]] appLink:@"www.yousounds.com"];
    }else if(buttonIndex == 1){
        [self shareViaTwitter:[[[[NSUserDefaults standardUserDefaults] valueForKey:@"userName"] stringByAppendingString:@" is listening "]stringByAppendingString:[TrackNm stringByAppendingString:@" YouSounds Online music store."]] appLink:@"www.yousounds.com"];
    }
}
#pragma mark - Shareing FB
-(void)shareViaFB:(NSString*)text1 appLink:(NSString*)link {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        SLComposeViewController *shareSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeFacebook];
        [shareSheet setCompletionHandler:^(SLComposeViewControllerResult result)
         {
             switch(result){
                 case SLComposeViewControllerResultCancelled:
                 default:
                 {
                     NSLog(@"Cancelled.....");
                     
                 }
                     break;
                 case SLComposeViewControllerResultDone:
                 {
                     NSLog(@"Posted....");
                 }
                     break;
             }
         }];
        
        [shareSheet setInitialText:text1];
        [shareSheet addURL:[NSURL URLWithString:link]];
        [self presentViewController:shareSheet animated:YES completion:nil];
    }else{
        DisplayAlert(@"Please add facebook account from settings");
    }
}

#pragma mark - Shareing Twitter
-(void)shareViaTwitter:(NSString*)text1 appLink:(NSString*)link {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *shareSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        [shareSheet setCompletionHandler:^(SLComposeViewControllerResult result)
         {
             switch(result){
                 case SLComposeViewControllerResultCancelled:
                 default:
                 {
                     NSLog(@"Cancelled.....");
                     
                 }
                     break;
                 case SLComposeViewControllerResultDone:
                 {
                     NSLog(@"Posted....");
                 }
                     break;
             }
         }];
        
        [shareSheet setInitialText:text1];
        [shareSheet addURL:[NSURL URLWithString:link]];
        [self presentViewController:shareSheet animated:YES completion:nil];
    }else{
        DisplayAlert(@"Please add twitter accounts from settings");
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 101){
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
