//  Created by Dave Fung.
//  Copyright (c) 2015 Hong Kong Baptist University. All rights reserved.

#import "GlobalValues.h"

@implementation GlobalValues

static BOOL showPasswordPageFFTU=NO;
static NSString *appPassword=@"root";
static BOOL isOnDemo=NO;

+(void)setShowPasswordPageForFirstTimeUsing:(BOOL)isNeed{
    showPasswordPageFFTU=isNeed;
}

+(BOOL)getShowPasswordPageForFirstTimeUsing{
    return showPasswordPageFFTU;
}

+(void)setAppPassword:(NSString*)password{
    appPassword=password;
}

+(NSString*)getAppPassword{
    return appPassword;
}

+(void)setIsOnDemo:(BOOL)v{
    isOnDemo=v;
}

+(BOOL)getIsOnDemo{
    return isOnDemo;
}

@end