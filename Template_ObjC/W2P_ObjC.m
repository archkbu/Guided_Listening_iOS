#import "W2P_ObjC.h"
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

/*
 TO USE:
 w2p=[[W2P_ObjC alloc] init];
 [w2p setUIViewController:self withWebView:webView];
 [w2p setDelegatedMethod:@"passSomethings:para2:"];
 Because of the limitation of Objectective-C's method "performSelector", it only supports 0 to 2 parameters.
 */

@implementation W2P_ObjC

static NSString *serverLink=@"";
static NSObject *passToNextPageObject=nil;
static NSString *toNextPageLink=@"index";
static NSArray *networkUnavailable=nil;
static NSMutableArray *usedBookmarks=nil;
static BOOL hidesBackButton=NO;
static BOOL hidesNavigationBar=NO;
static NSString *nextPageTittle=@"";

+(void)setNetworkUnavailableWarning:(NSArray*)arr{
    networkUnavailable=arr;
}

+(void)setServerLink:(NSString*)link{
    serverLink=link;
}

+(NSObject*)getPassToNextPageObject{
    return passToNextPageObject;
}
+(void)setPassToNextPageObject:(NSDictionary*)d{
    passToNextPageObject=d;
}

+(NSString*)getToNextPageLink{
    return toNextPageLink;
}
+(void)setToNextPageLink:(NSString*)l{
    toNextPageLink=l;
}

+(BOOL)getHidesBackButton{
    return hidesBackButton;
}
+(void)setHidesBackButton:(BOOL)b{
    hidesBackButton=b;
}

+(BOOL)getHidesNavigationBar{
    return hidesNavigationBar;
}
+(void)setHidesNavigationBar:(BOOL)hnb{
    hidesNavigationBar=hnb;
}

+(NSString*)getNextPageTittle{
    return nextPageTittle;
}
+(void)setNextPageTittle:(NSString*)t{
    nextPageTittle=t;
}

+(NSObject*)getJSONFromNSURLRequest:(NSURLRequest*)request{
    NSString *link=[[[request URL]absoluteString] stringByRemovingPercentEncoding];
    NSArray *array=[link componentsSeparatedByString:@"://"];
    @try{
        NSString *cont=[array objectAtIndex:1];
        NSString *input=[cont stringByReplacingOccurrencesOfString:@"%u" withString:@"\\u"];
        NSString *convertedString=[input mutableCopy];
        CFStringRef transform=CFSTR("Any-Hex/Java");
        CFStringTransform((__bridge CFMutableStringRef)convertedString,NULL,transform,YES);
        NSObject *conJSONObject=[NSJSONSerialization JSONObjectWithData:[convertedString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        return conJSONObject;
    }
    @catch(NSException *exception){return nil;}
}

-(void)setDelegatedMethod:(NSString*)method{
    if(delegatedMethods==nil)delegatedMethods=[[NSMutableArray alloc] init];
    [delegatedMethods addObject:method];
}

-(void)setUIViewController:(UIViewController*)viewController withWebView:(UIWebView*)webView{
    callBackWhenWebViewDidFinishLoad=NO;
    vc=viewController;
    webV=webView;
    webV.mediaPlaybackRequiresUserAction=NO;
    webV.scrollView.bounces=NO;
    webView.delegate=self;
}

-(void)setCallBackWhenWebViewDidFinishLoad:(BOOL)bo{
    callBackWhenWebViewDidFinishLoad=bo;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
        if(passToNextPageObject!=nil){
            if(![passToNextPageObject isKindOfClass:[NSString class]])passToNextPageObject=[DeviceAPI dicarrToJsonString:passToNextPageObject];
            [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"Phone.setPassedByPreviousPageObject(%@);",passToNextPageObject]];
        }
        if(callBackWhenWebViewDidFinishLoad){
            SEL s=NSSelectorFromString(@"webViewDidFinishLoad:");
            [vc performSelector:s withObject:webView];
        }
}

-(void)showNetworkUnavailable{
    if(networkUnavailable!=nil){
        if(networkUnavailable.count==3){
            [vc presentViewController:[DeviceAPI getAlert:[networkUnavailable objectAtIndex:0] alertMsg:[networkUnavailable objectAtIndex:1] alertCancelBtn:[networkUnavailable objectAtIndex:2]] animated:YES completion:nil];
        }
    }
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString* link=[[[request URL]absoluteString] stringByRemovingPercentEncoding];
    if([link hasPrefix:@"toios://"]){
        NSDictionary *rDic=(NSDictionary*)[W2P_ObjC getJSONFromNSURLRequest:request];
        NSString *correctedName=nil;
        for(int i=0; i<delegatedMethods.count; i++){
            if([[delegatedMethods objectAtIndex:i] rangeOfString:[rDic objectForKey:@"message"]].location!=NSNotFound){
                correctedName=[delegatedMethods objectAtIndex:i];
            }
        }
        @try{
            NSArray *arr=(NSArray*)[rDic objectForKey:@"parameters"];
            if(correctedName==nil)correctedName=[rDic objectForKey:@"message"];
            if([correctedName isEqualToString:@"setTitle"]){
                [vc setTitle:[arr objectAtIndex:0]];
            }else if([correctedName isEqualToString:@"back"]){
                [vc.navigationController popViewControllerAnimated:YES];
            }else if([correctedName isEqualToString:@"toPage"]){
                if(arr.count==2)passToNextPageObject=[arr objectAtIndex:1];
                else passToNextPageObject=nil;
                @try{
                    [vc performSegueWithIdentifier:[arr objectAtIndex:0] sender:self];
                }@catch(NSException *e){
                    @try{
                        [vc.navigationController pushViewController:[vc.storyboard instantiateViewControllerWithIdentifier:[arr objectAtIndex:0]] animated:YES];
                    }@catch(NSException *ee){}
                }
            }else if([correctedName isEqualToString:@"toPageWithLink"]){
                passToNextPageObject=[arr objectAtIndex:1];
                toNextPageLink=[(NSDictionary*)passToNextPageObject objectForKey:@"link"];
                hidesBackButton=[[(NSDictionary*)passToNextPageObject objectForKey:@"hidesBackButton"] boolValue];
                hidesNavigationBar=[[(NSDictionary*)passToNextPageObject objectForKey:@"hidesNavigationBar"] boolValue];
                nextPageTittle=[(NSDictionary*)passToNextPageObject objectForKey:@"title"];
                @try{
                    [vc performSegueWithIdentifier:[arr objectAtIndex:0] sender:self];
                }@catch(NSException *e){
                    @try{
                        [vc.navigationController pushViewController:[vc.storyboard instantiateViewControllerWithIdentifier:[arr objectAtIndex:0]] animated:YES];
                    }@catch(NSException *ee){}
                }
            }else if([correctedName isEqualToString:@"getJsonFromServer"]){
                [self getJsonFromServer:[arr objectAtIndex:0] v:[arr objectAtIndex:1]];
            }else if([correctedName isEqualToString:@"getAndSaveJsonFromServer"]){
                [self getAndSaveJsonFromServer:[arr objectAtIndex:0] v:[arr objectAtIndex:1]];
            }else if([correctedName isEqualToString:@"getJsonFromAPP"]){
                BOOL isDoc=YES;
                if([[arr objectAtIndex:1] isEqualToString:@"NO"])isDoc=NO;
                NSObject *jObj=[DeviceAPI getJSONFromFile:[arr objectAtIndex:0] isDocument:isDoc];
                if(jObj!=nil)[webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"Phone.receiveJsonFromAPP(%@);",[DeviceAPI dicarrToJsonString:jObj]]];
                else[webView stringByEvaluatingJavaScriptFromString:@"Phone.receiveJsonFromAPP(null);"];
            }else if([correctedName isEqualToString:@"getJsonsFromAPP"]){
                BOOL isDoc=YES;
                if([[arr objectAtIndex:1] isEqualToString:@"NO"])isDoc=NO;
                NSMutableArray *marr=[[NSMutableArray alloc] init];
                NSArray *jArr=(NSArray*)[DeviceAPI getDicArrFromJSONString:[arr objectAtIndex:0]];
                for(int i=0; i<jArr.count; i++){
                    NSObject *jObj=[DeviceAPI getJSONFromFile:[jArr objectAtIndex:i] isDocument:isDoc];
                    [marr addObject:jObj];
                }
                [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"Phone.receiveJsonsFromAPP(%@);",[DeviceAPI dicarrToJsonString:marr]]];
            }else if([correctedName isEqualToString:@"saveJsonToAPP"]){
                [DeviceAPI dicarrToJsonFile:[DeviceAPI getDicArrFromJSONString:[arr objectAtIndex:1]] path:[arr objectAtIndex:0] isDocument:YES];
            }else if([correctedName isEqualToString:@"alert"]){
                NSDictionary *dic=(NSDictionary*)[DeviceAPI getDicArrFromJSONString:[arr objectAtIndex:0]];
                [vc presentViewController:[DeviceAPI getAlert:[dic objectForKey:@"title"] alertMsg:[dic objectForKey:@"msg"] alertCancelBtn:[dic objectForKey:@"cancel"]] animated:YES completion:nil];
            }else if([correctedName isEqualToString:@"toast"]){
                UIAlertController *co=[UIAlertController alertControllerWithTitle:nil message:[arr objectAtIndex:0] preferredStyle:UIAlertControllerStyleAlert];
                [vc presentViewController:co animated:YES completion:nil];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW,(int64_t)(0.8*NSEC_PER_SEC)), dispatch_get_main_queue(),^{
                    [co dismissViewControllerAnimated:YES completion:nil];
                });
            }else if([correctedName isEqualToString:@"prompt"]){
                NSDictionary *dic=(NSDictionary*)[DeviceAPI getDicArrFromJSONString:[arr objectAtIndex:0]];
                UIAlertController * alertController=[UIAlertController alertControllerWithTitle: [dic objectForKey:@"title"] message:[dic objectForKey:@"msg"] preferredStyle:UIAlertControllerStyleAlert];
                [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                    textField.placeholder=[dic objectForKey:@"placeholder"];
                    textField.textColor=[UIColor blackColor];
                    textField.clearButtonMode=UITextFieldViewModeWhileEditing;
                    [textField setTextAlignment:NSTextAlignmentCenter];
                }];
                [alertController addAction:[UIAlertAction actionWithTitle:[dic objectForKey:@"cancel"] style:UIAlertActionStyleCancel handler:nil]];
                [alertController addAction:[UIAlertAction actionWithTitle:[dic objectForKey:@"confirm"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    if(![alertController.textFields[0].text isEqualToString:@""]){
                        [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"Phone.promptAnswered('%@');",alertController.textFields[0].text]];
                    }
                }]];
                [vc presentViewController:alertController animated:YES completion:nil];
                [alertController.textFields[0] becomeFirstResponder];
            }else if([correctedName isEqualToString:@"confirmAlert"]){
                NSDictionary *dic=(NSDictionary*)[DeviceAPI getDicArrFromJSONString:[arr objectAtIndex:0]];
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[dic objectForKey:@"title"] message:[dic objectForKey:@"msg"] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:[dic objectForKey:@"cancel"] style:UIAlertActionStyleCancel handler:nil];
                [alertController addAction:cancelAction];
                UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:[dic objectForKey:@"confirm"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                    [webView stringByEvaluatingJavaScriptFromString:@"Phone.alertConfirmed();"];
                }];
                [alertController addAction:confirmAction];
                [vc presentViewController:alertController animated:YES completion:nil];
            }else if([correctedName isEqualToString:@"openBrowser"]){
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@://%@",[arr objectAtIndex:0],[arr objectAtIndex:1]]]];
            }else if([correctedName isEqualToString:@"getGPS"]){
                [self startGetGPS];
            }else if([correctedName isEqualToString:@"log"]){
                NSLog(@"%@",[arr objectAtIndex:0]);
            }else if([correctedName isEqualToString:@"useBookmarks"]){
                [self bookmarkUsingProcess:[arr objectAtIndex:0]];
            }else if([correctedName isEqualToString:@"getBookmarks"]){
                NSString *jStr=[self getBookmarksJSONString:[arr objectAtIndex:0]];
                [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"Phone.receiveBookmarks(%@)",jStr]];
            }else if([correctedName isEqualToString:@"checkHasBookmarks"]){
                NSMutableArray *marr=[[NSMutableArray alloc] init];
                NSArray *jArr=(NSArray*)[DeviceAPI getDicArrFromJSONString:[arr objectAtIndex:0]];
                for(int i=0; i<jArr.count; i++){
                    if([self getBookmarks:[jArr objectAtIndex:i]].count>0)[marr addObject:@YES];
                    else [marr addObject:@NO];
                }
                [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"Phone.receiveHasBookmarks(%@)",[DeviceAPI dicarrToJsonString:marr]]];
            }else if([correctedName isEqualToString:@"hasBookmarked"]){
                NSArray *arr2=[[arr objectAtIndex:0] componentsSeparatedByString:@"#####PHONEW2PBM#####"];
                BOOL hasBM=[self isAlreadyAddedToBookmarksWithString:[arr2 objectAtIndex:0] stringId:[arr2 objectAtIndex:1]];
                if(hasBM)[webView stringByEvaluatingJavaScriptFromString:@"Phone.receiveHasBookmarked(true);"];
                else [webView stringByEvaluatingJavaScriptFromString:@"Phone.receiveHasBookmarked(false);"];
            }else if([correctedName isEqualToString:@"addBookmark"]){
                [self addBookmarkWithString:[arr objectAtIndex:0] stringId:[arr objectAtIndex:1]];
            }else if([correctedName isEqualToString:@"removeBookmark"]){
                [self removeBookmarkWithString:[arr objectAtIndex:0] stringId:[arr objectAtIndex:1]];
            }else{
                SEL s=NSSelectorFromString(correctedName);
                if(arr==nil || arr.count==0)[vc performSelector:s];
                else if(arr.count==1)[vc performSelector:s withObject:[arr objectAtIndex:0]];
                else if(arr.count==2)[vc performSelector:s withObject:[arr objectAtIndex:0] withObject:[arr objectAtIndex:1]];
            }
        }
        @catch(NSException *exception){}
        return NO;
    }
    return YES;
}

-(void)getJsonFromServer:(NSString*)funid v:(NSString *)v{
    if([DeviceAPI connectedToNetwork]){
        NSDictionary *dic=(NSDictionary*)[DeviceAPI getDicArrFromJSONString:v];
        [DeviceAPI asyncInteractiveWithInternetByPassingDictionary:serverLink postDictionary:dic resultIsJSON:YES delegatedObject:self endSelector:@selector(setJsonToWeb:) withStringValue:funid];
    }else{
        [self showNetworkUnavailable];
    }
}

-(void)getAndSaveJsonFromServer:(NSString*)funid v:(NSString *)v{
    if([DeviceAPI connectedToNetwork]){
        NSDictionary *dic=(NSDictionary*)[DeviceAPI getDicArrFromJSONString:v];
        [DeviceAPI asyncInteractiveWithInternetByPassingDictionary:serverLink postDictionary:[dic objectForKey:@"data"] resultIsJSON:YES delegatedObject:self endSelector:@selector(setJsonToWeb:) withStringValue:funid];
        if(needSaveJsonArray==nil)needSaveJsonArray=[[NSMutableArray alloc] init];
        [needSaveJsonArray addObject:@{@"funid":funid, @"file":[dic objectForKey:@"file"]}];
    }else{
        [self showNetworkUnavailable];
    }
}

-(void)setJsonToWeb:(NSDictionary*)json{
    @try{
        NSString *funid=[json objectForKey:@"strValue"];
        NSObject *dic=[json objectForKey:@"result"];
        if(needSaveJsonArray!=nil){
            for(int i=0; i<needSaveJsonArray.count; i++){
                if([[[needSaveJsonArray objectAtIndex:i] objectForKey:@"funid"] isEqualToString:funid]){
                    [DeviceAPI dicarrToJsonFile:dic path:[[needSaveJsonArray objectAtIndex:i] objectForKey:@"file"] isDocument:YES];
                    [needSaveJsonArray removeObjectAtIndex:i];
                    break;
                }
            }
        }
        NSString *javascript=[NSString stringWithFormat:@"Phone.receiveJsonFromServer('%@',%@);",funid,[DeviceAPI dicarrToJsonString:dic]];
        [webV stringByEvaluatingJavaScriptFromString:javascript];
    }@catch(NSException *exception){NSLog(@"%@",exception);}
}

-(void)startGetGPS{
    locationManager=[[CLLocationManager alloc] init];
    locationManager.delegate=self;
    locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    locationManager.distanceFilter=kCLDistanceFilterNone;
    [locationManager requestWhenInUseAuthorization];
    [locationManager startMonitoringSignificantLocationChanges];
    [locationManager startUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"didFailWithError: %@", error);
    [vc presentViewController:[DeviceAPI getAlert:@"Error" alertMsg:@"Failed to Get Your Location" alertCancelBtn:@"OK"] animated:YES completion:nil];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    CLLocation *currentLocation=newLocation;
    if(currentLocation!=nil){
        [locationManager stopUpdatingLocation];
        [self getLocationFromGPSWithLatitude:currentLocation.coordinate.latitude andLongitude:currentLocation.coordinate.longitude];
    }
}

-(void)getLocationFromGPSWithLatitude:(float)latitude andLongitude:(float)longitude{
    [webV stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"Phone.setGPS(%f, %f)",latitude,longitude]];
}

-(void)bookmarkUsingProcess:(NSString*)strId{
    BOOL bmIsUsed=NO;
    if(usedBookmarks==nil)usedBookmarks=[[NSMutableArray alloc] init];
    else{
        for(int i=0; i<usedBookmarks.count; i++){
            if([[usedBookmarks objectAtIndex:i] isEqualToString:strId]){bmIsUsed=YES;break;}
        }
    }
    if(bmIsUsed==NO){
        [BookmarksHelper useBookmarks:strId];
        [usedBookmarks addObject:strId];
    }
}

-(NSMutableArray*)getBookmarks:(NSString*)name{
    [self bookmarkUsingProcess:name];
    return [BookmarksHelper getBookmarks:name];
}

-(NSString*)getBookmarksJSONString:(NSString*)name{
    [self bookmarkUsingProcess:name];
    return [BookmarksHelper getBookmarksJSONString:name];
}

-(void)addBookmarkWithString:(NSString*)name stringId:(NSString*)stringId{
    [self bookmarkUsingProcess:name];
    [BookmarksHelper addBookmarkWithString:name stringId:stringId];
}

-(void)removeBookmarkAtIndex:(NSString*)name index:(int)index{
    [self bookmarkUsingProcess:name];
    [BookmarksHelper removeBookmarkAtIndex:name index:index];
}

-(void)removeBookmarkWithString:(NSString*)name stringId:(NSString*)stringId{
    [self bookmarkUsingProcess:name];
    [BookmarksHelper removeBookmarkWithString:name stringId:stringId];
}

-(void)removeAllBookmarks:(NSString*)name{
    [self bookmarkUsingProcess:name];
    [BookmarksHelper removeAllBookmarks:name];
}

-(BOOL)isAlreadyAddedToBookmarksWithString:(NSString*)name stringId:(NSString*)stringId{
    [self bookmarkUsingProcess:name];
    return [BookmarksHelper isAlreadyAddedToBookmarksWithString:name stringId:stringId];
}

-(void)addOrRemoveBookmarksWithName:(NSString*)name stringId:(NSString*)stringId{
    if([self isAlreadyAddedToBookmarksWithString:name stringId:stringId]){
        [self removeBookmarkWithString:name stringId:stringId];
    }else{
        [self addBookmarkWithString:name stringId:stringId];
    }
}

@end
