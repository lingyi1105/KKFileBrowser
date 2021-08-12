//
//  KKFileBrowserDatabaseColumnModel.m
//  QMKKXProduct
//
//  Created by Hansen on 2/6/20.
//  Copyright © 2020 ShineMo. All rights reserved.
//

#import "KKFileBrowserDatabaseColumnModel.h"

@implementation KKFileBrowserDatabaseColumnModel

- (instancetype)initWithName:(NSString *)name{
    self = [self init];
    if(!self){
        return nil;
    }
    self.name = name;
    return self;
}

@end
