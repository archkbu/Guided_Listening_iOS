#import <Foundation/Foundation.h>
#import "DeviceAPI.h"

@interface BookmarksHelper : NSObject

+(void)useBookmarks:(NSString*)name;
+(NSMutableArray*)getBookmarks:(NSString*)name;
+(NSString*)getBookmarksJSONString:(NSString*)name;
+(void)addBookmark:(NSString*)name object:(NSObject*)object;
+(void)addBookmarkWithInt:(NSString*)name intId:(int)intId;
+(void)addBookmarkWithString:(NSString*)name stringId:(NSString*)stringId;
+(void)removeBookmarkAtIndex:(NSString*)name index:(int)index;
+(void)removeBookmarkWithInt:(NSString*)name intId:(int)intId;
+(void)removeBookmarkWithString:(NSString*)name stringId:(NSString*)stringId;
+(void)removeAllBookmarks:(NSString*)name;
+(BOOL)isAlreadyAddedToBookmarksWithInt:(NSString*)name intId:(int)intId;
+(BOOL)isAlreadyAddedToBookmarksWithString:(NSString*)name stringId:(NSString*)stringId;

@end