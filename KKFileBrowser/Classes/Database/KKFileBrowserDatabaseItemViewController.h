//
//  KKFileBrowserDatabaseItemViewController.h
//  QMKKXProduct
//
//  Created by Hansen on 2/3/20.
//  Copyright © 2020 ShineMo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KKFileBrowserDatabaseItem : NSObject

@property (nonatomic, copy) NSString *path;
@property (nonatomic, copy) NSString *tableName;

@end

@interface KKFileBrowserDatabaseItemViewController : UIViewController

@property (nonatomic, strong) KKFileBrowserDatabaseItem *itemModel;//

@end
