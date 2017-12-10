//
//  Global.h
//

//  Copyright 2015 Kapova. All rights reserved.
//
@class SettingView;
@class RadioListnerAppDelegate;

@class MasterViewController;
@class TwitterAccountListViewController;
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>
#import "SettingView.h"


#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>


#import <FacebookSDK/FacebookSDK.h>




#import "AppDelegate.h"

#import "GAIDictionaryBuilder.h"
#import "TwitterAccountListViewController.h"

//AppDelegate *appDelegate;


#define TMP NSTemporaryDirectory()



#define IOS_OLDER_THAN_6 ( [ [ [ UIDevice currentDevice ] systemVersion ] floatValue ] < 6.0 )
#define IOS_NEWER_OR_EQUAL_TO_6 ( [ [ [ UIDevice currentDevice ] systemVersion ] floatValue ] >= 6.0 )


// Share with a friend

#define  FBAppID @"empty"
#define kOAuthConsumerKey				@"empty"
#define kOAuthConsumerSecret			@"empty"


#define FacebookShareString @"empty"
#define FacebookShareURL @"http://www.kapova.com/store"


#define TwitterShareString @"empty"
#define TwitterShareURL @"http://www.kapova.com/store"

#define MessageShare @"empty"

#define MessageSubject @"empty"
#define MailShare @"empty"



//XML Files
#define PhotoURL @"http://www.kapova.com/store/ios/portfolioapp/xml/PhotoApp_gallery.xml"
#define VideoURL @"http://www.kapova.com/store/ios/portfolioapp/xml/photoApp_videos.xml"
#define ArtistURL @"http://www.kapova.com/store/ios/portfolioapp/xml/PhotoApp_about.xml"
#define MapsURL @"http://www.kapova.com/store/ios/portfolioapp/xml/photoApp_map.xml"
#define BookAnAppoitmentURL @"http://www.kapova.com/store/ios/portfolioapp/bookAppointment/index.php"



//Homescreen Headings
#define kGallery @"Gallery"
#define kVideos  @"Videos"
#define kAppointment @"Book an Appointment"
#define kLocateUs @"Locate Us"
#define kArtist @"The Artist"
#define KNews   @"News & Press"
#define kAbout @"About"

#define kHTML @"Z_HTML"
#define kGalleryIndex  1
#define kVideoIndex  2
#define kAppointmentIndex  3
#define kLocateUsIndex 4
#define kArtistIndex  5
#define kAboutUsIndex 6
#define kNewsIndex 7

//DEFINE HTML.
#define kHTMLIndex1 8
#define kHTMLIndex2 9
#define kHTMLIndex3 10

#define kHTMLName1 @"html name 1"
#define kHTMLName2 @"html name 2"
#define kHTMLName3 @"html name 3"


#define kHtmlURL1 @"1"
#define kHtmlURL2 @"2"
#define kHtmlURL3 @"http://yahoo.com"


// Google Analytics

#define GoogleAnalyticsTrackID  @"UA-xxxxxx"

#define AboutUsCallButton @"button Call clicked"
#define AboutUsWebSiteButton @"Open WebSite clicked"
#define AboutUsEmailButton @"Email clicked"

#define GalleryShareButton @"Share Button clicked"
#define GalleryMessageShareButton @"Message Share Button clicked"
#define GalleryEmailShareButton @"Email Share Button clicked"
#define GalleryTwitterShareButton @"Twitter Share Button clicked"
#define GalleryFacebookShareButton @"Facebook Share Button clicked"


#define DetailPhotoview @"photo viewed"
#define DetailPhotoviewPreviousButtonClicked @"Previous button Clicked"
#define DetailPhotoviewNextButtonClicked @"Next button Clicked"
#define DetailPhotoviewActionButtonClicked @"Action button clicked"
#define DetailPhotoviewActionSaveButtonClicked @"Action button Save clicked"
#define DetailPhotoviewActionCopyButtonClicked @"Action button Copy  clicked"
#define DetailPhotoviewActionEmailButtonClicked @"Action button Email clicked"


#define ArtistCallButton @"Artist button Call Clicked"
#define ArtistWebSiteButton @"Artist Open WebSite Clicked"
#define ArtistEmailButton @"Artist Email Clicked"
#define ArtistTwitterButton @"Artist Open WebSite Clicked"
#define ArtistFacebookButton @"Artist Email Clicked"

#define  kGAIScreenName @"ScreenName"



//Please don't change the below
#define webViewURL @"http://kapova.com"
#define NewsURL @"http://www.kapova.com"
#define aboutUSURL @"http://www.kapova.com"

//DEFINE APP INFO (used for sharing)
#define kShareAppName @"PORTFOLIO"
#define kShareLinkApp @"http://kapova.com"
#define kShareTextArtist @"Put Some Text Sharing Here"
#define kShareIconName @"144x144.png"
//End