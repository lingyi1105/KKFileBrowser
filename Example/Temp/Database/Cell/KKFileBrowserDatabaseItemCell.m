//
//  KKFileBrowserDatabaseItemCell.m
//  Uban
//
//  Created by shinemo on 2021/7/23.
//  Copyright © 2021 ShineMo Technology Co., Ltd. All rights reserved.
//

#import "KKFileBrowserDatabaseItemCell.h"

@implementation KKFileBrowserDatabaseItemCellModel

@end

@interface KKFileBrowserDatabaseItemCollectionCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation KKFileBrowserDatabaseItemCollectionCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    [self setupSubviews];
    return self;
}

- (void)setupSubviews{
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.titleLabel];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGRect bounds = self.contentView.bounds;
    CGRect f1 = bounds;
    f1.origin.x = 8.f;
    f1.origin.y = 8.f;
    f1.size.width = bounds.size.width - f1.origin.x * 2;
    f1.size.height = bounds.size.height - f1.origin.y * 2;
    self.titleLabel.frame = f1;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 0;
        _titleLabel.font = [UIFont systemFontOfSize:15.f];
    }
    return _titleLabel;
}

@end

@interface KKFileBrowserDatabaseItemCell ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@end

@implementation KKFileBrowserDatabaseItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return nil;
    }
    [self setupSubviews];
    return self;
}

- (void)setupSubviews{
    [self.contentView addSubview:self.collectionView];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGRect bounds = self.contentView.bounds;
    CGRect f1 = bounds;
    self.collectionView.frame = f1;
}

- (void)setCellModel:(KKFileBrowserDatabaseItemCellModel *)cellModel{
    _cellModel = cellModel;
    [self.collectionView reloadData];
}

#pragma mark - getters
- (UICollectionViewFlowLayout *)flowLayout{
    if (_flowLayout) {
        return _flowLayout;
    }
    _flowLayout = [[UICollectionViewFlowLayout alloc] init];
    _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _flowLayout.minimumLineSpacing = 0;
    _flowLayout.minimumInteritemSpacing = 0;
    return _flowLayout;
}

- (UICollectionView *)collectionView {
    if (_collectionView) {
        return _collectionView;
    }
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [_collectionView registerClass:[KKFileBrowserDatabaseItemCollectionCell class] forCellWithReuseIdentifier:@"KKFileBrowserDatabaseItemCollectionCell"];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    return _collectionView;
}

#pragma mark - UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *items = (NSArray *)self.cellModel.values;
    KKFileBrowserDatabaseItemCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"KKFileBrowserDatabaseItemCollectionCell" forIndexPath:indexPath];
    cell.titleLabel.text = items[indexPath.row]?[NSString stringWithFormat:@"%@",items[indexPath.row]]:@"";
    cell.contentView.layer.borderWidth = 0.5f;
    cell.contentView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSArray *items = (NSArray *)self.cellModel.values;
    return items.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *items = (NSArray *)self.cellModel.rowWidths;
    CGSize size = collectionView.frame.size;
    NSNumber *wdithNumber = items[indexPath.row];
    CGFloat wdith = wdithNumber.floatValue;
    size.width = wdith;
    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.whenSelectItemClick) {
        self.whenSelectItemClick(self, indexPath);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.whenScrollViewDidScroll) {
        self.whenScrollViewDidScroll(scrollView);
    }
}

- (void)setContentOffset:(CGPoint)contentOffset{
    _contentOffset = contentOffset;
    [self.collectionView setContentOffset:contentOffset];
}

@end
