/*
 Copyright (C) 2015 Sonar Systems - All Rights Reserved
 You may use, distribute and modify this code under the
 terms of the MIT license
 
 Any external frameworks used have their own licenses and
 should be followed as such.
 */
//
//  IOSHelper.h
//  Sonar Cocos Helper
//
//  Created by Sonar Systems on 03/03/2015.
//
//

#import "SCHDefinitions.h"

#import "SCHSettings.h"

#import <Foundation/Foundation.h>
#import "AppController.h"

#if SCH_IS_AD_MOB_ENABLED == true
    #import <GoogleMobileAds/GoogleMobileAds.h>
#endif

#if SCH_IS_AD_FACEBOOK_ENABLED == true
#import <FBAudienceNetwork/FBAudienceNetwork.h>
#endif

#if SCH_IS_GOOGLE_ANALYTICS_ENABLED == true
    #import <GAI.h>
    #import <GAIDictionaryBuilder.h>
    #import <GAIEcommerceProduct.h>
    #import <GAIEcommerceProductAction.h>
    #import <GAIEcommercePromotion.h>
    #import <GAIFields.h>
    #import <GAILogger.h>
    #import <GAITrackedViewController.h>
    #import <GAITracker.h>
    #import <GAIEcommerceFields.h>
    #import <GAITrackedViewController.h>
#endif

@protocol SCHEmptyProtocol
@end

@interface IOSHelper : NSObject
<
SCHEmptyProtocol
#if SCH_IS_SOCIAL_ENABLED == true
, UIPopoverControllerDelegate
#endif

#if SCH_IS_AD_MOB_ENABLED == true
, GADInterstitialDelegate
#endif

>
{
    AppController *appController;
    UIView *view;
    UIViewController *viewController;
    RootViewController *localViewController;
    
#if SCH_IS_GOOGLE_ANALYTICS_ENABLED == true
    id<GAITracker> tracker;
#endif
    
#if SCH_IS_AD_MOB_ENABLED == true
    GADInterstitial *adMobInterstitial;
    GADBannerView *adMobBottomBanner;
    GADBannerView *adMobTopBanner;
    BOOL isAdMobFullscreenLoaded;
    BOOL isAdMobBottomBannerDisplayed;
    BOOL isAdMobTopBannerDisplayed;
#endif
    
#if SCH_IS_AD_FACEBOOK_ENABLED == true
    int _native_left_distance;
    int _native_right_distance;
    int _native_top_distance;
    int _native_bottom_distance;
    int _native_width_size;
    int _native_height_size;
    
    FBInterstitialAd* facebookInterstitial;
    FBAdView* facebookBannerTop;
    FBAdView* facebookBannerBottom;
    FBNativeAd* facebookNative;
    BOOL isNeedShowInterstitial;
#endif
}

@property (nonatomic, strong) UIPopoverController *popover;

+( id )instance;

-( void )initialise;

+ (UIViewController *)getCurrentRootViewController;

#if SCH_IS_SOCIAL_ENABLED == true
-( void )shareViaTwitter:( NSString * ) message: ( NSString * ) imagePath;
-( void )facebookShareLink:(NSString*) title :(NSString*) linkApp :(NSString*) linkImage :(NSString*) desciption :(NSString*) quote :(NSString*) hashtag;
-( void )facebookShareImage:(NSString*) imagePathLocal :(NSString*) caption :(NSString*) hashTag;
-( void )facebookInviteFriends:(NSString*) linkApp :(NSString*) linkImage :(NSString*)promotionText :(NSString*)promotionCode;
#endif

#if SCH_IS_GAME_CENTER_ENABLED == true
@property ( nonatomic ) BOOL gameCenterEnabled;
@property ( nonatomic, copy ) NSString *leaderboardIdentifier;

-( void )gameCenterLogin;
-( void )gameCenterShowLeaderboard;
-( void )gameCenterShowAchievements;
-( void )gameCenterSubmitScore:( int )scoreNumber andLeaderboard: ( NSString * )leaderboardID;
-( void )gameCenterUnlockAchievement:( NSString * )achievementID andPercentage:( float )percent;
-( void )gameCenterResetPlayerAchievements;
#endif

#if SCH_IS_AD_MOB_ENABLED == true
-( void )admobRequestFullScreenAd;
-( void )admobShowBanner:( int ) position;
-( void )admobHideBanner:( int ) position;
-( void )admobShowFullscreenAd;
#endif

#if SCH_IS_GOOGLE_ANALYTICS_ENABLED == true
-( void )setGAScreenName:( NSString * )screenString;
-( void )setGADispatchInterval:( int )dispatchInterval;
-( void )sendGAEvent:( NSString * ) category: ( NSString * ) action: ( NSString * ) label: ( NSNumber * ) value;
#endif

#if SCH_IS_NOTIFICATIONS_ENABLED == true
-( void )scheduleLocalNotification:( NSTimeInterval )delay andNotificationText:( NSString * )textToDisplay andNotificationTitle:( NSString * )notificationTitle addNotificationTag:( int ) notificationTag;
-( void )scheduleLocalNotification:( NSTimeInterval )delay andNotificationText:( NSString * )textToDisplay andNotificationTitle:( NSString * )notificationTitle andNotificationAction:( NSString * )notificationAction addNotificationTag:( int ) notificationTag;
-( void )scheduleLocalNotification:( NSTimeInterval )delay andNotificationText:( NSString * )textToDisplay andNotificationTitle:( NSString * )notificationTitle andRepeatInterval:( int )repeatInterval addNotificationTag:( int ) notificationTag;
-( void )scheduleLocalNotification:( NSTimeInterval )delay andNotificationText:( NSString * )textToDisplay andNotificationTitle:( NSString * )notificationTitle andNotificationAction:( NSString * )notificationAction andRepeatInterval:( int )repeatInterval addNotificationTag:( int ) notificationTag;
-( void )unscheduleAllLocalNotifications;
-( void )unscheduleLocalNotification:( int )notificationTag;
#endif

#if SCH_IS_AD_FACEBOOK_ENABLED == true
@property (strong, nonatomic) IBOutlet UIView *facebookNativeAdView;
@property (retain, nonatomic) IBOutlet UILabel *fbNative_adTitleLabel;
@property (retain, nonatomic) IBOutlet FBMediaView *fbNative_adCoverMediaView;
@property (retain, nonatomic) IBOutlet UILabel *fbNative_adSocialContextLabel;
@property (retain, nonatomic) IBOutlet UIButton *fbNative_adCallToActionButton;
@property (retain, nonatomic) IBOutlet FBAdChoicesView *fbNative_adChoicesView;
@property (retain, nonatomic) IBOutlet UILabel *fbNative_adBodyLabel;
@property (retain, nonatomic) IBOutlet UILabel *fbNative_sponsoredLabel;
@property (retain, nonatomic) IBOutlet UIImageView *fbNative_adIconImageView;

-( void )facebookShowBannerAds:( int ) position;
-( void )facebookHideBannerAds:( int ) position;

-( void )facebookPreloadFullscreenAds;
-( void )facebookShowPreloadedFullscreenAds;

-( void )facebookPreloadNativeAds:( int ) left left_distance: ( int ) top top_distance: ( int ) right right_distance: ( int ) bottom bottom_distance: ( int ) size_width;
-( void )facebookShowNativeAds;
-( void )facebookHideNativeAds;
#endif

@end
