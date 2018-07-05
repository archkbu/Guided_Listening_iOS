#import <UIKit/UIKit.h>
#import "GlobalValues.h"
#import "W2P_ObjC.h"

@interface VC : UIViewController<UIWebViewDelegate>{
    IBOutlet UIWebView *webv;
    W2P_ObjC *w2p;
    NSString *nowLink;
    BOOL isRegistering;
}

@end

