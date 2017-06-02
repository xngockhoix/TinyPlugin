/*
 Copyright (C) 2015 Sonar Systems - All Rights Reserved
 You may use, distribute and modify this code under the
 terms of the MIT license
 
 Any external frameworks used have their own licenses and
 should be followed as such.
 */
//
//  SonarFrameworks.h
//  Sonar Cocos Helper
//
//  Created by Sonar Systems on 03/03/2015.
//
//

#ifndef __SONAR_FRAMEWORKS_H__
#define __SONAR_FRAMEWORKS_H__
#include "cocos2d.h"
#if(CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
#include "JNIHelpers.h"
#elif(CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
#include "SCHDefinitions.h"
#endif

bool isiOS();
bool isAndroid();


namespace SonarCocosHelper
{
	enum AdBannerPosition { eBottom, eTop, eBoth };

    class GooglePlayServices
    {
    public:
        /**
         * Check if the user is signed in
         * @return true is signed in, false is not signed in
         */
        static bool isSignedIn( );
        /**
         * Sign the user in
         */
        static void signIn( );
        /**
         * Sign the user out
         */
        static void signOut();
        /**
         * Submit score to online leaderboard
         * @param leaderboardID is the name of your leaderboard
         * @param score is the score to submit online
         */
        static void submitScore( const char *leaderboardID, long score );
        /**
         * Unlock achievement
         * @param achievementID is the achievement to unlock
         */
        static void unlockAchievement( const char *achievementID );
        /**
         * Increment incremental achievement
         * @param achievementID is the achievement to increment
         * @param numSteps is the number of steps to increase achievement by
         */
        static void incrementAchievement( const char *achievementID, int numSteps );
        /**
         * Show the achievements
         */
        static void showAchievements( );
        /**
         * Show leaderboards
         */
        static void showLeaderboards( );
        /**
         * Show leaderboard
         * @param leaderboardID is the leaderboard to display
         */
        static void showLeaderboard( const char *leaderboardID );
    };

    class IOS
    {
    public:
        /**
         * Initializes the Cocos Helper for use, only needs to be called once
         */
        static void Setup( );
        /**
         * Opens the share dialog
         * @param shareString is the string to share
         * @param imagePath is the path to an image to share as well (optional)
         */
    };

    class Facebook
    {
    public:
        //static void SignIn(); not needed for NOW
        /**
         * Share to Facebook
         * @param name is the post title (optional)
         * @param link is a link to be attached to the post (optional)
         * @param description is the text to post
         * @param caption is a caption to the main post (optional)
         * @param imagePath is the path to an image to share as well (optional)
         */
        static void facebookShareLink(const char* title, const char* linkApp, const char* linkImage, const char* desciption, const char* quote, const char* hashtag);
        static void facebookShareImage(const char* imagePathLocal, const char* caption, const char* hashTag);
        static void facebookInviteFriends(const char* linkApp, const char* linkImage, const char* promotionText, const char* promotionCode);
    };
    
    class FacebookAds
    {
    public:
        /**
         * Show a banner on the top of the screen
         * @param SonarCocosHelper::eTop displays the ad banner at the top of the screen
         * @param SonarCocosHelper::eBottom displays the ad banner at the bottom of the screen
         * @param SonarCocosHelper::eBoth displays the a ad banner on the top and the bottom
         */
        static void showBannerAd( int position );
        /**
         * Hide a banner on the top of the screen
         * @param SonarCocosHelper::eTop hide the ad banner at the top of the screen
         * @param SonarCocosHelper::eBottom hide the ad banner at the bottom of the screen
         * @param SonarCocosHelper::eBoth hides all visible ad banners
         */
        static void hideBannerAd( int position );
        /**
         * preload a fullscreen interstitial ad
         */
        static void preLoadFullscreenAd();
        /**
         * shows the preloaded fullscreen interstitial ad
         */
        static void showPreLoadedFullscreenAd();
        /**
         * preload native ads.
         */
        static void preloadNativeAd(int left, int top, int right, int bottom, int size_width);
        /**
         * shows the preloaded native ad
         */
        static void showNativeAd();
        /**
         * hide the preloaded native ad
         */
        static void hideNativeAd();
    };

    class Twitter
    {
    public:
        /**
         * Tweet to Twitter
         * @param description is the text to tweet
         * @param title is the tweet title (optional)
         * @param imagePath is the path to an image to tweet as well (optional)
         */
        static void Tweet( const char *tweet, const char *title, const char *imagePath );
    };

    class AdMob
    {
    public:
        /**
         * Show a banner on the top of the screen
         * @param SonarCocosHelper::eTop displays the ad banner at the top of the screen
         * @param SonarCocosHelper::eBottom displays the ad banner at the bottom of the screen
         * @param SonarCocosHelper::eBoth displays the a ad banner on the top and the bottom
         */
        static void showBannerAd( int position );
        /**
         * Hide a banner on the top of the screen
         * @param SonarCocosHelper::eTop hide the ad banner at the top of the screen
         * @param SonarCocosHelper::eBottom hide the ad banner at the bottom of the screen
         * @param SonarCocosHelper::eBoth hides all visible ad banners
         */
        static void hideBannerAd( int position );
        /**
         * Load and then Shows a fullscreen interstitial ad
         */
        static void showFullscreenAd( );
        /**
		 * preload a fullscreen interstitial ad
		 */
        static void preLoadFullscreenAd();
        /**
		 * shows the preloaded fullscreen interstitial ad
		 */
		static void showPreLoadedFullscreenAd();
    };

    class GameCenter
    {
    public:
        /**
         * Sign the user in
         */
        static void signIn( );
        /**
         * Show leaderboard
         */
        static void showLeaderboard( );
        /**
         * Show achievements
         */
        static void showAchievements( );
        /**
         * Submit score to online leaderboard
         * @param scoreNumber is the score to submit online
         * @param leaderboardID is the name of your leaderboard
         */
        static void submitScore( int scoreNumber, cocos2d::__String leaderboardID );
        /**
         * Unlock achievement
         * @param achievementID is the achievement to unlock
         */
        static void unlockAchievement( cocos2d::__String achievementID );
        /**
         * Unlock percentage of an achievement
         * @param achievementID is the achievement to increment
         * @param percent is the percentage of the achievement to unlock
         */
        static void unlockAchievement( cocos2d::__String achievementID, float percent );
        /**
         * Reset all player achievements (cannot be undone)
         */
        static void resetPlayerAchievements( );
    };
    
    class GoogleAnalytics
    {
    public:
        /**
         * Set the screen name
         * @param screenName string to set for the screen
         */
        static void setScreenName( cocos2d::__String screenName );
        /**
         * Set dispatch interval (frequency of which data is submitted to the server)
         * @param dispatchInterval submit frequency
         */
        static void setDispatchInterval( int dispatchInterval );
        /**
         * Set a custom event
         * @param category (required) a string of what the event category is
         * @param action (required) a string of what the action performed is
         * @param label (optional) a string of what the label for the action is
         * @param label (optional, only for Android not iOS) a value of the event that has occurred
         */
        static void sendEvent( cocos2d::__String category, cocos2d::__String action, cocos2d::__String label, long value );
    };

    class Notifications
    {
    public:
        /**
         * schedule local notification
         * @param delay is the amount of time until the notification is display from the time this method is called
         * @param textToDisplay is the text to display in the notification
         * @param notificationTitle is the title for the notification
         */
        static void scheduleLocalNotification( float delay, cocos2d::__String textToDisplay, cocos2d::__String notificationTitle , int notificationTag);
        /**
         * schedule local notification with slide action text
         * @param delay is the amount of time until the notification is display from the time this method is called
         * @param textToDisplay is the text to display in the notification
         * @param notificationTitle is the title for the notification
         * @param notificationAction is the text that appears below the message on the lock screen aka slide to action
         */
        static void scheduleLocalNotification( float delay, cocos2d::__String textToDisplay, cocos2d::__String notificationTitle, cocos2d::__String notificationAction , int notificationTag);
        /**
         * schedule local notification with a repeat interval
         * @param delay is the amount of time until the notification is display from the time this method is called
         * @param textToDisplay is the text to display in the notification
         * @param notificationTitle is the title for the notification
         * @param repeatInterval is how often you want to repeat the action
         */
        static void scheduleLocalNotification( float delay, cocos2d::__String textToDisplay, cocos2d::__String notificationTitle, int repeatInterval , int notificationTag);
        /**
         * schedule local notification with slide action text and a repeat interval
         * @param delay is the amount of time until the notification is display from the time this method is called
         * @param textToDisplay is the text to display in the notification
         * @param notificationTitle is the title for the notification
         * @param notificationAction is the text that appears below the message on the lock screen aka slide to action
         * @param repeatInterval is how often you want to repeat the action
         */
        static void scheduleLocalNotification( float delay, cocos2d::__String textToDisplay, cocos2d::__String notificationTitle, cocos2d::__String notificationAction, int repeatInterval , int notificationTag);
        
        /**
         * unschedule all local notifications
         */
        static void unscheduleAllLocalNotifications( );
        /**
         * unschedule local notification
         * @param notificationTitle is the notification that should be unscheduled
         */
        //static void unscheduleLocalNotification( cocos2d::__String notificationTitle );
        static void unscheduleLocalNotification( int notificationTag );
        
    };
}

#endif
