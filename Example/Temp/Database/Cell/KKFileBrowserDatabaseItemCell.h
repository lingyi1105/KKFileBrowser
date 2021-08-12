//
//  KKFileBrowserDatabaseItemCell.h
//  Uban
//
//  Created by shinemo on 2021/7/23.
//  Copyright © 2021 ShineMo Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKFileBrowserDatabaseItemCellModel : NSObject

@property (nonatomic, copy) NSArray <NSString *>*values;
@property (nonatomic, copy) NSArray <NSNumber *>*rowWidths;

@end

@interface KKFileBrowserDatabaseItemCell : UITableViewCell

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) KKFileBrowserDatabaseItemCellModel *cellModel;
@property (nonatomic, assign) CGPoint contentOffset;
@property (nonatomic, copy) void (^whenSelectItemClick)(KKFileBrowserDatabaseItemCell *cell,NSIndexPath *indexPath);
@property (nonatomic, copy) void (^whenScrollViewDidScroll)(UIScrollView *scrollView);

@end

NS_ASSUME_NONNULL_END
