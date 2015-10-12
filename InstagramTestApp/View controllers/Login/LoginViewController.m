//
//  LoginViewController.m
//  InstagramTestApp
//
//  Created by Interaktive Bank Ltd on 06/10/15.
//  Copyright © 2015 Artem. All rights reserved.
//

#import "LoginViewController.h"
#import "InstagramAPI.h"
#import "PopularPostsViewController.h"

static NSString* redirectURL = @"http://ya.ru";
static NSString* redirectHost = @"ya.ru";

@interface LoginViewController ()

@property (nonatomic, strong) UIWebView* webView;

@end

@implementation LoginViewController

@synthesize webView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    webView.delegate = self;
    webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:webView];
    
    [self loadLoginRequest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)loadLoginRequest
{
    UIView* reloadButton = [self.view viewWithTag:100];
    if (reloadButton)
        [reloadButton removeFromSuperview];
    NSString* loginURL = [NSString stringWithFormat:@"https://instagram.com/oauth/authorize/?client_id=%@&redirect_uri=%@&response_type=token", @"550b69bccdcf453bafdf7335cebcc95f", redirectURL];
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:loginURL]];
    [webView loadRequest:request];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    static BOOL animation = YES;
        
    if ([request.URL.host isEqualToString:redirectHost])
    {
        NSString* token = [self queryStringParametersFromString:request.URL.fragment][@"access_token"];
        [InstagramAPI sharedInstance].tokenString = token;
        PopularPostsViewController* popularPosts = [[PopularPostsViewController alloc] initWithNibName:@"PopularPostsViewController" bundle:nil];
        [self.navigationController pushViewController:popularPosts animated:animation];
        self.navigationController.viewControllers = @[popularPosts];
    }
    else
        animation = NO;
    return YES;
}

- (NSDictionary *)queryStringParametersFromString:(NSString*)string
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [[string componentsSeparatedByString:@"&"] enumerateObjectsUsingBlock:^(NSString * param, NSUInteger idx, BOOL *stop) {
        NSArray *pairs = [param componentsSeparatedByString:@"="];
        if ([pairs count] != 2) return;
        
        NSString *key = [pairs[0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *value = [pairs[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [dict setObject:value forKey:key];
    }];
    return dict;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error
{
    UIButton* reloadButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [reloadButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [reloadButton setTitle:@"Перезагрузить" forState:UIControlStateNormal];
    [reloadButton addTarget:self action:@selector(loadLoginRequest) forControlEvents:UIControlEventTouchUpInside];
    [reloadButton sizeToFit];
    reloadButton.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
    [self.view addSubview:reloadButton];
    reloadButton.center = CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height / 2);
    reloadButton.tag = 100;
}

@end
