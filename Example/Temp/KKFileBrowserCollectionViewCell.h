//
//  KKFileBrowserCollectionViewCell.h
//  KKFileBrowser_Example
//
//  Created by shinemo on 2021/8/7.
//  Copyright © 2021 Hansen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKFileBrowserInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface KKFileBrowserCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) KKFileBrowserInfo *cellModel;

@end

@interface KKFileBrowserWindowsCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) KKFileBrowserInfo *cellModel;

@end

NS_ASSUME_NONNULL_END
