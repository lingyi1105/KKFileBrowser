//
//  KKFileBrowserInfo.m
//  KKFileBrowser_Example
//
//  Created by shinemo on 2021/8/7.
//  Copyright © 2021 Hansen. All rights reserved.
//

#import "KKFileBrowserInfo.h"

@implementation KKFileBrowserInfo

/// 快速初始化
/// @param name 文件名字
/// @param path 路径
- (instancetype)initWithName:(NSString *)name path:(NSString *)path{
    self = [self init];
    if (!self) {
        return nil;
    }
    self.fileName = name;
    self.filePath = path;
    return self;
}

@end

@implementation KKFileBrowserInfo (Default)

+ (KKFileBrowserInfo *)RootDirectory{
    return [[KKFileBrowserInfo alloc] initWithName:@"System根目录" path:@"/"];
}

+ (KKFileBrowserInfo *)NSHomeDirectory{
    return [[KKFileBrowserInfo alloc] initWithName:@"NSHomeDirectory()目录" path:NSHomeDirectory()];
}

+ (KKFileBrowserInfo *)NSDocumentDirectory{
    return [[KKFileBrowserInfo alloc] initWithName:@"Document目录" path:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]];
}

+ (KKFileBrowserInfo *)NSBundleMainDirectory{
    return [[KKFileBrowserInfo alloc] initWithName:@"MainBundle目录" path:[[NSBundle mainBundle] bundlePath]];
}

@end
