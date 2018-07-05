#import "BookmarksHelper.h"

@implementation BookmarksHelper

static NSMutableArray *bmFiles;
static NSString *prefixOfJSONFile=@"bm_";
static NSString *defaultName=@"bookmarks";

+(void)useBookmarks:(NSString*)name{
    if(name==nil)name=defaultName;
    if(bmFiles==nil)bmFiles=[[NSMutableArray alloc] init];
    NSMutableArray *jsonArray=nil;
    NSString *jsonfileNewName=[NSString stringWithFormat:@"%@%@",prefixOfJSONFile,name];
    BOOL alreadyHas=[DeviceAPI isFileExist:jsonfileNewName isDocument:YES type:@"json"];
    if(!alreadyHas){
        NSString *usedtPath=[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@.json",jsonfileNewName]];
        [@"[]" writeToFile:usedtPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
        jsonArray=[[NSMutableArray alloc] init];
    }else{
        jsonArray=[BookmarksHelper getBookmarksFromDevice:name];
    }
    NSDictionary *dic=[[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:name,jsonArray,nil] forKeys:[NSArray arrayWithObjects:@"name",@"object",nil]];
    [bmFiles addObject:dic];
}

+(NSMutableArray*)getBookmarksFromDevice:(NSString*)name{ // Private
    NSString *jsonfileNewName=[NSString stringWithFormat:@"%@%@",prefixOfJSONFile,name];
    NSArray *jArr=(NSArray*)[DeviceAPI getJSONFromFile:jsonfileNewName isDocument:YES];
    NSMutableArray *jMArr=[[NSMutableArray alloc] init];
    for(int i=0; i<jArr.count; i++){
        [jMArr addObject:[jArr objectAtIndex:i]];
    }
    return jMArr;
}

+(NSMutableArray*)getBookmarks:(NSString*)name{
    if(name==nil)name=defaultName;
    for(int i=0; i<bmFiles.count; i++){
        if([[[bmFiles objectAtIndex:i] objectForKey:@"name"] isEqualToString:name])
            return [[bmFiles objectAtIndex:i] objectForKey:@"object"];
    }
    return nil;
}

+(NSString*)getBookmarksJSONString:(NSString*)name{
    if(name==nil)name=defaultName;
    return [DeviceAPI dicarrToJsonString:[BookmarksHelper getBookmarks:name]];
}

+(void)addBookmark:(NSString*)name object:(NSObject*)object{ // Private
    NSString *jsonfileNewName=[NSString stringWithFormat:@"%@%@",prefixOfJSONFile,name];
    NSMutableArray *mArr=[BookmarksHelper getBookmarks:name];
    [mArr addObject:object];
    [DeviceAPI dicarrToJsonFile:mArr path:jsonfileNewName isDocument:YES];
}

+(void)addBookmarkWithInt:(NSString*)name intId:(int)intId{
    if(name==nil)name=defaultName;
    [BookmarksHelper addBookmark:name object:[NSNumber numberWithInt:intId]];
}

+(void)addBookmarkWithString:(NSString*)name stringId:(NSString*)stringId{
    if(name==nil)name=defaultName;
    [BookmarksHelper addBookmark:name object:stringId];
}

+(void)removeBookmarkAtIndex:(NSString*)name index:(int)index{
    if(name==nil)name=defaultName;
    NSString *jsonfileNewName=[NSString stringWithFormat:@"%@%@",prefixOfJSONFile,name];
    NSMutableArray *mArr=[BookmarksHelper getBookmarks:name];
    [mArr removeObjectAtIndex:index];
    [DeviceAPI dicarrToJsonFile:mArr path:jsonfileNewName isDocument:YES];
}

+(void)removeBookmarkWithInt:(NSString*)name intId:(int)intId{
    if(name==nil)name=defaultName;
    NSString *jsonfileNewName=[NSString stringWithFormat:@"%@%@",prefixOfJSONFile,name];
    NSMutableArray *mArr=[BookmarksHelper getBookmarks:name];
    for(int i=0; i<mArr.count; i++){
        if([[mArr objectAtIndex:i] intValue]==intId)
            [mArr removeObjectAtIndex:i];
    }
    [DeviceAPI dicarrToJsonFile:mArr path:jsonfileNewName isDocument:YES];
}

+(void)removeBookmarkWithString:(NSString*)name stringId:(NSString*)stringId{
    if(name==nil)name=defaultName;
    NSString *jsonfileNewName=[NSString stringWithFormat:@"%@%@",prefixOfJSONFile,name];
    NSMutableArray *mArr=[BookmarksHelper getBookmarks:name];
    for(int i=0; i<mArr.count; i++){
        if([[mArr objectAtIndex:i] isEqualToString:stringId])
            [mArr removeObjectAtIndex:i];
    }
    [DeviceAPI dicarrToJsonFile:mArr path:jsonfileNewName isDocument:YES];
}

+(void)removeAllBookmarks:(NSString*)name{
    if(name==nil)name=defaultName;
    NSString *jsonfileNewName=[NSString stringWithFormat:@"%@%@",prefixOfJSONFile,name];
    NSMutableArray *mArr=[BookmarksHelper getBookmarks:name];
    [mArr removeAllObjects];
    [DeviceAPI dicarrToJsonFile:mArr path:jsonfileNewName isDocument:YES];
}

+(BOOL)isAlreadyAddedToBookmarksWithInt:(NSString*)name intId:(int)intId{
    if(name==nil)name=defaultName;
    NSMutableArray *mArr=[BookmarksHelper getBookmarks:name];
    for(int i=0; i<mArr.count; i++){
        if([[mArr objectAtIndex:i] intValue]==intId)return YES;
    }
    return NO;
}

+(BOOL)isAlreadyAddedToBookmarksWithString:(NSString*)name stringId:(NSString*)stringId{
    if(name==nil)name=defaultName;
    NSMutableArray *mArr=[BookmarksHelper getBookmarks:name];
    for(int i=0; i<mArr.count; i++){
        if([[mArr objectAtIndex:i] isEqualToString:stringId])return YES;
    }
    return NO;
}

@end