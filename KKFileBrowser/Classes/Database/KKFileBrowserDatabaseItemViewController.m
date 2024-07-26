//
//  KKFileBrowserDatabaseItemViewController.m
//  QMKKXProduct
//
//  Created by Hansen on 2/3/20.
//  Copyright © 2020 ShineMo. All rights reserved.
//

#import "KKFileBrowserDatabaseItemViewController.h"
#import "KKFileBrowserDatabase.h"
#import "KKFileBrowserDatabaseItemCell.h"

@implementation KKFileBrowserDatabaseItem

@end

@interface KKFileBrowserDatabaseItemViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *datum;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) CGPoint contentOffset;
@property (nonatomic, strong) KKFileBrowserDatabase *database;
@property (nonatomic, copy) NSArray *rowWidths;

@property (nonatomic, strong) KKFileBrowserDatabaseItemCell *headerView;

@end

@implementation KKFileBrowserDatabaseItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupSubviews];
    //
    [self reloadData];
}

- (void)setupSubviews{
    [self.tableView registerClass:[KKFileBrowserDatabaseItemCell class] forCellReuseIdentifier:@"KKFileBrowserDatabaseItemCell"];
    [self.view addSubview:self.tableView];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    CGRect bounds = self.view.bounds;
    CGRect f1 = bounds;
    self.tableView.frame = f1;
}

- (void)reloadData{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.datum removeAllObjects];
        KKFileBrowserDatabase *database = self.database;
        //内容
        NSMutableArray *datas = [[NSMutableArray alloc] init];
        //遍历表单所有字段
        NSArray *allkeys = [database getFieldsWithTableName:self.itemModel.tableName];
        //按照字母排序
        allkeys = [allkeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [obj1 compare:obj2 options:NSNumericSearch];
        }];
        if (allkeys.count > 0) {
            [datas addObject:allkeys];
        }
        //默认row宽度
        NSMutableArray *widths = [[NSMutableArray alloc] init];
        for (int i = 0; i < allkeys.count; i ++) {
            [widths addObject:@(50.f)];
        }
        //构造cell
        NSArray *items = [database selectTableWithTableName:self.itemModel.tableName];
        //获取表单内容
        for (NSDictionary *item in items) {
            NSMutableArray *items = [[NSMutableArray alloc] init];
            for (NSString *key in allkeys) {
                NSObject *value = [item objectForKey:key];
                if (value == [NSNull null]) {
                    [items addObject:@""];
                }else{
                    [items addObject:value?:@""];
                }
            }
            [datas addObject:items];
        }
        for (NSArray <NSString *>*values in datas) {
            KKFileBrowserDatabaseItemCellModel *element = [[KKFileBrowserDatabaseItemCellModel alloc] init];
            element.values = values;
            [self.datum addObject:element];
        }
        //计算所有row最适宽度
        for (int i = 0; i < self.datum.count; i ++) {
            KKFileBrowserDatabaseItemCellModel *model = self.datum[i];
            for (int j = 0; j < model.values.count; j ++) {
                NSNumber *width = widths[j];
                NSString *keyAndValue = [NSString stringWithFormat:@"%@",model.values[j]];
                UIFont *labelFont = [UIFont systemFontOfSize:15.f];
                //最大限制
                CGFloat maxLimit = 100.f;
                CGSize descSize = [keyAndValue boundingRectWithSize:CGSizeMake(maxLimit, 0)
                                                            options:NSStringDrawingUsesLineFragmentOrigin
                                                         attributes:@{NSFontAttributeName : labelFont}
                                                            context:nil].size;
                descSize.width += 20.f;//间隙
                if (width.floatValue < descSize.width) {
                    widths[j] = @(descSize.width);
                }
            }
        }
        self.rowWidths = [widths copy];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}

#pragma mark - setters
- (void)setItemModel:(KKFileBrowserDatabaseItem *)itemModel{
    _itemModel = itemModel;
    self.title = itemModel.tableName;
    self.database = [KKFileBrowserDatabase databaseWithPath:itemModel.path];
}

#pragma mark - getters
- (NSMutableArray *)datum{
    if (!_datum) {
        _datum = [[NSMutableArray alloc] init];
    }
    return _datum;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.tableHeaderView = [[UIView alloc] init];
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KKFileBrowserDatabaseItemCellModel *cellModel = self.datum[indexPath.row];
    cellModel.rowWidths = self.rowWidths;
    KKFileBrowserDatabaseItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KKFileBrowserDatabaseItemCell"];
    cell.cellModel = cellModel;
    __weak typeof(self) weakSelf = self;
    cell.whenScrollViewDidScroll = ^(UIScrollView *scrollView) {
        //连动滚动
        NSArray *cells = [weakSelf.tableView visibleCells];
        for (KKFileBrowserDatabaseItemCell *tc in cells) {
            tc.contentOffset = scrollView.contentOffset;
        }
        weakSelf.contentOffset = scrollView.contentOffset;
        weakSelf.headerView.contentOffset = scrollView.contentOffset;
    };
    cell.whenSelectItemClick = ^(KKFileBrowserDatabaseItemCell *cell, NSIndexPath *collectionViewCellIndexPath) {
        [weakSelf tableView:tableView didSelectRowAtIndexPath:indexPath];
    };
    cell.contentOffset = self.contentOffset;
    if (indexPath.row % 2 == 0) {
        cell.collectionView.backgroundColor = [UIColor whiteColor];
    }else{
        cell.collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    cell.hidden = indexPath.row == 0;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row != 0) {
        return 40;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datum.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.datum.count == 0) {
        return [[UIView alloc] init];
    }
    KKFileBrowserDatabaseItemCellModel *cellModel = self.datum[0];
    KKFileBrowserDatabaseItemCell *view = [[KKFileBrowserDatabaseItemCell alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
    view.backgroundColor = [UIColor.lightGrayColor colorWithAlphaComponent:0.95];
    view.cellModel = cellModel;
    self.headerView = view;
    
    __weak typeof(self) weakSelf = self;
    view.whenScrollViewDidScroll = ^(UIScrollView *scrollView) {
        //连动滚动
        NSArray *cells = [weakSelf.tableView visibleCells];
        for (KKFileBrowserDatabaseItemCell *tc in cells) {
            tc.contentOffset = scrollView.contentOffset;
        }
        weakSelf.contentOffset = scrollView.contentOffset;
    };
    
    return view;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row != 0) {
        [self whenAcitonDatabase:indexPath];
    }
}

#pragma mark - aciton
- (void)showSuccessWithMsg:(NSString *)msg{
    //do
}

- (void)showError:(NSString *)msg{
    //do
}

- (void)whenAcitonDatabase:(NSIndexPath *)indexPath{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    __weak typeof(self) weakSelf = self;
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"删除内容" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //to do
        [weakSelf deleteDatabase:indexPath];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"修改内容" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //to do
        [weakSelf updateDatabase:indexPath];
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //to do
    }];
    [alert addAction:action1];
    [alert addAction:action2];
    [alert addAction:action3];
    [self presentViewController:alert animated:YES completion:nil];
}

//删除数据
- (void)deleteDatabase:(NSIndexPath *)indexPath{
    KKFileBrowserDatabase *database = self.database;
    NSArray *items = [database selectTableWithTableName:self.itemModel.tableName];
    NSObject *object = items[indexPath.row - 1];
    BOOL success = [database deleteTableWithTableName:self.itemModel.tableName contents:object];
    if (success) {
        [self showSuccessWithMsg:@"内容删除成功"];
        [self reloadData];
    }else{
        NSString *error = [database lastErrorMessage];
        [self showError:[NSString stringWithFormat:@"内容删除失败%@",error]];
    }
}

//更新数据
- (void)updateDatabase:(NSIndexPath *)indexPath{
    KKFileBrowserDatabaseItemCellModel *cellModel = self.datum[indexPath.row];
    //
    KKFileBrowserDatabase *database = self.database;
    NSArray *columns = [database getFieldsWithTableName:self.itemModel.tableName];
    NSArray *values = cellModel.values;
    //按照字母排序
    columns = [columns sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    //
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"添加数据" message:@"输入框字段对于的值" preferredStyle:UIAlertControllerStyleAlert];
    __weak typeof(self) weakSelf = self;
    for (int i = 0; i < columns.count; i++) {
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = columns[i];
            textField.text = [NSString stringWithFormat:@"%@",values[i]];
        }];
    }
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        for (UITextField *textField in alert.textFields) {
            NSString *value = textField.text;
            NSString *key = textField.placeholder;
            if (value.length > 0){
                [dict setObject:value forKey:key];
            }
        }
        NSArray *items = [database selectTableWithTableName:weakSelf.itemModel.tableName];
        NSObject *object = items[indexPath.row - 1];
        BOOL success = [database updateTableWithTableName:weakSelf.itemModel.tableName contents:object update:dict];
        if (success) {
            [weakSelf showSuccessWithMsg:@"数据修改成功"];
            [weakSelf reloadData];
        }else{
            NSString *error = [database lastErrorMessage];
            [weakSelf showError:[NSString stringWithFormat:@"数据修改失败%@",error]];
        }
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //to do
    }];
    [alert addAction:action1];
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
