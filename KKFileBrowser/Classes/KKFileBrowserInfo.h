//
//  KKFileBrowserInfo.h
//  KKFileBrowser_Example
//
//  Created by shinemo on 2021/8/7.
//  Copyright © 2021 Hansen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKFileBrowserInfo : NSObject

@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, copy) NSString *filePath;
@property (nonatomic, copy) NSString *fileSize;
@property (nonatomic, copy) NSString *fileImageName;
@property (nonatomic, copy) NSDictionary *fileInfo;


/// 快速初始化
/// @param name 文件名字
/// @param path 路径
- (instancetype)initWithName:(NSString *)name path:(NSString *)path;

@end


@interface KKFileBrowserInfo (Default)

+ (KKFileBrowserInfo *)RootDirectory;//iPhone根文件夹

+ (KKFileBrowserInfo *)NSHomeDirectory;//NSHomeDirectory()
+ (KKFileBrowserInfo *)NSDocumentDirectory;//[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]
+ (KKFileBrowserInfo *)NSBundleMainDirectory;//[[NSBundle mainBundle] bundlePath]

@end


NS_ASSUME_NONNULL_END
