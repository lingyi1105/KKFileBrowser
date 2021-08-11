//
//  KKViewController.m
//  KKFileBrowser
//
//  Created by chenghengsheng on 08/03/2021.
//  Copyright (c) 2021 chenghengsheng. All rights reserved.
//

#import "KKViewController.h"
#import "KKFileDirectoryViewController.h"

@interface KKViewController ()

@property (nonatomic, strong) UIButton *iconButton;

@end

@implementation KKViewController

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.title = @"KKFileBrowser";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:self.iconButton];
}

- (void)iconTouchAction:(UIButton *)sender{
    KKFileDirectoryViewController *vc = [[KKFileDirectoryViewController alloc] initWithPaths:@[]];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    CGRect bounds = self.view.bounds;
    //
    CGRect f1 = bounds;
    f1.size = CGSizeMake(200, 200.f);
    f1.origin.x = (bounds.size.width - f1.size.width)/2.0;
    f1.origin.y = (bounds.size.height - f1.size.height)/2.0;
    self.iconButton.frame = f1;
}

#pragma mark - getters
- (UIButton *)iconButton{
    if (!_iconButton) {
        _iconButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_iconButton addTarget:self action:@selector(iconTouchAction:) forControlEvents:UIControlEventTouchUpInside];
        [_iconButton setImage:[UIImage imageNamed:@"kk_Icon_logo"] forState:UIControlStateNormal];
    }
    return _iconButton;
}

@end
