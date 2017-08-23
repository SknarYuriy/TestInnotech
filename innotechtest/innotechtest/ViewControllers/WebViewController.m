//
//  WebViewController.m
//  innotechtest
//
//  Created by Gorf on 8/23/17.
//  Copyright © 2017 Gorf. All rights reserved.
//

#import "WebViewController.h"
@interface WebViewController ()

@end

@implementation WebViewController
- (void)viewDidLoad {
    [super viewDidLoad];

    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://maps.google.com/maps"]]];
}


@end
