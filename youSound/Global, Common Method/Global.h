//
//  Global.h
//  youSound
//
//  Created by Akash on 6/12/14.
//  Copyright (c) 2014 Akash. All rights reserved.
//

#ifndef youSound_Global_h
#define youSound_Global_h


#define RateiOSAppStoreURLFormat @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@"
#define APP_ID @"897393757" // Rate Us On App Store
#define RateiOS7AppStoreURLFormat @"itms-apps://itunes.apple.com/app/id%@"

#pragma mark - ColorCode

#define UIColorFromHex(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define DarkColor (UIColorFromHex(0x3d3d3d))
#define LiteColor (UIColorFromHex(0x949494))
#define SemiBlueColor (UIColorFromHex(0x00c9d6))
#define RoundCorner (UIColorFromHex(0xEEE9E9))
#define privacyPolivy (UIColorFromHex(0x017DFD))
#define pickerBorderColor (UIColorFromHex(0x4EC5E8))


#pragma mark - Iphone5
#define IS_DEVICE_iPHONE_5 ((UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) && ([[UIScreen mainScreen ] bounds].size.height>=568.0f))

#pragma mark - Font
#define semiLightFont16 [UIFont fontWithName:@"OpenSans-Light" size:16];
#define semiLightFontsize15 [UIFont fontWithName:@"OpenSans-Light" size:15];
#define semiLightFontsize14 [UIFont fontWithName:@"OpenSans-Light" size:14];
#define subtitleSemiLightFont [UIFont fontWithName:@"OpenSans-Light" size:13];
#define CommonText [UIFont fontWithName:@"OpenSans-Semibold" size:10];
#define lblPrivacyPolicy [UIFont fontWithName:@"OpenSans-Semibold" size:11];
#define timeDuration [UIFont fontWithName:@"OpenSans-Semibold" size:13];
#define lableHeader [UIFont fontWithName:@"OpenSans-Semibold" size:16];
#define semiBoldFont18 [UIFont fontWithName:@"OpenSans-Semibold" size:18];
#define semiBoldFont20 [UIFont fontWithName:@"OpenSans-Semibold" size:20];

#define PRINT               0

#pragma mark - Padding View
#define paddinglogintext [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 25)];
#define paddingSimpletext [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 25)];

#pragma mark - Lable Alloc
#define trackNamelbl [[UILabel alloc] initWithFrame:CGRectMake(80, 6, 200, 30)];
#define byArtistlbl [[UILabel alloc] initWithFrame:CGRectMake(90, 27, 200, 30)];
#define timerlbl [[UILabel alloc] initWithFrame:CGRectMake(289, 15, 30, 15)];
#define pricelbl [[UILabel alloc] initWithFrame:CGRectMake(289, 32, 30, 15)];

#pragma mark - USerDefault
#define userDefault NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];

#pragma  mark - HTTP Request
// HTTPRequest Constants
#define kDefultTimeOut      120.0f
#define kPOST               @"POST"
#define KPUT                @"PUT"
#define kGET                @"GET"
#define kOK                 @"OK"
#define kCancel             @"CANCEL"
#define kTripMatcher        @"YouSounds"
#define kMessage            @"message"
#define kError              @"Error"
#define kPleaseWait         @"Please Wait..."

#pragma mark - AlertALl

#define ShowAlert( msg ) \
{\
UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kTripMatcher message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];\
[alert show];\
alert.tag=103;\
}

#define ShowAlertWithTitle( title, msg, canceltitle) \
{\
UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:canceltitle otherButtonTitles:nil, nil];\
[alert show];\
alert.tag=101;\
}

#define AlertWithTitle( title, msg, canceltitle) \
{\
UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:canceltitle otherButtonTitles:@"OK", nil];\
[alert show];\
alert.tag=103;\
}

#define DisplayAlert(msg) \
{\
UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"YouSounds"  message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]; \
[alertView show];\
alertView.tag=102;\
}

#pragma mark - CellDetail
#define CellDetails {\
cell.HintTrackName.font = semiLightFont16; \
cell.HintTrackName.textColor = DarkColor; \
cell.HintArtistName.font = subtitleSemiLightFont; \
cell.HintArtistName.textColor = LiteColor; \
cell.HintlblPrice.font = subtitleSemiLightFont; \
cell.HintlblPrice.textColor = LiteColor; \
cell.HintlblDuration.font = subtitleSemiLightFont; \
cell.HintlblDuration.textColor = LiteColor; \
}

#define IS_DEVICE_iPHONE_5 ((UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) && ([[UIScreen mainScreen ] bounds].size.height>=568.0f))
#define iOS7 (([[UIDevice currentDevice].systemVersion floatValue]>=7.0)?20:0)


#endif
