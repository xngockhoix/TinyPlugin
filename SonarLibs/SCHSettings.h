/*
 Copyright (C) 2015 Sonar Systems - All Rights Reserved
 You may use, distribute and modify this code under the
 terms of the MIT license
 
 Any external frameworks used have their own licenses and
 should be followed as such.
*/
//
//  SCHSettings.h
//  Sonar Cocos Helper
//
//  Created by Sonar Systems on 03/03/2015.
//
//

#ifndef __SCHSettings_h__
#define __SCHSettings_h__

/*
 USING PODS
 
 pod 'FBSDKCoreKit'
 pod 'FBSDKLoginKit'
 pod 'FBSDKMessengerShareKit'
 pod 'FBSDKShareKit'
 pod 'FBAudienceNetwork'
 
 */

#define SCH_IS_AD_MOB_ENABLED false // AdSupport.framework, AudioToolbox.framework, AVFoundation.framework, CoreGraphics.framework, CoreMedia.framework, CoreTelephony.framework, EventKit.framework, EventKitUI.framework, MessageUI.framework, StoreKit.framework, SystemConfiguration.framework

#define SCH_IS_AD_FACEBOOK_ENABLED false // CoreMedia.framework, FBAudienceNetwork.framework

#define SCH_IS_SOCIAL_ENABLED true // Social.framework

#define SCH_IS_GAME_CENTER_ENABLED true // Social.framework, GameKit.framework

#define SCH_IS_GOOGLE_ANALYTICS_ENABLED false // CoreData.framework, SystemConfiguration.framework, libz.dylib, libsqlite3.dylib, libGoogleAnalyticsServices.a, libAdIdAccess.a, AdSupport.framework, iAd.framework, GameController.framework
// GOOGLE ANALYTICS also needs these Linker flags for IDFA
// -framework AdSupport
// -force_load "${SRCROOT}/GoogleAnalyticsFramework/libAdIdAccess.a"

#define SCH_IS_NOTIFICATIONS_ENABLED false

#define SCH_AD_FACEBOOK_BANNER_ID       @""
#define SCH_AD_FACEBOOK_FULLSCREEN_ID   @""
#define SCH_AD_FACEBOOK_NATIVE_ID       @""

#define SCH_AD_MOB_BANNER_AD_UNIT_ID        @""
#define SCH_AD_MOB_FULLSCREEN_AD_UNIT_ID    @""
#define SCH_TEST_DEVICE     @""

#define SCH_GOOGLE_ANALYTICS_TRACKING_ID @""

#endif
