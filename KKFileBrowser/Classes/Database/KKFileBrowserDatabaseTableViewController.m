//
//  KKFileBrowserDatabaseTableViewController.m
//  QMKKXProduct
//
//  Created by Hansen on 2/3/20.
//  Copyright © 2020 ShineMo. All rights reserved.
//

#import "KKFileBrowserDatabaseTableViewController.h"
#import "KKFileBrowserDatabase.h"
#import "KKFileBrowserDatabaseItemViewController.h"
#import "KKFileBrowserCollectionViewCell.h"
#import "KKQLPreviewController.h"

@interface KKFileBrowserDatabaseTableViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, QLPreviewControllerDataSource, QLPreviewControllerDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) NSMutableArray <KKFileBrowserInfo *> *datum;

@end

@implementation KKFileBrowserDatabaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupSubviews];
    [self reloadData];
}

- (void)setPath:(NSString *)path{
    _path = path;
    self.title = [self.path lastPathComponent];
}

- (void)setupSubviews{
    [self.collectionView registerClass:[KKFileBrowserCollectionViewCell class] forCellWithReuseIdentifier:@"KKFileBrowserCollectionViewCell"];
    [self.view addSubview:self.collectionView];
    //
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"更多" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClick:)];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    CGRect boudns = self.view.bounds;
    CGRect f1 = boudns;
    self.collectionView.frame = f1;
}

- (void)rightBarButtonItemClick:(id)sender{
    //TODO
    KKQLPreviewController *quickLookVC = [[KKQLPreviewController alloc] init];
    quickLookVC.delegate = self;
    quickLookVC.dataSource = self;
    [self presentViewController:quickLookVC animated:YES completion:nil];
}

- (void)reloadData{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.datum removeAllObjects];
        //获取table
        KKFileBrowserDatabase *database = [KKFileBrowserDatabase databaseWithPath:self.path];
        NSArray *items = database.tableSqliteMasters;
        for (NSDictionary *item in items) {
            NSString *name = item[@"name"];
            NSInteger count = [database selectTableWithTableName:name].count;
            //构造cellModel
            KKFileBrowserInfo *element = [[KKFileBrowserInfo alloc] init];
            element.fileName = name;
            element.fileSize = @(count).stringValue;
            element.fileInfo = item;
            [self.datum addObject:element];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    });
}

#pragma mark - getter
- (NSMutableArray<KKFileBrowserInfo *> *)datum{
    if (!_datum) {
        _datum = [[NSMutableArray alloc] init];
    }
    return _datum;
}

#pragma mark - getters
- (UICollectionViewFlowLayout *)flowLayout{
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.minimumLineSpacing = 0.f;
        _flowLayout.minimumInteritemSpacing = 0.f;
    }
    return _flowLayout;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
    }
    return _collectionView;
}

#pragma mark - UICollectionViewDataSource,UICollectionViewDelegate
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    KKFileBrowserInfo *cellModel = self.datum[indexPath.row];
    KKFileBrowserCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"KKFileBrowserCollectionViewCell" forIndexPath:indexPath];
    cell.cellModel = cellModel;
    cell.rightImageView.hidden = NO;
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.datum.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //TODO
    KKFileBrowserInfo *cellModel = self.datum[indexPath.row];
    KKFileBrowserDatabaseItem *itemModel = [[KKFileBrowserDatabaseItem alloc] init];
    itemModel.path = self.path;
    itemModel.tableName = cellModel.fileName;
    //
    KKFileBrowserDatabaseItemViewController *vc = [[KKFileBrowserDatabaseItemViewController alloc] init];
    vc.itemModel = itemModel;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size = CGSizeZero;
    size.width = collectionView.frame.size.width;
    size.height = 44.f;
    return size;
}

#pragma mark - QLPreviewControllerDelegate, QLPreviewControllerDataSource
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller{
   return self.datum.count;
}

- (id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index{
    NSURL *url = [NSURL fileURLWithPath:self.path];
    return url;
}

@end
