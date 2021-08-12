//
//  KKFileListViewController.h
//  KKFileBrowser_Example
//
//  Created by shinemo on 2021/8/11.
//  Copyright © 2021 Hansen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString *const KNSUserDefaultsFileBrowserStyle;

typedef enum : NSUInteger {
    KKFileBrowserDefaultStyle,
    KKFileBrowserWindowsStyle,
} KKFileBrowserStyle;

@interface KKFileListViewController : UIViewController

- (instancetype)initWithPath:(NSString *)path;

@end

NS_ASSUME_NONNULL_END
