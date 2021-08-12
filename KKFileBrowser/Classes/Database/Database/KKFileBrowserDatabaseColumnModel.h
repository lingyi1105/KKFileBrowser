//
//  KKFileBrowserDatabaseColumnModel.h
//  QMKKXProduct
//
//  Created by Hansen on 2/6/20.
//  Copyright © 2020 ShineMo. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 db数据类型（个人建议能text就用text）
 1. NULL 这个值为空值
 2. INTEGER 值被标识为整数，依据值的大小可以依次被存储1～8个字节
 3. REAL 所有值都是浮动的数值
 4. TEXT 值为文本字符串
 5. BLOB 值为blob数据
 
 */

@interface KKFileBrowserDatabaseColumnModel : NSObject

@property (nonatomic, copy) NSString *cid;
@property (nonatomic, copy) NSString *dflt_value;
@property (nonatomic, copy) NSString *name;//字段名
@property (nonatomic, copy) NSString *notnull;//是否值不能为空 1or0
@property (nonatomic, copy) NSString *pk;//是否自动增长唯一key 1or0
@property (nonatomic, copy) NSString *type;//类型1. NULL 这个值为空值2. INTEGER 值被标识为整数，依据值的大小可以依次被存储1～8个字节3. REAL 所有值都是浮动的数值4. TEXT 值为文本字符串5. BLOB 值为blob数据
- (instancetype)initWithName:(NSString *)name;

@end

