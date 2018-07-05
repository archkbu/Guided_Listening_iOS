#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLLocationManagerDelegate.h>
#import "DeviceAPI.h"
#import "BookmarksHelper.h"

@interface W2P_ObjC : NSObject<UIWebViewDelegate,CLLocationManagerDelegate>{
    UIViewController *vc;
    UIWebView *webV;
    NSMutableArray *delegatedMethods;
    BOOL callBackWhenWebViewDidFinishLoad;
    NSMutableArray *needSaveJsonArray;
    CLLocationManager *locationManager;
}

+(void)setNetworkUnavailableWarning:(NSArray*)arr;
+(void)setServerLink:(NSString*)link;

+(NSObject*)getPassToNextPageObject;
+(NSString*)getToNextPageLink;
+(BOOL)getHidesBackButton;
+(BOOL)getHidesNavigationBar;
+(NSString*)getNextPageTittle;

-(void)setUIViewController:(UIViewController*)viewController withWebView:(UIWebView*)webView;
-(void)setDelegatedMethod:(NSString*)method;
-(void)setCallBackWhenWebViewDidFinishLoad:(BOOL)bo;
+(void)setPassToNextPageObject:(NSDictionary*)d;
+(void)setToNextPageLink:(NSString*)l;
+(void)setHidesBackButton:(BOOL)b;
+(void)setHidesNavigationBar:(BOOL)hnb;
+(void)setNextPageTittle:(NSString*)t;

-(void)startGetGPS;

@end
