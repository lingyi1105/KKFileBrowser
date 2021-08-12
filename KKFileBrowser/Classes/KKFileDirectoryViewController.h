//
//  KKFileDirectoryViewController.h
//  KKFileBrowser_Example
//  文件目录
//  Created by Hansen on 2021/8/7.
//  Copyright © 2021 HansenCCC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKFileBrowserInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface KKFileDirectoryViewController : UIViewController

/// 标准初始化
/// @param fileInfos @[@{@"fileName":@"文件名字",@"filePath":@"文件路径"}]
- (instancetype)initWithPaths:(NSArray <KKFileBrowserInfo *>*)fileInfos;

@end

NS_ASSUME_NONNULL_END
