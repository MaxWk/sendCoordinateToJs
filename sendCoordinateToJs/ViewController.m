//
//  ViewController.m
//  sendCoordinateToJs
//
//  Created by MAX_W on 16/6/29.
//  Copyright © 2016年 MAX_W. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "WebViewJavascriptBridge.h"
@interface ViewController ()<UIWebViewDelegate,CLLocationManagerDelegate>
{
    UIWebView *vb;
}
@property WebViewJavascriptBridge* bridge;
@property(nonatomic,strong) CLLocationManager *locationManager;
@property(nonatomic,strong) NSDictionary *tempDictionary;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    vb = [[UIWebView alloc]initWithFrame:CGRectMake(0, 20, 375, 667-20 )];
    vb.delegate = self;
    [self.view addSubview:vb];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"html"];
    NSURL *url  = [NSURL fileURLWithPath:path];
    // NSURL *url = [[NSURL alloc]initWithString:@"http://www.huami-tech.com/"];
    
    
    //    NSURL *url = [[NSURL alloc]initWithString:@"http://www.huami-tech.com/pan/babywheretogo/main.html"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    
    
    [vb loadRequest:request];
    [(UIScrollView *)[[vb subviews] objectAtIndex:0] setBounces:NO];
    
    if (_bridge) { return; }
    
    [WebViewJavascriptBridge enableLogging];
    
    _bridge = [WebViewJavascriptBridge bridgeForWebView:vb];
    [_bridge setWebViewDelegate:self];
    
    [_bridge registerHandler:@"testObjcCallback" handler:^(id data, WVJBResponseCallback responseCallback) {
        responseCallback(_tempDictionary);
    }];
    _locationManager = [[CLLocationManager alloc]init];
    _locationManager.delegate = self;
    [_locationManager requestAlwaysAuthorization];
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [_locationManager startUpdatingLocation];
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *location = [locations lastObject];
    NSString *latitude = [NSString stringWithFormat:@"%f",location.coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f",location.coordinate.longitude];
    _tempDictionary = [NSDictionary dictionaryWithObjectsAndKeys:latitude,@"latitude",longitude,@"longitude",nil];
}



@end
