#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h>
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

@interface DeviceAPI : NSObject

+(int)getScreenWidth;
+(int)getScreenHeight;
+(BOOL)getIsIPad;
+(NSString*)getiOSDevice;
+(UIViewController*)getUIStoryboard:(NSString*)vcName;
+(void)killme:(UIWebView*)webv;
+(int)getMinInArray:(NSArray*)arr;
+(int)getMaxInArray:(NSArray*)arr;
+(UIImage*)imageByScalingToSize:(CGSize)targetSize sourceImage:(UIImage*)sImg;
+(UIAlertController*)getAlert:(NSString*)alertTitle alertMsg:(NSString*)alertMsg alertCancelBtn:(NSString*)alertCancelBtn;
+(void)showAlert:(UIViewController*)vc alertTitle:(NSString*)alertTitle alertMsg:(NSString*)alertMsg alertCancelBtn:(NSString*)alertCancelBtn;
+(void)showConfirmAlert:(UIViewController*)vc withAlertTitle:(NSString*)alertTitle alertMsg:(NSString*)alertMsg alertCancelBtn:(NSString*)alertCancelBtn alertConfirmBtn:(NSString*)alertConfirmBtn stringId:(NSString*)stringId;
+(void)showToast:(UIViewController*)vc toastTitle:(NSString*)toastTitle;
+(NSString*)getFileString:(NSString*)path isDocument:(BOOL)isDocument type:(NSString*)type;
+(NSObject*)getDicArrFromJSONString:(NSString*)str;
+(NSObject*)getJSONFromFile:(NSString*)path isDocument:(BOOL)isDocument;
+(NSObject*)getJSONFromJSFile:(NSString*)path isDocument:(BOOL)isDocument;
+(NSString*)dicarrToJsonString:(NSObject*)obj;
+(void)writeStringToFile:(NSString*)jString path:(NSString*)path;
+(void)dicarrToJsonFile:(NSObject*)obj path:(NSString*)path isDocument:(BOOL)isDocument;
+(BOOL)isFileExist:(NSString*)path isDocument:(BOOL)isDocument type:(NSString*)type;
+(void)deleteFile:(NSString*)path isDocument:(BOOL)isDocument type:(NSString*)type;
+(BOOL)isFirstTimeUse;
+(void)setAppUsed;
+(void)setAppUsedWithDic:(NSDictionary*)dic;
+(NSDictionary*)getUserDic;
+(NSString*)getNowDateTime;
+(NSString*)getNowDateTime2;
+(NSString*)encodeUIImageToBase64String:(UIImage*)image;
+(NSString*)encodeUIImageToBase64StringWithJPG:(UIImage*)image;
+(UIImage*)decodeBase64ToUIImage:(NSString*)strEncodeData;
+(BOOL)connectedToNetwork;
+(void)asyncInteractiveWithInternet:(NSString*)link postString:(NSString*)postString resultIsJSON:(BOOL)resultIsJSON delegatedObject:(id)delegatedObject endSelector:(SEL)endSelector;
+(void)asyncInteractiveWithInternet:(NSString*)link postString:(NSString*)postString resultIsJSON:(BOOL)resultIsJSON delegatedObject:(id)delegatedObject endSelector:(SEL)endSelector withStringValue:(NSString*)strValue;
+(void)asyncInteractiveWithInternetByPassingDictionary:(NSString*)link postDictionary:(NSDictionary*)postDictionary resultIsJSON:(BOOL)resultIsJSON delegatedObject:(id)delegatedObject endSelector:(SEL)endSelector;
+(void)asyncInteractiveWithInternetByPassingDictionary:(NSString*)link postDictionary:(NSDictionary*)postDictionary resultIsJSON:(BOOL)resultIsJSON delegatedObject:(id)delegatedObject endSelector:(SEL)endSelector withStringValue:(NSString*)strValue;
+(void)downloadImageFrom:(NSString*)path toDeviceWithPath:(NSString*)name withWebView:(UIWebView*)webv withMethodName:(NSString*)methodName;
+(NSString*)downloadImageAndGetBase64StringFrom:(NSString*)path toDeviceWithPath:(NSString*)name;
+(NSString*)downloadImageAndGetBase64StringFrom:(NSString*)path toDeviceWithPath:(NSString*)name withSaclingWidth:(int)width andHeight:(int)height;
+(void)downloadImage:(NSString*)path toDeviceWithPath:(NSString*)name;
+(void)setAppDelegate:(id)ap;

@end
