//
//  KKViewController.m
//  KKFileBrowser
//
//  Created by chenghengsheng on 08/03/2021.
//  Copyright (c) 2021 chenghengsheng. All rights reserved.
//

#import "KKViewController.h"
#import <KKFileBrowser/KKFileBrowser.h>

@interface KKViewController ()

@end

@implementation KKViewController

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.title = @"KKFileBrowser";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

- (IBAction)iconTouchAction:(UIButton *)sender{
    KKFileDirectoryViewController *vc = [[KKFileDirectoryViewController alloc] initWithPaths:@[]];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)showLaboratoryTouchAction:(UIButton *)sender {
    NSURL *url = [NSURL URLWithString:@"https://github.com/HansenCCC"];
    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
}

@end
