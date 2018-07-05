#import "VC.h"

@interface VC ()

@end

@implementation VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setHidden:[W2P_ObjC getHidesNavigationBar]];
    [self.navigationItem setHidesBackButton:[W2P_ObjC getHidesBackButton] animated:YES];
    
    w2p=[[W2P_ObjC alloc] init];
    [w2p setUIViewController:self withWebView:webv];
    
    self.title=[W2P_ObjC getNextPageTittle];
    nowLink=[W2P_ObjC getToNextPageLink];
    
    [webv loadRequest:[NSURLRequest requestWithURL:[[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"web/%@",nowLink] ofType:@"html"]]]];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if([nowLink isEqualToString:@"index"]){
        [self.navigationController.navigationBar setHidden:YES];
        [self.navigationItem setHidesBackButton:YES animated:YES];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    if([nowLink rangeOfString:@"fcmenu"].location!=NSNotFound){
        dispatch_async(dispatch_get_main_queue(), ^{
            [webv stringByEvaluatingJavaScriptFromString:@"refreshBM();"];
        });
    }
}

-(void)didMoveToParentViewController:(UIViewController *)parent{
    [super willMoveToParentViewController:parent];
    if(![parent isEqual:self.parentViewController]){
        [DeviceAPI killme:webv];
    }
}

-(void)reloadFCWeb{
    NSLog(@"hi");
    [webv loadRequest:[NSURLRequest requestWithURL:[[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"web/%@",nowLink] ofType:@"html"]]]];
}

-(void)toAbout{
    [self performSegueWithIdentifier:@"popAbout2VC" sender:self];
}

-(void)toWTA2{
    [self performSegueWithIdentifier:@"popWta2VC" sender:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
