//  Created by Dave Fung.
//  Copyright (c) 2015 Hong Kong Baptist University. All rights reserved.

#import "UniversityVC.h"

@interface UniversityVC ()

@end

@implementation UniversityVC

-(void)toNextPage{
    if([DeviceAPI isFirstTimeUse] || [GlobalValues getIsOnDemo])[self performSegueWithIdentifier:@"UniversityToWTAVC" sender:self];
    else{
        [W2P_ObjC setHidesNavigationBar:YES];
        [W2P_ObjC setHidesBackButton:YES];
        [W2P_ObjC setNextPageTittle:@"Home"];
        [self performSegueWithIdentifier:@"UniversityToHomeVC" sender:self];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:YES];
    [self.navigationItem setHidesBackButton:YES animated:YES];
    webv.scrollView.bounces=NO;
    [webv loadRequest:[NSURLRequest requestWithURL:[[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"splash_web/university" ofType:@"html"]]]];
    webv.mediaPlaybackRequiresUserAction=NO;
    [NSTimer scheduledTimerWithTimeInterval:3.1 target:self selector:@selector(toNextPage) userInfo:nil repeats:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
