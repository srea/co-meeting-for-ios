//
//  InfoViewController.m
//  co-meeting
//
//  Created by tamazawayuuki on 2014/04/29.
//  Copyright (c) 2014年 Tamazawa. All rights reserved.
//

#import "InfoViewController.h"
#import <Social/Social.h>
#import <CTFeedbackViewController.h>

@interface InfoViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation InfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    FAKFontAwesome *icon = [FAKFontAwesome timesIconWithSize:25];
    [icon addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor]];
    UIImage *image = [icon imageWithSize:CGSizeMake(25, 25)];
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithImage:image
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(close)];
    self.navigationItem.leftBarButtonItem = closeButton;
}

- (void)close
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

# pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section == 0 && indexPath.row == 0) {
        CTFeedbackViewController *feedbackViewController = [CTFeedbackViewController controllerWithTopics:CTFeedbackViewController.defaultTopics localizedTopics:CTFeedbackViewController.defaultLocalizedTopics];
        feedbackViewController.toRecipients = @[@"feedback_apps@icloud.com"];
        feedbackViewController.useHTML = NO;
        [self.navigationController pushViewController:feedbackViewController animated:YES];
    }
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
            
            SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            
            [controller setInitialText:@"未読チェッカー for co-meeting"];
            [controller addURL:[NSURL URLWithString:@"https://itunes.apple.com/sr/app/wei-duchekka-for-co-meeting/id871137673?mt=8"]];
            [controller addImage:[UIImage imageNamed:@"logo512"]];
            
            [self presentViewController:controller animated:YES completion:Nil];
            
        }
    }
    
    if (indexPath.section == 1 && indexPath.row == 1) {
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
        {
            SLComposeViewController *tweetSheet = [SLComposeViewController
                                                   composeViewControllerForServiceType:SLServiceTypeTwitter];
            [tweetSheet setInitialText:@"未読チェッカー for co-meeting https://itunes.apple.com/sr/app/wei-duchekka-for-co-meeting/id871137673?mt=8"];
            [self presentViewController:tweetSheet animated:YES completion:nil];
        }
    }

    if (indexPath.section == 1 && indexPath.row == 2) {
        NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com/us/app/wei-duchekka-for-co-meeting/id871137673?l=ja&ls=1&mt=8"];
        [[UIApplication sharedApplication] openURL:url];
    }
    
    if (indexPath.section == 2 && indexPath.row == 1) {
        NSURL *url = [NSURL URLWithString:@"http://srea.github.io/apps/co-meeting-123.html"];
        [[UIApplication sharedApplication] openURL:url];
    }

    if (indexPath.section == 3 && indexPath.row == 0) {
        NSURL *url = [NSURL URLWithString:@"http://www.co-meeting.com/ja/"];
        [[UIApplication sharedApplication] openURL:url];
    }
    
    if (indexPath.section == 3 && indexPath.row == 1) {
        NSURL *url = [NSURL URLWithString:@"http://co-meeting.github.io/"];
        [[UIApplication sharedApplication] openURL:url];
    }
}

@end
