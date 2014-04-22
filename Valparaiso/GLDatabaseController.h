//
//  GLDatabaseController.h
//  Valparaiso
//
//  Created by Gilberto Leon Enriquez on 16/4/14.
//  Copyright (c) 2014 Ripflame. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Sale;

@interface GLDatabaseController : NSObject

+ (NSDictionary *)createSaleWithDate:(NSDate *)date quantity:(NSNumber *)quantity weight:(NSNumber *)weight andPrice:(NSNumber *)price;

+ (NSNumber *)getSalesTotalFromDay:(NSDate *)day;
+ (NSNumber *)getQuantityTotalFromDay:(NSDate *)day;
+ (NSNumber *)getWeightTotalFromDay:(NSDate *)day;
+ (NSArray *)getAllSalesFromDay:(NSDate *)day;
+ (NSNumber *)getSalesTotal;
+ (NSNumber *)getQuantityTotal;
+ (NSNumber *)getWeightTotal;
+ (BOOL)removeSaleWithQuantity:(NSNumber *)quantity weight:(NSNumber *)weight andPrice:(NSNumber *)price;

@end
