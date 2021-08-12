//
//  KKFileBrowserDatabase.h
//  QMKKXProduct
//  此类只用在小工具模块
//  Created by Hansen on 2/1/20.
//  Copyright © 2020 ShineMo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KKFileBrowserDatabaseColumnModel.h"

@interface KKFileBrowserDatabase : NSObject
@property (nonatomic, copy) NSString *dbPath;//db位置
@property (nonatomic, assign, readonly) NSInteger tableCount;//获取表单数量
@property (nonatomic, strong, readonly) NSArray *tableSqliteMasters;//获取当前所有表单描述

//
+ (instancetype)databaseWithPath:(NSString *)dbPath;

#pragma mark - action

/// 创建表单
/// @param tableName 表单名称
/// @param columnModels 字段类型
- (BOOL)createTableWithTableName:(NSString *)tableName columnModels:(NSArray <KKFileBrowserDatabaseColumnModel *>*)columnModels;

/// 增加内容到表单
/// @param tableName 表单名称
/// @param contents 增加数据内容
- (BOOL)insertTableWithTableName:(NSString *)tableName contents:(NSObject *)contents;

/// 删除内容从表单
/// @param tableName 表单名称
/// @param contents 删除数据内容
- (BOOL)deleteTableWithTableName:(NSString *)tableName contents:(NSObject *)contents;

/// 查询表单内容
/// @param tableName 表单名称
- (NSArray *)selectTableWithTableName:(NSString *)tableName;

/// 更新内容从表单
/// @param tableName 表单名称
/// @param contents 原数据内容
/// @param update 更新数据内容
- (BOOL)updateTableWithTableName:(NSString *)tableName contents:(NSObject *)contents update:(NSObject *)update;

/// 添加字段到表单
/// @param tableName 表单名称
/// @param columnModel 字段model
- (BOOL)addColumnWithTableName:(NSString *)tableName columnModel:(KKFileBrowserDatabaseColumnModel *)columnModel;

/// 通过表单获取表单字段
/// @param tableName 表单名称
- (NSArray <NSString *>*)getFieldsWithTableName:(NSString *)tableName;

/// 通过表单获取表单字段详情
- (NSArray <KKFileBrowserDatabaseColumnModel *>*)getFieldsInfoWithTableName:(NSString *)tableName;

/// 获取上一个操作错误信息
- (NSString *)lastErrorMessage;

@end

