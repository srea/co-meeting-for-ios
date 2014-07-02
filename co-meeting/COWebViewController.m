//
//  COViewController.m
//  co-meeting
//
//  Created by tamazawayuuki on 2014/04/29.
//  Copyright (c) 2014年 Tamazawa. All rights reserved.
//

#import "COWebViewController.h"
#import <NJKWebViewProgress.h>
#import <NJKWebViewProgressView.h>

@interface COWebViewController () <UIWebViewDelegate, NJKWebViewProgressDelegate, UIGestureRecognizerDelegate>
@property (strong, nonatomic) NJKWebViewProgressView *progressView;
@property (strong, nonatomic) NJKWebViewProgress *progressProxy;
@end

@implementation COWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _progressProxy = [[NJKWebViewProgress alloc] init];
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    CGFloat progressBarHeight = 3.f;
    CGRect navigaitonBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigaitonBarBounds.size.height - progressBarHeight, navigaitonBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.fadeOutDelay = 1;
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;

    [self setupNavigationBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar addSubview:_progressView];
    self.webView.delegate = _progressProxy;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Remove progress view
    // because UINavigationBar is shared with other ViewControllers
    [_progressView removeFromSuperview];
}

- (void)setupNavigationBar
{
    
    // Two buttons at the right side of nav bar
    FAKFontAwesome *icon = [FAKFontAwesome questionCircleIconWithSize:25];
    [icon addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor]];
    UIImage *image = [icon imageWithSize:CGSizeMake(25, 25)];
    UIBarButtonItem *sendButton = [[UIBarButtonItem alloc] initWithImage:image
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(rightTap)];
    self.navigationItem.rightBarButtonItems = @[sendButton];
    
    
    BOOL modalPresent = (self.presentingViewController);
    if (modalPresent) {
        return;
    }
    // バックアイコンを設定
    //http://stackoverflow.com/questions/19078995/removing-the-title-text-of-an-ios-7-uibarbuttonitem
    FAKFontAwesome *leftIcon = [FAKFontAwesome chevronLeftIconWithSize:25];
    [leftIcon addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor]];
    UIImage *leftIconImage = [leftIcon imageWithSize:CGSizeMake(25, 25)];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:leftIconImage
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(backTap)];
    self.navigationItem.leftBarButtonItems = @[backButton];
    //    self.navigationController.navigationBar.topItem.title = @"";
    
    // MEMO:バックアイコンを設定することで無効になってしまったスワイプバックを再び有効にする
    [self.navigationController.interactivePopGestureRecognizer setDelegate:self];
    [self.navigationController.interactivePopGestureRecognizer setEnabled:YES];
}

- (void)backTap
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightTap
{
    UIAlertView *alertView = [UIAlertView bk_alertViewWithTitle:nil message:@"Go to help page"];
    [alertView setCancelButtonIndex:[alertView bk_addButtonWithTitle:@"cancel" handler:nil]];
    [alertView bk_addButtonWithTitle:@"ok" handler:^{
        NSURL *url = [NSURL URLWithString:@"http://srea.github.io/apps/co-meeting-123.html?openapp"];
        [[UIApplication sharedApplication] openURL:url];
    }];
    [alertView show];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"%@",request.URL.absoluteString);
    NSRange range = [request.URL.absoluteString rangeOfString:OAUTH_REDIRECT_URL];
    if (range.location != NSNotFound) {
        [[NXOAuth2AccountStore sharedStore] handleRedirectURL:request.URL];
        return NO;
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [super webViewDidFinishLoad:webView];
//    self.title = @"Sign in";
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
}

@end
