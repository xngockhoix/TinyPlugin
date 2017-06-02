/*
 Copyright (C) 2015 Sonar Systems - All Rights Reserved
 You may use, distribute and modify this code under the
 terms of the MIT license
 
 Any external frameworks used have their own licenses and
 should be followed as such.
 */
//
//  IOSCPPHelper.h
//  Sonar Cocos Helper
//
//  Created by Sonar Systems on 03/03/2015.
//
//

#ifndef __SCH__IOSCPPHelper__
#define __SCH__IOSCPPHelper__

#include "SCHSettings.h"
#include "cocos2d.h"

using namespace cocos2d;

class IOSCPPHelper
{
private:
    
public:    
    static void Setup( );

#if SCH_IS_SOCIAL_ENABLED == true
    static void shareViaTwitter( __String message, __String thumbnailPath );
    static void facebookShareLink(__String title, __String linkApp, __String linkImage, __String desciption, __String quote, __String hashtag);
    static void facebookShareImage(__String imagePathLocal, __String caption, __String hashTag);
    static void facebookInviteFriends(__String linkApp, __String linkImage, __String promotionText, __String promotionCode);

#endif
    
#if SCH_IS_GAME_CENTER_ENABLED == true
    static void gameCenterLogin( );
    static void gameCenterShowLeaderboard( );
    static void gameCenterShowAchievements( );
    static void gameCenterSubmitScore( int scoreNumber, __String leaderboardID );
    static void gameCenterUnlockAchievement( __String achievementID, float percent );
    static void gameCenterResetPlayerAchievements( );
#endif
    
#if SCH_IS_AD_MOB_ENABLED == true
    static void admobShowBanner( int position );
    static void admobHideBanner( int position );
    
    static void admobRequestFullScreenAd();
    static void admobShowFullscreenAd( );
#endif
    
#if SCH_IS_GOOGLE_ANALYTICS_ENABLED == true
    static void setGAScreenName( __String screenName );
    static void setGADispatchInterval( int dispatchInterval );
    static void sendGAEvent( __String category, __String action, __String label, long value );
#endif
    
#if SCH_IS_NOTIFICATIONS_ENABLED == true
    static void scheduleLocalNotification( float delay, __String textToDisplay, __String notificationTitle , int notificationTag);
    static void scheduleLocalNotification( float delay, __String textToDisplay, __String notificationTitle, __String notificationAction , int notificationTag);
    static void scheduleLocalNotification( float delay, __String textToDisplay, __String notificationTitle, int repeatInterval , int notificationTag);
    static void scheduleLocalNotification( float delay, __String textToDisplay, __String notificationTitle, __String notificationAction, int repeatInterval , int notificationTag);
    static void unscheduleAllLocalNotifications( );
    static void unscheduleLocalNotification( int notificationTag );
#endif
    
#if SCH_IS_AD_FACEBOOK_ENABLED == true
    static void facebookShowBannerAds( int position );
    static void facebookHideBannerAds( int position );
    
    static void facebookPreloadFullscreenAds();
    static void facebookShowPreloadedFullscreenAds();
    
    static void facebookPreloadNativeAds( int left, int top, int right, int bottom, int size_width );
    static void facebookShowNativeAds();
    static void facebookHideNativeAds();
#endif
    
};

#endif /* defined(__SNF__IOSCPPHelper__) */
