/*
 Copyright (C) 2015 Sonar Systems - All Rights Reserved
 You may use, distribute and modify this code under the
 terms of the MIT license
 
 Any external frameworks used have their own licenses and
 should be followed as such.
 */
//
//  SonarFrameworks.cpp
//  Sonar Cocos Helper
//
//  Created by Sonar Systems on 03/03/2015.
//

#include "SonarFrameworks.h"

#if(CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
#include <jni.h>
#include <android/log.h>
#define CLASS_NAME "sonar/systems/framework/SonarFrameworkFunctions"
#elif(CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
#include "IOSCPPHelper.h"
#endif

using namespace SonarCocosHelper;

bool isiOS(){
#if CC_TARGET_PLATFORM == CC_PLATFORM_IOS
    return true;
#endif
    return false;
}

bool isAndroid(){
#if CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID
    return true;
#endif
    return false;
}

void IOS::Setup( )
{
#if(CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    IOSCPPHelper::Setup( );
#endif
}

bool GooglePlayServices::isSignedIn()
{
	#if(CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
		return JniHelpers::jniCommonBoolCall(
			"isSignedIn",
			CLASS_NAME);
	#endif

		return false;
}

void GooglePlayServices::signIn()
{
	#if(CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
		JniHelpers::jniCommonVoidCall(
			"gameServicesSignIn",
			CLASS_NAME);
	#endif
}

void GooglePlayServices::signOut()
{
	#if(CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
		JniHelpers::jniCommonVoidCall(
			"gameServicesSignOut",
			CLASS_NAME);
	#endif
}

void GooglePlayServices::submitScore(const char* leaderboardID, long score)
{
	#if(CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
		JniHelpers::jniCommonVoidCall(
			"submitScore",
			CLASS_NAME,
			leaderboardID,
			score);
	#endif
}

void GooglePlayServices::unlockAchievement(const char* achievementID)
{
	#if(CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
		JniHelpers::jniCommonVoidCall(
			"unlockAchievement",
			CLASS_NAME,
			achievementID);
	#endif
}

void GooglePlayServices::incrementAchievement(const char* achievementID, int numSteps)
{
	#if(CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
		JniHelpers::jniCommonVoidCall(
			"incrementAchievement",
			CLASS_NAME,
			achievementID,
			numSteps);
	#endif
}

void GooglePlayServices::showAchievements()
{
	#if(CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
		JniHelpers::jniCommonVoidCall(
			"showAchievements",
			CLASS_NAME);
	#endif
}

void GooglePlayServices::showLeaderboards()
{
	#if(CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
		JniHelpers::jniCommonVoidCall(
			"showLeaderboards",
			CLASS_NAME);
	#endif
}

void GooglePlayServices::showLeaderboard(const char* leaderboardID)
{
	#if(CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
		JniHelpers::jniCommonVoidCall(
			"showLeaderboard",
			CLASS_NAME,
			leaderboardID);
	#endif
}

void GameCenter::signIn( )
{
#if CC_TARGET_PLATFORM == CC_PLATFORM_IOS
	#if SCH_IS_GAME_CENTER_ENABLED == true
		IOSCPPHelper::gameCenterLogin( );
	#endif
#endif
}

void GameCenter::showLeaderboard( )
{
#if CC_TARGET_PLATFORM == CC_PLATFORM_IOS
	#if SCH_IS_GAME_CENTER_ENABLED == true
		IOSCPPHelper::gameCenterShowLeaderboard( );
	#endif
#endif
}

void GameCenter::showAchievements( )
{
#if CC_TARGET_PLATFORM == CC_PLATFORM_IOS
	#if SCH_IS_GAME_CENTER_ENABLED == true
		IOSCPPHelper::gameCenterShowAchievements( );
	#endif
#endif
}

void GameCenter::submitScore( int scoreNumber, cocos2d::__String leaderboardID )
{
#if CC_TARGET_PLATFORM == CC_PLATFORM_IOS
	#if SCH_IS_GAME_CENTER_ENABLED == true
		IOSCPPHelper::gameCenterSubmitScore( scoreNumber, leaderboardID );
	#endif
#endif
}

void GameCenter::unlockAchievement( cocos2d::__String achievementID )
{
#if CC_TARGET_PLATFORM == CC_PLATFORM_IOS
#if SCH_IS_GAME_CENTER_ENABLED == true
    IOSCPPHelper::gameCenterUnlockAchievement( achievementID, 100.0f );
#endif
#endif
}

void GameCenter::unlockAchievement( cocos2d::__String achievementID, float percent )
{
#if CC_TARGET_PLATFORM == CC_PLATFORM_IOS
#if SCH_IS_GAME_CENTER_ENABLED == true
    IOSCPPHelper::gameCenterUnlockAchievement( achievementID, percent );
#endif
#endif
}

void GameCenter::resetPlayerAchievements( )
{
#if CC_TARGET_PLATFORM == CC_PLATFORM_IOS
#if SCH_IS_GAME_CENTER_ENABLED == true
    IOSCPPHelper::gameCenterResetPlayerAchievements( );
#endif
#endif
}

void Facebook::facebookShareLink(const char *title, const char *linkApp, const char *linkImage, const char *desciption, const char *quote, const char *hashtag)
{
#if(CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    return JniHelpers::jniCommonVoidCall(
                                         "FacebookShareLink",
                                         CLASS_NAME,
                                         title,
                                         linkApp,
                                         linkImage,
                                         desciption,
                                         quote,
                                         hashtag);
#elif(CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    #if SCH_IS_SOCIAL_ENABLED == true
        IOSCPPHelper::facebookShareLink(title, linkApp, linkImage, desciption, quote, hashtag);
    #endif
#endif
}

void Facebook::facebookShareImage(const char *imagePathLocal, const char *caption, const char *hashTag)
{
#if(CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    return JniHelpers::jniCommonVoidCall(
                                         "FacebookShareImage",
                                         CLASS_NAME,
                                         imagePathLocal,
                                         caption,
                                         hashTag);
#elif(CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    #if SCH_IS_SOCIAL_ENABLED == true
        IOSCPPHelper::facebookShareImage(imagePathLocal, caption, hashTag);
    #endif
#endif
}

void Facebook::facebookInviteFriends(const char *linkApp, const char *linkImage, const char *promotionText, const char *promotionCode)
{
#if(CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    return JniHelpers::jniCommonVoidCall(
                                         "FacebookInviteFriends",
                                         CLASS_NAME,
                                         linkApp,
                                         linkImage,
                                         promotionText,
                                         promotionCode);
#elif(CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    #if SCH_IS_SOCIAL_ENABLED == true
        IOSCPPHelper::facebookInviteFriends(linkApp, linkImage, promotionText, promotionCode);
    #endif
#endif
}

void FacebookAds::showBannerAd(int position)
{
#if(CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    return JniHelpers::jniCommonVoidCall(
                                         "ShowBannerAdFacebook",
                                         CLASS_NAME,
                                         position);
#elif(CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
#if SCH_IS_AD_FACEBOOK_ENABLED == true
    IOSCPPHelper::facebookShowBannerAds( position );
#endif
#endif
}

void FacebookAds::hideBannerAd( int position )
{
#if(CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    return JniHelpers::jniCommonVoidCall(
                                         "HideBannerAdFacebook",
                                         CLASS_NAME,
                                         position);
#elif(CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
#if SCH_IS_AD_FACEBOOK_ENABLED == true
    IOSCPPHelper::facebookHideBannerAds( position );
#endif
#endif
}

void FacebookAds::preLoadFullscreenAd()
{
#if(CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    return JniHelpers::jniCommonVoidCall(
                                         "PreLoadFullscreenAdFacebook",
                                         CLASS_NAME);
#elif(CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
#if SCH_IS_AD_FACEBOOK_ENABLED == true
    IOSCPPHelper::facebookPreloadFullscreenAds();
#endif
#endif
}

void FacebookAds::showPreLoadedFullscreenAd()
{
#if(CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    return JniHelpers::jniCommonVoidCall(
                                         "ShowPreLoadedFullscreenAdFacebook",
                                         CLASS_NAME);
#elif(CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
#if SCH_IS_AD_FACEBOOK_ENABLED == true
    IOSCPPHelper::facebookShowPreloadedFullscreenAds();
#endif
#endif
}

void FacebookAds::preloadNativeAd(int left, int top, int right, int bottom, int size_width)
{
#if(CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    return JniHelpers::jniCommonVoidCallFixInt(
                                         "PreloadNativeAdFacebook",
                                         CLASS_NAME,
                                         left,
                                         top,
                                         right,
                                         bottom,
                                         size_width);
#elif(CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
#if SCH_IS_AD_FACEBOOK_ENABLED == true
    IOSCPPHelper::facebookPreloadNativeAds(left, top, right, bottom, size_width);
#endif
#endif
}

void FacebookAds::showNativeAd()
{
#if(CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    return JniHelpers::jniCommonVoidCall(
                                         "ShowNativeAdFacebook",
                                         CLASS_NAME);
#elif(CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
#if SCH_IS_AD_FACEBOOK_ENABLED == true
    IOSCPPHelper::facebookShowNativeAds();
#endif
#endif
}

void FacebookAds::hideNativeAd()
{
#if(CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    return JniHelpers::jniCommonVoidCall(
                                         "HideNativeAdFacebook",
                                         CLASS_NAME);
#elif(CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
#if SCH_IS_AD_FACEBOOK_ENABLED == true
    IOSCPPHelper::facebookHideNativeAds();
#endif
#endif
}

void Twitter::Tweet(const char* tweet,const char* title, const char *imagePath)
{
	#if(CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
		JniHelpers::jniCommonVoidCall(
			"TwitterTweet",
			CLASS_NAME,
			tweet,
			title);
	#elif(CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
        #if SCH_IS_SOCIAL_ENABLED == true
            IOSCPPHelper::shareViaTwitter( tweet, imagePath );
        #endif
	#endif
}

void AdMob::showBannerAd(int position)
{
    #if(CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
		return JniHelpers::jniCommonVoidCall(
			"ShowBannerAd",
			CLASS_NAME,
			position);
    #elif(CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
        #if SCH_IS_AD_MOB_ENABLED == true
            IOSCPPHelper::admobShowBanner( position );
        #endif
	#endif
}

void AdMob::hideBannerAd( int position )
{
	#if(CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
		return JniHelpers::jniCommonVoidCall(
			"HideBannerAd",
			CLASS_NAME,
			position);
    #elif(CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
        #if SCH_IS_AD_MOB_ENABLED == true
            IOSCPPHelper::admobHideBanner( position );
        #endif
	#endif
}

void AdMob::showFullscreenAd()
{
#if(CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
		return JniHelpers::jniCommonVoidCall(
			"ShowFullscreenAdAM",
			CLASS_NAME);
   #elif(CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
	#if SCH_IS_AD_MOB_ENABLED == true
        IOSCPPHelper::admobShowFullscreenAd( );
    #endif
#endif
}

void AdMob::preLoadFullscreenAd()
{
#if(CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
		return JniHelpers::jniCommonVoidCall(
			"PreLoadFullscreenAdAM",
			CLASS_NAME);
   #elif(CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
	#if SCH_IS_AD_MOB_ENABLED == true
        //todo
    #endif
#endif
}

void AdMob::showPreLoadedFullscreenAd()
{
#if(CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
		return JniHelpers::jniCommonVoidCall(
			"ShowPreLoadedFullscreenAdAM",
			CLASS_NAME);
   #elif(CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
	#if SCH_IS_AD_MOB_ENABLED == true
        //todo
    #endif
#endif
}

void GoogleAnalytics::setScreenName( cocos2d::__String screenName )
{
#if(CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    return JniHelpers::jniCommonVoidCall(
                                         "SetGAScreenName",
                                         CLASS_NAME,
                                         screenName.getCString());

#elif(CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    #if SCH_IS_GOOGLE_ANALYTICS_ENABLED == true
        IOSCPPHelper::setGAScreenName( screenName );
    #endif
#endif
}

void GoogleAnalytics::setDispatchInterval( int dispatchInterval )
{
#if(CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    return JniHelpers::jniCommonVoidCall(
                                         "SetGADispatchInterval",
                                         CLASS_NAME,
                                         dispatchInterval);
#elif(CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    #if SCH_IS_GOOGLE_ANALYTICS_ENABLED == true
        IOSCPPHelper::setGADispatchInterval( dispatchInterval );
    #endif
#endif
}

void GoogleAnalytics::sendEvent( cocos2d::__String category, cocos2d::__String action, cocos2d::__String label, long value )
{
#if(CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    return JniHelpers::jniCommonVoidCall(
                                         "SendGAEvent",
                                         CLASS_NAME,
                                         category.getCString(),
                                         action.getCString(),
                                         label.getCString(),
                                         value);
#elif(CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    #if SCH_IS_GOOGLE_ANALYTICS_ENABLED == true
        IOSCPPHelper::sendGAEvent( category, action, label, value );
    #endif
#endif
}

void Notifications::scheduleLocalNotification( float delay, cocos2d::__String textToDisplay, cocos2d::__String notificationTitle , int notificationTag )
{
#if(CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
#elif(CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    #if SCH_IS_NOTIFICATIONS_ENABLED == true
        IOSCPPHelper::scheduleLocalNotification( delay, textToDisplay, notificationTitle ,notificationTag);
    #endif
#endif
}

void Notifications::scheduleLocalNotification( float delay, cocos2d::__String textToDisplay, cocos2d::__String notificationTitle, cocos2d::__String notificationAction , int notificationTag )
{
#if(CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
#elif(CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    #if SCH_IS_NOTIFICATIONS_ENABLED == true
        IOSCPPHelper::scheduleLocalNotification( delay, textToDisplay, notificationTitle, notificationAction ,notificationTag);
    #endif
#endif
}

void Notifications::scheduleLocalNotification( float delay, cocos2d::__String textToDisplay, cocos2d::__String notificationTitle, int repeatInterval , int notificationTag )
{
#if(CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
#elif(CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    #if SCH_IS_NOTIFICATIONS_ENABLED == true
        IOSCPPHelper::scheduleLocalNotification( delay, textToDisplay, notificationTitle, repeatInterval ,notificationTag);
    #endif
#endif
}

void Notifications::scheduleLocalNotification( float delay, cocos2d::__String textToDisplay, cocos2d::__String notificationTitle, cocos2d::__String notificationAction, int repeatInterval , int notificationTag )
{
#if(CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
#elif(CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    #if SCH_IS_NOTIFICATIONS_ENABLED == true
        IOSCPPHelper::scheduleLocalNotification( delay, textToDisplay, notificationTitle, notificationAction, repeatInterval , notificationTag );
    #endif
#endif
}

void Notifications::unscheduleAllLocalNotifications( )
{
#if(CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
#elif(CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    #if SCH_IS_NOTIFICATIONS_ENABLED == true
        IOSCPPHelper::unscheduleAllLocalNotifications( );
    #endif
#endif
}

void Notifications::unscheduleLocalNotification(  int notificationTag  )
{
#if(CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
#elif(CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    #if SCH_IS_NOTIFICATIONS_ENABLED == true
        IOSCPPHelper::unscheduleLocalNotification( notificationTag );
    #endif
#endif
}
