/*
 Copyright (C) 2015 Sonar Systems - All Rights Reserved
 You may use, distribute and modify this code under the
 terms of the MIT license
 
 Any external frameworks used have their own licenses and
 should be followed as such.
 */
//
//  IOSCPPHelper.mm
//  Sonar Cocos Helper
//
//  Created by Sonar Systems on 03/03/2015.
//
//

#include "IOSCPPHelper.h"
#import "IOSHelper.h"


void IOSCPPHelper::Setup( )
{
    [[IOSHelper instance] initialise];
}

#if SCH_IS_SOCIAL_ENABLED == true
void IOSCPPHelper::shareViaTwitter( __String message, __String thumbnailPath )
{
    [[IOSHelper instance] shareViaTwitter:[NSString stringWithCString:message.getCString( ) encoding:NSUTF8StringEncoding]: [NSString stringWithCString:thumbnailPath.getCString( ) encoding:NSUTF8StringEncoding]];
}

void IOSCPPHelper::facebookShareLink(cocos2d::__String title, cocos2d::__String linkApp, cocos2d::__String linkImage, cocos2d::__String desciption, cocos2d::__String quote, cocos2d::__String hashtag)
{
    [[IOSHelper instance] facebookShareLink:
        [NSString stringWithCString:title.getCString() encoding:NSUTF8StringEncoding]:
        [NSString stringWithCString:linkApp.getCString() encoding:NSUTF8StringEncoding]:
        [NSString stringWithCString:linkImage.getCString() encoding:NSUTF8StringEncoding]:
        [NSString stringWithCString:desciption.getCString() encoding:NSUTF8StringEncoding]:
        [NSString stringWithCString:quote.getCString() encoding:NSUTF8StringEncoding]:
        [NSString stringWithCString:hashtag.getCString() encoding:NSUTF8StringEncoding]];
}

void IOSCPPHelper::facebookShareImage(cocos2d::__String imagePathLocal, cocos2d::__String caption, cocos2d::__String hashTag)
{
    [[IOSHelper instance] facebookShareImage:
        [NSString stringWithCString:imagePathLocal.getCString() encoding:NSUTF8StringEncoding] :
        [NSString stringWithCString:caption.getCString() encoding:NSUTF8StringEncoding] :
        [NSString stringWithCString:hashTag.getCString() encoding:NSUTF8StringEncoding]];
}

void IOSCPPHelper::facebookInviteFriends(cocos2d::__String linkApp, cocos2d::__String linkImage, cocos2d::__String promotionText, cocos2d::__String promotionCode)
{
    [[IOSHelper instance] facebookInviteFriends:
        [NSString stringWithCString:linkApp.getCString() encoding:NSUTF8StringEncoding] :
        [NSString stringWithCString:linkImage.getCString() encoding:NSUTF8StringEncoding] :
        [NSString stringWithCString:promotionText.getCString() encoding:NSUTF8StringEncoding] :
        [NSString stringWithCString:promotionCode.getCString() encoding:NSUTF8StringEncoding]];
}

#endif

#if SCH_IS_GAME_CENTER_ENABLED == true
void IOSCPPHelper::gameCenterLogin( )
{
    [[IOSHelper instance] gameCenterLogin];
}

void IOSCPPHelper::gameCenterShowLeaderboard( )
{
    [[IOSHelper instance] gameCenterShowLeaderboard];
}

void IOSCPPHelper::gameCenterShowAchievements( )
{
    [[IOSHelper instance] gameCenterShowAchievements];
}

void IOSCPPHelper::gameCenterSubmitScore( int scoreNumber, __String leaderboardID )
{
    [[IOSHelper instance] gameCenterSubmitScore:scoreNumber
                                 andLeaderboard:[NSString stringWithCString:leaderboardID.getCString( ) encoding:NSUTF8StringEncoding]];
}

void IOSCPPHelper::gameCenterUnlockAchievement( __String achievementID, float percent )
{
    [[IOSHelper instance] gameCenterUnlockAchievement:[NSString stringWithCString:achievementID.getCString( ) encoding:NSUTF8StringEncoding] andPercentage:percent];
}

void IOSCPPHelper::gameCenterResetPlayerAchievements( )
{
    [[IOSHelper instance] gameCenterResetPlayerAchievements];
}
#endif

#if SCH_IS_AD_MOB_ENABLED == true
void IOSCPPHelper::admobShowBanner( int position )
{
    [[IOSHelper instance] admobShowBanner:position];
}

void IOSCPPHelper::admobHideBanner( int position )
{
    [[IOSHelper instance] admobHideBanner:position];
}

void IOSCPPHelper::admobRequestFullScreenAd()
{
    [[IOSHelper instance] admobRequestFullScreenAd];
}
void IOSCPPHelper::admobShowFullscreenAd( )
{
    [[IOSHelper instance] admobShowFullscreenAd];
}
#endif

#if SCH_IS_GOOGLE_ANALYTICS_ENABLED == true
void IOSCPPHelper::setGAScreenName( __String screenName )
{
    [[IOSHelper instance] setGAScreenName:[NSString stringWithCString:screenName.getCString( ) encoding:NSUTF8StringEncoding]];
}

void IOSCPPHelper::setGADispatchInterval( int dispatchInterval )
{
    [[IOSHelper instance] setGADispatchInterval:dispatchInterval];
}

void IOSCPPHelper::sendGAEvent( __String category, __String action, __String label, long value )
{
    [[IOSHelper instance] sendGAEvent:[NSString stringWithCString:category.getCString( ) encoding:NSUTF8StringEncoding]: [NSString stringWithCString:action.getCString( ) encoding:NSUTF8StringEncoding]: [NSString stringWithCString:label.getCString( ) encoding:NSUTF8StringEncoding]: [NSNumber numberWithLong:(value)]];
}
#endif

#if SCH_IS_NOTIFICATIONS_ENABLED == true
void IOSCPPHelper::scheduleLocalNotification( float delay, __String textToDisplay, __String notificationTitle , int notificationTag)
{
    NSString *notificationText = [NSString stringWithCString:textToDisplay.getCString( ) encoding:NSUTF8StringEncoding];
    NSString *notificationTitleLcl = [NSString stringWithCString:notificationTitle.getCString( ) encoding:NSUTF8StringEncoding];
    [[IOSHelper instance] scheduleLocalNotification:delay andNotificationText:notificationText andNotificationTitle:notificationTitleLcl addNotificationTag:notificationTag];
}

void IOSCPPHelper::scheduleLocalNotification( float delay, __String textToDisplay, __String notificationTitle, __String notificationAction , int notificationTag)
{
    NSString *notificationText = [NSString stringWithCString:textToDisplay.getCString( ) encoding:NSUTF8StringEncoding];
    NSString *notificationTitleLcl = [NSString stringWithCString:notificationTitle.getCString( ) encoding:NSUTF8StringEncoding];
    NSString *notificationActionLcl = [NSString stringWithCString:notificationAction.getCString( ) encoding:NSUTF8StringEncoding];
    [[IOSHelper instance] scheduleLocalNotification:delay andNotificationText:notificationText andNotificationTitle:notificationTitleLcl andNotificationAction:notificationActionLcl addNotificationTag:notificationTag];
}

void IOSCPPHelper::scheduleLocalNotification( float delay, __String textToDisplay, __String notificationTitle, int repeatInterval , int notificationTag)
{
    NSString *notificationText = [NSString stringWithCString:textToDisplay.getCString( ) encoding:NSUTF8StringEncoding];
    NSString *notificationTitleLcl = [NSString stringWithCString:notificationTitle.getCString( ) encoding:NSUTF8StringEncoding];
    [[IOSHelper instance] scheduleLocalNotification:delay andNotificationText:notificationText andNotificationTitle:notificationTitleLcl andRepeatInterval:repeatInterval addNotificationTag:notificationTag];
}

void IOSCPPHelper::scheduleLocalNotification( float delay, __String textToDisplay, __String notificationTitle, __String notificationAction, int repeatInterval , int notificationTag)
{
    NSString *notificationText = [NSString stringWithCString:textToDisplay.getCString( ) encoding:NSUTF8StringEncoding];
    NSString *notificationTitleLcl = [NSString stringWithCString:notificationTitle.getCString( ) encoding:NSUTF8StringEncoding];
    NSString *notificationActionLcl = [NSString stringWithCString:notificationAction.getCString( ) encoding:NSUTF8StringEncoding];
    [[IOSHelper instance] scheduleLocalNotification:delay andNotificationText:notificationText andNotificationTitle:notificationTitleLcl andNotificationAction:notificationActionLcl andRepeatInterval:repeatInterval addNotificationTag:notificationTag];
}

void IOSCPPHelper::unscheduleAllLocalNotifications( )
{
    [[IOSHelper instance] unscheduleAllLocalNotifications];
}

void IOSCPPHelper::unscheduleLocalNotification( int notificationTag )
{
    //NSString *notificationTitleLcl = [NSString stringWithCString:notificationTitle.getCString( ) encoding:NSUTF8StringEncoding];
    [[IOSHelper instance] unscheduleLocalNotification:notificationTag];
}
#endif

#if SCH_IS_AD_FACEBOOK_ENABLED == true
void IOSCPPHelper::facebookShowBannerAds(int position)
{
    [[IOSHelper instance] facebookShowBannerAds:position];
}

void IOSCPPHelper::facebookHideBannerAds(int position)
{
    [[IOSHelper instance] facebookHideBannerAds:position];
}

void IOSCPPHelper::facebookPreloadFullscreenAds()
{
    [[IOSHelper instance] facebookPreloadFullscreenAds];
}

void IOSCPPHelper::facebookShowPreloadedFullscreenAds()
{
    [[IOSHelper instance] facebookShowPreloadedFullscreenAds];
}

void IOSCPPHelper::facebookPreloadNativeAds(int left, int top, int right, int bottom, int size_width)
{
    [[IOSHelper instance] facebookPreloadNativeAds:left left_distance:top top_distance:right right_distance:bottom bottom_distance:size_width];
}

void IOSCPPHelper::facebookShowNativeAds()
{
    [[IOSHelper instance] facebookShowNativeAds];
}

void IOSCPPHelper::facebookHideNativeAds()
{
    [[IOSHelper instance] facebookHideNativeAds];
}

#endif
