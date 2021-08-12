//
//  KKFileBrowserDatabase.m
//  QMKKXProduct
//
//  Created by Hansen on 2/1/20.
//  Copyright © 2020 ShineMo. All rights reserved.
//

#import "KKFileBrowserDatabase.h"
#import <FMDB/FMDB.h>
#import <MJExtension/MJExtension.h>

@interface KKFileBrowserDatabase ()

@property (strong, nonatomic) FMDatabaseQueue *dbQueue;
@property (strong, nonatomic) NSDictionary *tableSqliteMaster;//获取当前所有表单描述

@end

@implementation KKFileBrowserDatabase
- (instancetype)init{
    self = [super init];
    if(!self){
        return nil;
    }
    /*
     注意：此类只用在小工具模块
     
     // self.dbQueue = [WDDatabase databaseQueueWithPath:dbPath];
     // 存在多个线程同时使用数据库情况
     // self.dbQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
     */
    return self;
}

+ (instancetype)databaseWithPath:(NSString *)dbPath{
    KKFileBrowserDatabase *database = [[self alloc] init];
    database.dbPath = dbPath;
    return database;
}

//指定创建db路径
- (void)setDbPath:(NSString *)dbPath{
    _dbPath = dbPath;
    //    self.dbQueue = [WDDatabase databaseQueueWithPath:dbPath];
    //使用以下方法，存在多个线程同时使用数据库情况
    self.dbQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
}

//获取表单数量
- (NSInteger)tableCount{
    return self.tableSqliteMasters.count;
}

//获取当前所有表单描述
- (NSArray *)tableSqliteMasters{
    // 根据请求参数查询数据
    __block FMResultSet *resultSet = nil;
    NSMutableArray *items = [[NSMutableArray alloc] init];
    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        resultSet = [db executeQuery:@"SELECT * FROM sqlite_master where type='table';"];
        while (resultSet.next) {
            //name = 1;
            //rootpage = 3;
            //sql = 4;
            //"tbl_name" = 2;
            //type = 0;
            NSString *str0 = [resultSet stringForColumnIndex:0];
            NSString *str1 = [resultSet stringForColumnIndex:1];
            NSString *str2 = [resultSet stringForColumnIndex:2];
            NSString *str3 = [resultSet stringForColumnIndex:3];
            NSString *str4 = [resultSet stringForColumnIndex:4];
            [items addObject:@{
                @"type":str0,
                @"name":str1,
                @"tbl_name":str2,
                @"rootpage":str3,
                @"sql":str4,
            }];
        }
    }];
    return [items copy];
}

#pragma mark - action

/// 创建表单
/// @param tableName 表单名称
/// @param columnModels 字段类型
- (BOOL)createTableWithTableName:(NSString *)tableName columnModels:(NSArray <KKFileBrowserDatabaseColumnModel *>*)columnModels{
    NSString *column = @"";
    for (KKFileBrowserDatabaseColumnModel *columnModel in columnModels) {
        NSString *name = columnModel.name;
        NSString *pk = @"primary KEY AUTOINCREMENT";
        NSString *notnull = @"NOT NULL";
        NSString *type = columnModel.type?:@"TEXT";//没有类型默认为text文本类型
        NSString *attribute = @"";
        if (columnModel.pk.intValue == 1) {
            attribute = pk;
            type = @"INTEGER";
        }else if(columnModel.notnull.intValue == 1){
            attribute = notnull;
        }
        NSString *value = [NSString stringWithFormat:@"%@ %@ %@,",name,type,attribute];
        column = [NSString stringWithFormat:@"%@%@",column,value];
    }
    if (column.length > 0) {
        column = [column substringToIndex:column.length - 1];
    }
    NSString *sqlCommand = [NSString stringWithFormat:@"create table if not exists %@ (%@)",tableName,column];
    __block BOOL success;
    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        success = [db executeUpdate:sqlCommand];
    }];
    if(!success){
        //do
    }
    return success;
}

/// 增加内容到表单
/// @param tableName 表单名称
/// @param contents 插入数据内容
- (BOOL)insertTableWithTableName:(NSString *)tableName contents:(NSObject *)contents{
    //插入内容，遍历字段属性，不能为空属性默认赋值空字符串
    NSMutableDictionary *dict = contents.mj_keyValues;
    NSArray <KKFileBrowserDatabaseColumnModel *>*infoItems = [self getFieldsInfoWithTableName:tableName];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    NSMutableArray *values = [[NSMutableArray alloc] init];
    for (KKFileBrowserDatabaseColumnModel *info in infoItems) {
        NSString *key = info.name;
        NSString *value = [dict objectForKey:key];
        if (info.notnull.intValue == 1) {
            //不能为空
        }else{
            //可以为空
        }
        if (info.pk.intValue == 1) {
            //是特殊自增字段
            if (value.length > 0) {
                [keys addObject:key?:@""];
                [values addObject:value?:@""];
            }
        }else{
            //不是特殊自增字段
            [keys addObject:key?:@""];
            [values addObject:value?:@""];
        }
    }
    //嵌套''
    NSMutableArray *valuesMutable = [[NSMutableArray alloc] init];
    for (NSString *value in values) {
        [valuesMutable addObject:[NSString stringWithFormat:@"'%@'",value]];
    }
    values = [valuesMutable copy];
    NSString *key = [keys componentsJoinedByString:@","];
    NSString *value = [values componentsJoinedByString:@","];
    NSString *sqlCommand = [NSString stringWithFormat:@"insert into %@ (%@) values (%@)", tableName,key,value];
    __block BOOL success;
    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        success = [db executeUpdate:sqlCommand];
    }];
    if(!success){
        //do
    }
    return success;
}

/// 删除内容从表单
/// @param tableName 表单名称
/// @param contents 插入数据内容
- (BOOL)deleteTableWithTableName:(NSString *)tableName contents:(NSObject *)contents{
    //删除内容，遍历字段属性，匹配满足条件的内容进行删除
    //delete from 't_student' where ID = ?
    NSMutableDictionary *dict = contents.mj_keyValues;
    NSArray *keys = dict.allKeys;
    NSString *format = @"";
    NSString *and = @" and ";
    for (NSString *key in keys) {
        NSString *deleteValue = [NSString stringWithFormat:@"%@ = '%@' %@",key,dict[key],and];
        if (dict[key] == [NSNull null]) {
            //内容为空不做操作
        }else{
            format = [NSString stringWithFormat:@"%@%@",format,deleteValue];
        }
    }
    if (format.length > 0) {
        format = [format substringToIndex:format.length - and.length];
    }
    NSString *sqlCommand = [NSString stringWithFormat:@"delete from %@ where %@", tableName,format];
    __block BOOL success;
    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        success = [db executeUpdate:sqlCommand];
    }];
    if(!success){
        //do
    }
    return success;
}

/// 更新内容从表单
/// @param tableName 表单名称
/// @param contents 原数据内容
/// @param update 更新数据内容
- (BOOL)updateTableWithTableName:(NSString *)tableName contents:(NSObject *)contents update:(NSObject *)update{
    //修改内容，遍历字段属性，匹配满足条件的内容进行修改
    //UPDATE table_name SET column1=value1,column2=value2,...
    NSString *updateformat = @"";
    NSString *contentformat = @"";
    {
        NSMutableDictionary *dict = contents.mj_keyValues;
        NSArray *keys = dict.allKeys;
        //条件语句
        NSString *and = @" and ";
        for (NSString *key in keys) {
            NSString *deleteValue = [NSString stringWithFormat:@"%@ = '%@' %@",key,dict[key],and];
            if (dict[key] == [NSNull null]) {
                //内容为空不做操作
            }else{
                contentformat = [NSString stringWithFormat:@"%@%@",contentformat,deleteValue];
            }
        }
        if (contentformat.length > 0) {
            contentformat = [contentformat substringToIndex:contentformat.length - and.length];
        }
    }
    {
        //修改语句
        NSMutableDictionary *dict = update.mj_keyValues;
        NSArray *keys = dict.allKeys;
        NSString *and = @" , ";
        for (NSString *key in keys) {
            NSObject *value = dict[key];
            if (value == [NSNull null]) {
                value = @"";
            }
            NSString *deleteValue = [NSString stringWithFormat:@"%@ = '%@' %@",key,value?:@"",and];
            updateformat = [NSString stringWithFormat:@"%@%@",updateformat,deleteValue];
        }
        if (updateformat.length > 0) {
            updateformat = [updateformat substringToIndex:updateformat.length - and.length];
        }
    }
    NSString *sqlCommand = [NSString stringWithFormat:@"UPDATE %@ SET %@ where %@", tableName,updateformat,contentformat];
    __block BOOL success;
    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        success = [db executeUpdate:sqlCommand];
    }];
    if(!success){
        //do
    }
    return success;
}

/// 添加字段到表单
/// @param tableName 表单名称
/// @param columnModel 字段model
- (BOOL)addColumnWithTableName:(NSString *)tableName columnModel:(KKFileBrowserDatabaseColumnModel *)columnModel{
    NSString *columnName = columnModel.name;
    NSString *type = columnModel.type?:@"TEXT";
    NSString *pk = @"primary key AUTOINCREMENT";
    NSString *notnull = @"";
    NSString *attribute = @"";
    if (columnModel.pk.intValue == 1) {
        attribute = pk;
        type = @"INTEGER";
    }else if(columnModel.notnull.intValue == 1){
        attribute = notnull;
    }
    //执行添加字段命令
    NSString *sqlCommand = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ %@ %@",tableName,columnName,type,attribute];
    __block BOOL success;
    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        success = [db executeUpdate:sqlCommand];
    }];
    if(!success){
        //do
    }
    return success;
}

/// 遍历表单内容
/// @param tableName 表单名称
- (NSArray *)selectTableWithTableName:(NSString *)tableName{
    NSString *sqlCommand = [NSString stringWithFormat:@"select * from %@",tableName];
    __block FMResultSet *resultSet;
    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        resultSet = [db executeQuery:sqlCommand];
    }];
    NSMutableArray *items = [[NSMutableArray alloc] init];
    while([resultSet next]) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        NSDictionary *columnNames = resultSet.columnNameToIndexMap;
        NSArray *keys = columnNames.allKeys;
        for (NSString *key in keys) {
            NSString *value = [resultSet objectForColumn:key];
            [dict setObject:value forKey:key];
        }
        [items addObject:dict];
    }
    return items;
}

/// 通过表单获取表单字段
/// @param tableName 表单名称
- (NSArray <NSString *>*)getFieldsWithTableName:(NSString *)tableName{
    //获取表单字段，或者通过[db getTableSchema:tableName]获取
    NSString *sqlCommand = [NSString stringWithFormat:@"select * from %@",tableName];
    __block FMResultSet *resultSet;
    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        resultSet = [db executeQuery:sqlCommand];
    }];
    NSDictionary *dict = resultSet.columnNameToIndexMap;
    return dict.allKeys;
}

/// 通过表单获取表单字段详情
- (NSArray <KKFileBrowserDatabaseColumnModel *>*)getFieldsInfoWithTableName:(NSString *)tableName{
    __block FMResultSet *resultSet;
    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        resultSet = [db getTableSchema:tableName];
    }];
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    while ([resultSet next]) {
        KKFileBrowserDatabaseColumnModel *model = [KKFileBrowserDatabaseColumnModel mj_objectWithKeyValues:resultSet.resultDictionary];
        [resultArray addObject:model];
    }
    return resultArray;
}

/// 获取上一个操作错误信息
- (NSString *)lastErrorMessage{
    __block NSString *error;
    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        error = [db lastErrorMessage];
    }];
    return error;
}

@end
