/*
 Copyright (C) 2015 Sonar Systems - All Rights Reserved
 You may use, distribute and modify this code under the
 terms of the MIT license
 
 Any external frameworks used have their own licenses and
 should be followed as such.
 */
//
//  IOSHelper.m
//  Sonar Cocos Helper
//
//  Created by Sonar Systems on 03/03/2015.
//

#import <UIKit/UIKit.h>
#import "IOSHelper.h"
#import "AppController.h"
#import "RootViewController.h"

#if SCH_IS_GAME_CENTER_ENABLED == true
    #import <Social/Social.h>
#endif

#if SCH_IS_SOCIAL_ENABLED == true
    #import <Social/Social.h>
    #import <FBSDKShareKit/FBSDKShareKit.h>
#endif

#if SCH_IS_GAME_CENTER_ENABLED == true
    #import <GameKit/GameKit.h>
#endif

@interface IOSHelper ( )
<
SCHEmptyProtocol
#if SCH_IS_GAME_CENTER_ENABLED == true
    , GKGameCenterControllerDelegate
#endif

#if SCH_IS_AD_MOB_ENABLED == true
    , GADInterstitialDelegate
#endif
>

@end

@implementation IOSHelper
{
}

+( id )instance
{
    static dispatch_once_t onceToken;
    static IOSHelper *__helper;
    dispatch_once( &onceToken,
    ^{
        __helper = [[IOSHelper alloc] init];
    } );
    
    return __helper;
}

// initialise the Network Framework to setup external frameworks
-( void )initialise
{    
    appController = ( AppController * )[[UIApplication sharedApplication] delegate];
    
#if COCOS2D_JAVASCRIPT
    localViewController = appController->viewController;
    view = appController->viewController.view;
    viewController = appController->viewController->presentedViewController;
    
#else
    localViewController = appController.viewController;
    view = appController.viewController.view;
    viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
#endif
    
#if SCH_IS_GOOGLE_ANALYTICS_ENABLED == true
    // Optional: automatically send uncaught exceptions to Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = SCH_GOOGLE_ANALYTICS_DEFAULT_DISPATCH_TIME;
    
    // Optional: set Logger to VERBOSE for debug information.
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
    
    // Initialize tracker. Replace with your tracking ID.
    [[GAI sharedInstance] trackerWithTrackingId:SCH_GOOGLE_ANALYTICS_TRACKING_ID];
    
    tracker = [[GAI sharedInstance] defaultTracker];
    
    // Enable IDFA collection.
    tracker.allowIDFACollection = YES;
#endif

#if SCH_IS_AD_MOB_ENABLED == true
    isAdMobFullscreenLoaded = false;
    isAdMobTopBannerDisplayed = false;
    isAdMobBottomBannerDisplayed = false;
    
    [self admobRequestFullScreenAd];
#endif
 
#if SCH_IS_NOTIFICATIONS_ENABLED == true
    UIApplication *app = [UIApplication sharedApplication];
    if ( [[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        if ( [UIApplication instancesRespondToSelector:@selector( registerUserNotificationSettings: )] ){ [app registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeSound categories:nil]]; }
    }
    
    NSArray *oldNotifications = [app scheduledLocalNotifications];
    
    if ( [oldNotifications count] > 0 )
    { [app cancelAllLocalNotifications]; }
#endif
    
#if SCH_IS_AD_FACEBOOK_ENABLED == true
    facebookInterstitial = nil;
    facebookBannerBottom = nil;
    facebookBannerTop = nil;
    facebookNative = nil;
    _facebookNativeAdView = nil;
    isNeedShowInterstitial = false;
    [FBAdSettings setLogLevel:FBAdLogLevelLog];
    [FBAdSettings addTestDevice:SCH_TEST_DEVICE];
#endif
}

+ (UIViewController *)getCurrentRootViewController {
    
    UIViewController *result = nil;
    
    // Try to find the root view controller programmically
    
    // Find the top window (that is not an alert view or other window)
    UIWindow *topWindow = [[UIApplication sharedApplication] keyWindow];
    if (topWindow.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(topWindow in windows)
        {
            if (topWindow.windowLevel == UIWindowLevelNormal)
                break;
        }
    }
    
    UIView *rootView = [[topWindow subviews] objectAtIndex:0];
    id nextResponder = [rootView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else if ([topWindow respondsToSelector:@selector(rootViewController)] && topWindow.rootViewController != nil)
        result = topWindow.rootViewController;
    else
        NSAssert(NO, @"Could not find a root view controller.");
    
    return result;
}

#if SCH_IS_SOCIAL_ENABLED == true
// share to twitter (requires the message to be sent and the image path, both of which can be empty strings)
-( void )shareViaTwitter: ( NSString * ) message: ( NSString * ) imagePath
{
    SLComposeViewController *slVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [slVC addImage:[UIImage imageNamed:imagePath]];
    [slVC setInitialText:message];
    slVC.completionHandler = ^( SLComposeViewControllerResult result )
    {
        [localViewController dismissViewControllerAnimated:YES completion:NULL];
    };

    [localViewController presentViewController:slVC animated:YES completion:NULL];
}

-( void )facebookShareLink:(NSString*) title :(NSString*) linkApp :(NSString*) linkImage :(NSString*) desciption :(NSString*) quote :(NSString*) hashtag
{
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    [title length] > 0 ? content.contentTitle = title : nil;
    [linkApp length] > 0 ? content.contentURL = [NSURL URLWithString:linkApp] : nil;
    [linkImage length] > 0 ? content.imageURL = [NSURL URLWithString:linkImage] : nil;
    [desciption length] > 0 ?content.contentDescription = desciption : nil;
    [quote length] > 0 ? content.quote = quote : nil;
    [hashtag length] > 0 ? content.hashtag = [FBSDKHashtag hashtagWithString:hashtag] : nil;
    [FBSDKShareDialog showFromViewController:viewController withContent:content delegate:nil];
    [content release];
}

-( void )facebookShareImage:(NSString *)imagePathLocal :(NSString *)caption :(NSString *)hashTag
{
    UIImage *image = [UIImage imageNamed:imagePathLocal];
    FBSDKSharePhoto *photo = [[FBSDKSharePhoto alloc] init];
    photo.image = image;
    photo.userGenerated = YES;
    [caption length] > 0 ? photo.caption = caption : nil;
    FBSDKSharePhotoContent *content = [[FBSDKSharePhotoContent alloc] init];
    content.photos = @[photo];
    [hashTag length] > 0 ? content.hashtag = [FBSDKHashtag hashtagWithString:hashTag] : nil;
    [FBSDKShareDialog showFromViewController:viewController withContent:content delegate:nil];
    [photo release];
    [content release];
}

-( void )facebookInviteFriends:(NSString *)linkApp :(NSString *)linkImage :(NSString *)promotionText :(NSString *)promotionCode
{
    FBSDKAppInviteContent *content =[[FBSDKAppInviteContent alloc] init];
    content.appLinkURL = [NSURL URLWithString:linkApp];
    //optionally set previewImageURL
    content.appInvitePreviewImageURL = [NSURL URLWithString:linkImage];
    [promotionText length] > 0 ? content.promotionText = promotionText : nil;
    [promotionCode length] > 0 ? content.promotionCode = promotionCode : nil;
    
    // Present the dialog. Assumes self is a view controller
    // which implements the protocol `FBSDKAppInviteDialogDelegate`.
    [FBSDKAppInviteDialog showFromViewController:viewController
                                     withContent:content
                                        delegate:nil];
}
#endif

#pragma mark - GAME_CENTER

#if SCH_IS_GAME_CENTER_ENABLED == true
-( void )gameCenterLogin
{
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    
    localPlayer.authenticateHandler = ^( UIViewController *viewController, NSError *error )
    {
        if ( viewController != nil )
        {
            [localViewController presentViewController:viewController animated:YES completion:nil];
        }
        else
        {
            if ( [GKLocalPlayer localPlayer].authenticated )
            {
                _gameCenterEnabled = YES;
                
                // Get the default leaderboard identifier.
                [[GKLocalPlayer localPlayer] loadDefaultLeaderboardIdentifierWithCompletionHandler:^( NSString *leaderboardIdentifier, NSError *error ) {
                    
                    if ( error != nil )
                    {
                        NSLog( @"%@", [error localizedDescription] );
                    }
                    else
                    {
                        _leaderboardIdentifier = leaderboardIdentifier;
                    }
                }];
            }
            else
            {
                _gameCenterEnabled = NO;
            }
        }
    };
}

-( void )gameCenterSubmitScore:( int )scoreNumber andLeaderboard:( NSString * )leaderboardID
{
    if ( !self.gameCenterEnabled || self.leaderboardIdentifier == nil )
    { return; }
    
    GKScore *s = [[[GKScore alloc] initWithLeaderboardIdentifier:leaderboardID] autorelease];
    s.value = scoreNumber;
    
    [GKScore reportScores:@[s] withCompletionHandler:^(NSError *error)
    {
        if ( error != nil)
        { NSLog( @"%@", [error localizedDescription] ); }
 
    }];
}

-( void )gameCenterShowLeaderboard
{
    if ( _gameCenterEnabled )
    {
        // Init the following view controller object.
        GKGameCenterViewController *gcViewController = [[GKGameCenterViewController alloc] init];
        
        // Set self as its delegate.
        gcViewController.gameCenterDelegate = self;
        gcViewController.viewState = GKGameCenterViewControllerStateLeaderboards;
        //gcViewController.leaderboardIdentifier = _leaderboardIdentifier;
        
        [localViewController presentViewController:gcViewController animated:YES completion:nil];
    }
    else
    {
        [self gameCenterLogin];
    }
}

-( void )gameCenterViewControllerDidFinish:( GKGameCenterViewController * )gameCenterViewController
{ [gameCenterViewController dismissViewControllerAnimated:YES completion:nil]; }

-( void )gameCenterShowAchievements
{
    GKGameCenterViewController *gcViewController = [[GKGameCenterViewController alloc] init];
    
    gcViewController.gameCenterDelegate = self;
    
    gcViewController.viewState = GKGameCenterViewControllerStateAchievements;
    
    [localViewController presentViewController:gcViewController animated:YES completion:nil];
}

-( void )gameCenterUnlockAchievement:( NSString* )achievementID andPercentage: ( float )percent
{
    [GKAchievement loadAchievementsWithCompletionHandler:^( NSArray *achievements, NSError *error )
    {
        if ( error )
        { NSLog( @"Error reporting achievement" ); }
        
        for ( GKAchievement *ach in achievements )
        {
            // achievement already unlocked
            if( [ach.identifier isEqualToString:achievementID] && ach.isCompleted )
            { return; }
        }
        
        GKAchievement *achievementToSend = [[GKAchievement alloc] initWithIdentifier:achievementID];
        achievementToSend.percentComplete = percent;
        achievementToSend.showsCompletionBanner = YES;
        [GKAchievement reportAchievements:@[achievementToSend] withCompletionHandler:NULL];
    }];
}

-( void )gameCenterResetPlayerAchievements
{ [GKAchievement resetAchievementsWithCompletionHandler: NULL]; }
#endif

#pragma mark - ADMOB

#if SCH_IS_AD_MOB_ENABLED == true
- (GADRequest *)createRequest
{
    GADRequest *request = [GADRequest request];
    if ([SCH_TEST_DEVICE length])
    {
        request.testDevices = @[SCH_TEST_DEVICE];
    }
    return request;
}

-( void )admobShowBanner:( int ) position
{
    float version = [[UIDevice currentDevice].systemVersion floatValue];
    if (version > 7.00) {
        GADAdSize adSize = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? kGADAdSizeFullBanner : kGADAdSizeBanner;
        GADRequest *request = [self createRequest];
        if ( !isAdMobTopBannerDisplayed && ADBANNERPOSITION_TOP == position )
        {
            adMobTopBanner = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
            adMobTopBanner.adUnitID = SCH_AD_MOB_BANNER_AD_UNIT_ID;
            adMobTopBanner.rootViewController = localViewController;
            [adMobTopBanner loadRequest:request];
            [localViewController.view addSubview:adMobTopBanner];
            adMobTopBanner.translatesAutoresizingMaskIntoConstraints = NO;
            [view addConstraint:[NSLayoutConstraint constraintWithItem:adMobTopBanner attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterX multiplier:1. constant:0]];
            
            [view addConstraint:[NSLayoutConstraint constraintWithItem:adMobTopBanner attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTop multiplier:1. constant:0]];
            
            isAdMobTopBannerDisplayed = true;
            
        }
        else if ( !isAdMobBottomBannerDisplayed && ADBANNERPOSITION_BOTTOM == position )
        {
            adMobBottomBanner = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
            adMobBottomBanner.adUnitID = SCH_AD_MOB_BANNER_AD_UNIT_ID;
            adMobBottomBanner.rootViewController = localViewController;
            [adMobBottomBanner loadRequest:request];
            [localViewController.view addSubview:adMobBottomBanner];
            adMobBottomBanner.translatesAutoresizingMaskIntoConstraints = NO;
            [view addConstraint:[NSLayoutConstraint constraintWithItem:adMobBottomBanner attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterX multiplier:1. constant:0]];
            
            [view addConstraint:[NSLayoutConstraint constraintWithItem:adMobBottomBanner attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeBottom multiplier:1. constant:0]];
            
             isAdMobBottomBannerDisplayed = true;
        }
        else if ( ADBANNERPOSITION_BOTH == position )
        {
            adMobTopBanner = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
            adMobTopBanner.adUnitID = SCH_AD_MOB_BANNER_AD_UNIT_ID;
            adMobTopBanner.rootViewController = localViewController;
            [localViewController.view addSubview:adMobTopBanner];
            adMobTopBanner.translatesAutoresizingMaskIntoConstraints = NO;
            [view addConstraint:[NSLayoutConstraint constraintWithItem:adMobTopBanner attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterX multiplier:1. constant:0]];
            
            adMobBottomBanner = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
            adMobBottomBanner.adUnitID = SCH_AD_MOB_BANNER_AD_UNIT_ID;
            adMobBottomBanner.rootViewController = localViewController;
            [adMobBottomBanner loadRequest:request];
            [localViewController.view addSubview:adMobBottomBanner];
            adMobBottomBanner.translatesAutoresizingMaskIntoConstraints = NO;
            [view addConstraint:[NSLayoutConstraint constraintWithItem:adMobBottomBanner attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterX multiplier:1. constant:0]];
            
            [view addConstraint:[NSLayoutConstraint constraintWithItem:adMobTopBanner attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTop multiplier:1. constant:0]];
            [view addConstraint:[NSLayoutConstraint constraintWithItem:adMobBottomBanner attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeBottom multiplier:1. constant:0]];
            
            isAdMobTopBannerDisplayed = true;
            isAdMobBottomBannerDisplayed = true;
        }
    }
}

-( void )admobHideBanner:( int ) position
{
    float version = [[UIDevice currentDevice].systemVersion floatValue];
    if (version > 7.00) {
        switch ( position )
        {
            case ADBANNERPOSITION_BOTTOM:
                [adMobBottomBanner removeFromSuperview];
                isAdMobBottomBannerDisplayed = false;
                
                break;
                
            case ADBANNERPOSITION_TOP:
                [adMobTopBanner removeFromSuperview];
                isAdMobTopBannerDisplayed = false;
                
                break;
                
            case ADBANNERPOSITION_BOTH:
                [adMobBottomBanner removeFromSuperview];
                isAdMobBottomBannerDisplayed = false;
                [adMobTopBanner removeFromSuperview];
                isAdMobTopBannerDisplayed = false;
                break;
        }
    }
}

-( void )admobShowFullscreenAd
{
    if ( isAdMobFullscreenLoaded )
    {
        [adMobInterstitial presentFromRootViewController:localViewController];
        
        [self admobRequestFullScreenAd];
    }
}

-( void )admobRequestFullScreenAd
{
    adMobInterstitial = [[GADInterstitial alloc] initWithAdUnitID:SCH_AD_MOB_FULLSCREEN_AD_UNIT_ID];
    adMobInterstitial.delegate = self;
    GADRequest *request = [self createRequest];
    [adMobInterstitial loadRequest:request];
}

-( void )interstitialDidReceiveAd:( GADInterstitial * )ad
{
    isAdMobFullscreenLoaded = true;
}

#endif

#pragma mark - GOOGLE_ANALYTICS

#if SCH_IS_GOOGLE_ANALYTICS_ENABLED == true
-( void )setGAScreenName:( NSString * )screenString
{
    [tracker set:kGAIScreenName value:screenString];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

-( void )setGADispatchInterval:( int )dispatchInterval
{ [GAI sharedInstance].dispatchInterval = dispatchInterval; }

-( void )sendGAEvent:( NSString * ) category: ( NSString * ) action: ( NSString * ) label: ( NSNumber * ) value
{
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:category     // Event category (required)
                                                          action:action  // Event action (required)
                                                           label:label          // Event label
                                                           value:value] build]];    // Event value
}
#endif

#if SCH_IS_NOTIFICATIONS_ENABLED == true
-( void )scheduleLocalNotification:( NSTimeInterval ) delay andNotificationText:( NSString * ) textToDisplay andNotificationTitle:( NSString * ) notificationTitle addNotificationTag:( int ) notificationTag
{
    NSDate *alarmTime = [[NSDate date] dateByAddingTimeInterval:delay];
    UILocalNotification *notifyAlarm = [[UILocalNotification alloc] init];
    
    if ( notifyAlarm )
    {
        if ( [[UIDevice currentDevice].systemVersion floatValue] >= 8.0 )
        {
            notifyAlarm.alertTitle = notificationTitle;
        }
        notifyAlarm.fireDate = alarmTime;
        notifyAlarm.timeZone = [NSTimeZone defaultTimeZone];
        notifyAlarm.soundName = UILocalNotificationDefaultSoundName;
        notifyAlarm.alertBody = textToDisplay;
        
        //NSDictionary * infoDict = [NSDictionary dictionaryWithObject:notificationTag forKey:@"notificationID"];
        //notifyAlarm.userInfo = infoDict;
        
        [[UIApplication sharedApplication] scheduleLocalNotification: notifyAlarm];
    }
}

-( void )scheduleLocalNotification:( NSTimeInterval ) delay andNotificationText:( NSString * ) textToDisplay andNotificationTitle:( NSString * ) notificationTitle andNotificationAction:( NSString * )notificationAction addNotificationTag:( int ) notificationTag
{
    NSDate *alarmTime = [[NSDate date] dateByAddingTimeInterval:delay];
    UILocalNotification *notifyAlarm = [[UILocalNotification alloc] init];
    
    if ( notifyAlarm )
    {
        if ( [[UIDevice currentDevice].systemVersion floatValue] >= 8.0 )
        {
            notifyAlarm.alertTitle = notificationTitle;
        }
        notifyAlarm.fireDate = alarmTime;
        notifyAlarm.timeZone = [NSTimeZone defaultTimeZone];
        notifyAlarm.soundName = UILocalNotificationDefaultSoundName;
        notifyAlarm.alertBody = textToDisplay;
        notifyAlarm.alertAction = notificationAction;
        
        //NSDictionary * infoDict = [NSDictionary dictionaryWithObject:notificationTag forKey:@"notificationID"];
        //notifyAlarm.userInfo = infoDict;
        
        [[UIApplication sharedApplication] scheduleLocalNotification: notifyAlarm];
    }
}

-( void )scheduleLocalNotification:( NSTimeInterval )delay andNotificationText:( NSString * )textToDisplay andNotificationTitle:( NSString * )notificationTitle andRepeatInterval:( int )repeatInterval addNotificationTag:( int ) notificationTag
{
    NSDate *alarmTime = [[NSDate date] dateByAddingTimeInterval:delay];
    UILocalNotification *notifyAlarm = [[UILocalNotification alloc] init];
    
    if ( notifyAlarm )
    {
        if ( [[UIDevice currentDevice].systemVersion floatValue] >= 8.0 )
        {
            notifyAlarm.alertTitle = notificationTitle;
        }
        notifyAlarm.fireDate = alarmTime;
        notifyAlarm.timeZone = [NSTimeZone defaultTimeZone];
        notifyAlarm.soundName = UILocalNotificationDefaultSoundName;
        notifyAlarm.alertBody = textToDisplay;
        notifyAlarm.repeatInterval = [self convertRepeatIntervalToCalendarUnit:repeatInterval];
        
        //NSDictionary * infoDict = [NSDictionary dictionaryWithObject:notificationTag forKey:@"notificationID"];
        //notifyAlarm.userInfo = infoDict;
        
        [[UIApplication sharedApplication] scheduleLocalNotification: notifyAlarm];
    }
}

-( void )scheduleLocalNotification:( NSTimeInterval )delay andNotificationText:( NSString * )textToDisplay andNotificationTitle:( NSString * )notificationTitle andNotificationAction:( NSString * )notificationAction andRepeatInterval:( int )repeatInterval addNotificationTag:( int ) notificationTag
{
    NSDate *alarmTime = [[NSDate date] dateByAddingTimeInterval:delay];
    UILocalNotification *notifyAlarm = [[UILocalNotification alloc] init];
    
    if ( notifyAlarm )
    {
        if ( [[UIDevice currentDevice].systemVersion floatValue] >= 8.0 )
        {
            notifyAlarm.alertTitle = notificationTitle;
        }
        notifyAlarm.fireDate = alarmTime;
        notifyAlarm.timeZone = [NSTimeZone defaultTimeZone];
        notifyAlarm.soundName = UILocalNotificationDefaultSoundName;
        notifyAlarm.alertBody = textToDisplay;
        notifyAlarm.alertAction = notificationAction;
        notifyAlarm.repeatInterval = [self convertRepeatIntervalToCalendarUnit:repeatInterval];
        
        //NSDictionary * infoDict = [NSDictionary dictionaryWithObject:notificationTag forKey:@"notificationID"];
        //notifyAlarm.userInfo = infoDict;
        
        [[UIApplication sharedApplication] scheduleLocalNotification: notifyAlarm];
    }
}

-( NSCalendarUnit )convertRepeatIntervalToCalendarUnit:( int )repeatInterval
{
    NSCalendarUnit *calendarUnit;
    
    switch ( repeatInterval )
    {
        case CALENDAR_UNIT_MINUTE:
            calendarUnit = NSMinuteCalendarUnit;
            
            break;
        case CALENDAR_UNIT_HOURLY:
            calendarUnit = NSHourCalendarUnit;
            
            break;
        case CALENDAR_UNIT_DAILY:
            calendarUnit = NSDayCalendarUnit;
            
            break;
        case CALENDAR_UNIT_WEEKLY:
            calendarUnit = NSWeekCalendarUnit;
            
            break;
        case CALENDAR_UNIT_MONTHLY:
            calendarUnit = NSMonthCalendarUnit;
            
            break;
        case CALENDAR_UNIT_YEARLY:
            calendarUnit = NSYearCalendarUnit;
            
            break;
            
        default:
            break;
    }
    
    return calendarUnit;
}

-( void )unscheduleAllLocalNotifications
{
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *oldNotifications = [app scheduledLocalNotifications];
    
    if ( [oldNotifications count] > 0 )
    { [app cancelAllLocalNotifications]; }
}

-( void )unscheduleLocalNotification:( int )notificationTag
{
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *oldNotifications = [app scheduledLocalNotifications];
    
    for ( NSUInteger i = 0; i < oldNotifications.count; i++ )
    {
        UILocalNotification *scheduledNotification = oldNotifications[i];

        //if ( [scheduledNotification.alertTitle isEqualToString:notificationTitle] )
        if ( [[scheduledNotification.userInfo objectForKey:@"notificationID"] isEqualToNumber:notificationTag] )
        {
            [app cancelLocalNotification:scheduledNotification];
        }
    }
}
#endif

#if SCH_IS_AD_FACEBOOK_ENABLED == true
-( void )facebookShowBannerAds:( int ) position
{
    UIViewController* controller = [IOSHelper getCurrentRootViewController];
    
    switch (position) {
        case ADBANNERPOSITION_TOP:
        {
            if (facebookBannerTop != nil) {
                [facebookBannerTop setHidden:false];
            } else {
                // Create new ads.
                FBAdSize adSize;
                CGSize size = controller.view.bounds.size;
                if (size.height / size.width < 1.34) { // ipad.
                    adSize = kFBAdSizeHeight90Banner;
                } else {
                    adSize = kFBAdSizeHeight50Banner;
                }
                
                facebookBannerTop = [[FBAdView alloc] initWithPlacementID:SCH_AD_FACEBOOK_BANNER_ID
                                                                   adSize:adSize
                                                       rootViewController:controller];
                facebookBannerTop.frame = CGRectMake(0, 0, facebookBannerTop.bounds.size.width, facebookBannerTop.bounds.size.height);
                facebookBannerTop.delegate = self;
                [facebookBannerTop loadAd];
                [controller.view addSubview:facebookBannerTop];
            }
        }
            break;
            
        case ADBANNERPOSITION_BOTTOM:
        {
            if (facebookBannerBottom != nil) {
                [facebookBannerBottom setHidden:false];
            } else {
                // Create new ads.
                FBAdSize adSize;
                CGSize size = controller.view.bounds.size;
                if (size.height / size.width < 1.34) { // ipad.
                    adSize = kFBAdSizeHeight90Banner;
                } else {
                    adSize = kFBAdSizeHeight50Banner;
                }
                facebookBannerBottom = [[FBAdView alloc] initWithPlacementID:SCH_AD_FACEBOOK_BANNER_ID
                                                                      adSize:adSize
                                                          rootViewController:controller];
                facebookBannerBottom.frame = CGRectMake(0, controller.view.bounds.size.height - facebookBannerBottom.bounds.size.height, facebookBannerBottom.bounds.size.width, facebookBannerBottom.bounds.size.height);
                facebookBannerBottom.delegate = self;
                [facebookBannerBottom loadAd];
                [controller.view addSubview:facebookBannerBottom];
            }
        }
            break;
        case ADBANNERPOSITION_BOTH:
        {
            [[IOSHelper instance] facebookShowBannerAds:ADBANNERPOSITION_TOP];
            [[IOSHelper instance] facebookShowBannerAds:ADBANNERPOSITION_BOTTOM];
        }
            break;
    }
}

- (void)adViewDidClick:(FBAdView *)adView
{
    NSLog(@"Banner ad was clicked.");
}

- (void)adViewDidFinishHandlingClick:(FBAdView *)adView
{
    NSLog(@"Banner ad did finish click handling.");
}

- (void)adViewWillLogImpression:(FBAdView *)adView
{
    NSLog(@"Banner ad impression is being captured.");
}

- (void)adView:(FBAdView *)adView didFailWithError:(NSError *)error
{
    NSLog(@"Ad failed to load");
}

- (void)adViewDidLoad:(FBAdView *)adView
{
    NSLog(@"Ad was loaded and ready to be displayed");
}

-( void )facebookHideBannerAds:( int ) position
{
    switch (position) {
        case ADBANNERPOSITION_TOP:
        {
            if (facebookBannerTop != nil) {
                [facebookBannerTop setHidden:true];
            }
        }
            break;
            
        case ADBANNERPOSITION_BOTTOM:
        {
            if (facebookBannerBottom!= nil) {
                [facebookBannerBottom setHidden:true];
            }
        }
            break;
            
        case ADBANNERPOSITION_BOTH:
        {
            [[IOSHelper instance] facebookHideBannerAds:ADBANNERPOSITION_TOP];
            [[IOSHelper instance] facebookHideBannerAds:ADBANNERPOSITION_BOTTOM];
        }
            break;
    }
}

-( void )facebookPreloadFullscreenAds
{
    // Delete old ads.
    if (facebookInterstitial != nil) {
        [facebookInterstitial release];
        facebookInterstitial = nil;
        NSLog(@"Giai phong facebook cu.");
    }
    
    facebookInterstitial = [[FBInterstitialAd alloc] initWithPlacementID:SCH_AD_FACEBOOK_FULLSCREEN_ID];
    facebookInterstitial.delegate = self;
    [facebookInterstitial loadAd];
}

- (void)interstitialAdDidLoad:(FBInterstitialAd *)interstitialAd {
    NSLog(@"Ad is loaded and ready to be displayed");
    // You can now display the full screen ad using this code:
    if (isNeedShowInterstitial) {
        UIViewController* controller = [IOSHelper getCurrentRootViewController];
        [facebookInterstitial showAdFromRootViewController:controller];
        isNeedShowInterstitial = false;
    }
}

- (void)interstitialAdWillLogImpression:(FBInterstitialAd *)interstitialAd {
    NSLog(@"The user sees the add");
    // Use this function as indication for a user's impression on the ad.
}
- (void)interstitialAdDidClick:(FBInterstitialAd *)interstitialAd
{
    NSLog(@"The user clicked on the ad and will be taken to its destination");
    // Use this function as indication for a user's click on the ad.
}

- (void)interstitialAdWillClose:(FBInterstitialAd *)interstitialAd
{
    NSLog(@"The user clicked on the close button, the ad is just about to close");
    // Consider to add code here to resume your app's flow
}

- (void)interstitialAdDidClose:(FBInterstitialAd *)interstitialAd
{
    NSLog(@"Interstitial had been closed");
    // Consider to add code here to resume your app's flow
    [facebookInterstitial release];
    facebookInterstitial = nil;
}

- (void)interstitialAd:(FBInterstitialAd *)interstitialAd didFailWithError:(NSError *)error {
    NSLog(@"Ad failed to load");
}


-( void )facebookShowPreloadedFullscreenAds
{
    if (facebookInterstitial != nil) {
        UIViewController* controller = [IOSHelper getCurrentRootViewController];
        [facebookInterstitial showAdFromRootViewController:controller];
    } else {
        isNeedShowInterstitial = true;
        [[IOSHelper instance] facebookPreloadFullscreenAds];
    }
}

-( void )facebookPreloadNativeAds:( int ) left left_distance: ( int ) top top_distance: ( int ) right right_distance: ( int ) bottom bottom_distance: ( int ) size_width
{
    // Delete old ads.
    if (facebookNative != nil) {
        [facebookNative release];
        facebookNative = nil;
    }
    
    // Remove old view frome superview.
    if (self.facebookNativeAdView != nil) {
        [self.facebookNativeAdView removeFromSuperview];
        self.facebookNativeAdView = nil;
    }
    
    // Setting data.
    _native_left_distance = left;
    _native_right_distance = right;
    _native_top_distance = top;
    _native_bottom_distance = bottom;
    _native_width_size = size_width;
    
    // Load ads.
    facebookNative = [[FBNativeAd alloc] initWithPlacementID:SCH_AD_FACEBOOK_BANNER_ID];
    facebookNative.delegate = self;
    facebookNative.mediaCachePolicy = FBNativeAdsCachePolicyAll;
    [facebookNative loadAd];
}

- (void)nativeAdDidLoad:(FBNativeAd *)nativeAd
{
    NSLog(@"Ad had been loaded.");
    if (facebookNative) {
        [facebookNative unregisterView];
    }
    
    facebookNative = nativeAd;
    if (facebookNative == nil) {
        return;
    }
    
    // Create native UI using the ad metadata.
    UIViewController* controller = [IOSHelper getCurrentRootViewController];
    self.facebookNativeAdView = [[[NSBundle mainBundle] loadNibNamed:@"NativeView" owner:self options:nil] firstObject];
    
    // Wire up UIView with the native ad; the whole UIView will be clickable.
    [facebookNative registerViewForInteraction:self.facebookNativeAdView
                            withViewController:self];
    
    // Create native UI using the ad metadata.
    [self.fbNative_adCoverMediaView setNativeAd:facebookNative];
    
    __weak typeof(self) weakSelf = self;
    [facebookNative.icon loadImageAsyncWithBlock:^(UIImage *image) {
        if (image != nil) {
            __strong typeof(self) strongSelf = weakSelf;
            strongSelf.fbNative_adIconImageView.image = image;
        }
    }];
    
    // Render native ads onto UIView
    [facebookNative.title length] > 0 ? self.fbNative_adTitleLabel.text = facebookNative.title:nil;
    [facebookNative.body length] > 0 ? self.fbNative_adBodyLabel.text = facebookNative.body:nil;
    [facebookNative.socialContext length] > 0 ?self.fbNative_adSocialContextLabel.text = facebookNative.socialContext:nil;
    self.fbNative_sponsoredLabel.text = @"Sponsored";
    [self.fbNative_adCallToActionButton setTitle:facebookNative.callToAction
                                        forState:UIControlStateNormal];
    self.fbNative_adChoicesView.nativeAd = facebookNative;
    self.fbNative_adChoicesView.corner = UIRectCornerTopRight;
    float percent_size_design = _native_width_size / 768.0;
    CGSize ad_size = controller.view.bounds.size;
    ad_size.width *= percent_size_design;
    ad_size.height = ad_size.width;
    if (_native_top_distance > 0) {
        self.facebookNativeAdView.frame = CGRectMake((controller.view.bounds.size.width - ad_size.width) / 2, _native_top_distance, ad_size.width, ad_size.height);
    } else {
        self.facebookNativeAdView.frame = CGRectMake((controller.view.bounds.size.width - ad_size.width) / 2, controller.view.bounds.size.height - _native_bottom_distance - ad_size.height, ad_size.width, ad_size.height  );
    }
    [[IOSHelper instance] facebookHideNativeAds];
    [controller.view addSubview:self.facebookNativeAdView];
}

-( void )facebookShowNativeAds
{
    if (self.facebookNativeAdView != nil) {
        [self.facebookNativeAdView setHidden:false];
    } else {
        NSLog(@"Need preload first");
    }
}

- (void)dealloc {
    [_fbNative_adTitleLabel release];
    [_fbNative_adCoverMediaView release];
    [_fbNative_adSocialContextLabel release];
    [_fbNative_adCallToActionButton release];
    [_fbNative_adChoicesView release];
    [_fbNative_adBodyLabel release];
    [_fbNative_sponsoredLabel release];
    [_fbNative_adIconImageView release];
    [super dealloc];
}

-( void )facebookHideNativeAds
{
    if (self.facebookNativeAdView != nil) {
        [self.facebookNativeAdView setHidden:true];
    }
}

#endif


@end
