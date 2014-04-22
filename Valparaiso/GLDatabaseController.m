//
//  GLDatabaseController.m
//  Valparaiso
//
//  Created by Gilberto Leon Enriquez on 16/4/14.
//  Copyright (c) 2014 Ripflame. All rights reserved.
//

#import "GLAppDelegate.h"
#import "GLDatabaseController.h"
#import "Sale.h"

#define SALE @"Sale"

@implementation GLDatabaseController

+ (NSDictionary *)createSaleWithDate:(NSDate *)date quantity:(NSNumber *)quantity weight:(NSNumber *)weight andPrice:(NSNumber *)price {
    GLAppDelegate *appDelegate = [[UIApplication sharedApplication]  delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    Sale *sale = [NSEntityDescription insertNewObjectForEntityForName:SALE inManagedObjectContext:context];
    [sale setDate:date];
    [sale setQuantity:quantity];
    [sale setWeight:weight];
    [sale setPrice:price];
    
    NSDictionary *response = [[NSMutableDictionary alloc] init];
    NSError *error = nil;
    if ( ![context save:&error] ) {
        NSLog(@"Couldn't save: %@", [error localizedDescription]);
        response = @{@"error": @YES, @"message": [error localizedDescription]};
    }
    
    response = @{@"error": @NO, @"message": @"La venta se ha guardado correctamente"};
    
    return response;
}

+ (NSNumber *)getSalesTotalFromDay:(NSDate *)day {
    GLAppDelegate *appDelegate = [[UIApplication sharedApplication]  delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:SALE inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"date == %@ ", day];
    [request setEntity:entity];
    [request setPredicate:predicate];
    
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:request error:&error];
    
    
    double dayTotal = 0;
    
    if (!error) {
        for (Sale *sale in fetchedObjects) {
            dayTotal += [sale.price doubleValue] * [sale.weight doubleValue];
        }
    }
    
    return [NSNumber numberWithDouble:dayTotal];
}

+ (NSNumber *)getQuantityTotalFromDay:(NSDate *)day {
    GLAppDelegate *appDelegate = [[UIApplication sharedApplication]  delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:SALE inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"date == %@ ", day];
    [request setEntity:entity];
    [request setPredicate:predicate];
    
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:request error:&error];
    
    
    int dayTotal = 0;
    
    if (!error) {
        for (Sale *sale in fetchedObjects) {
            dayTotal += [sale.quantity intValue];
        }
    }
    
    return [NSNumber numberWithInt:dayTotal];
}

+ (NSNumber *)getWeightTotalFromDay:(NSDate *)day {
    GLAppDelegate *appDelegate = [[UIApplication sharedApplication]  delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:SALE inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"date == %@ ", day];
    [request setEntity:entity];
    [request setPredicate:predicate];
    
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:request error:&error];
    
    
    double dayTotal = 0;
    
    if (!error) {
        for (Sale *sale in fetchedObjects) {
            dayTotal += [sale.weight doubleValue];
        }
    }
    
    return [NSNumber numberWithDouble:dayTotal];
}

+ (NSArray *)getAllSalesFromDay:(NSDate *)day {
    GLAppDelegate *appDelegate = [[UIApplication sharedApplication]  delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:SALE inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"date == %@ ", day];
    [request setEntity:entity];
    [request setPredicate:predicate];
    
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:request error:&error];
    
    return fetchedObjects;
}

+ (NSNumber *)getSalesTotal {
    GLAppDelegate *appDelegate = [[UIApplication sharedApplication]  delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:SALE inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:request error:&error];
    
    
    double total = 0;
    
    if (!error) {
        for (Sale *sale in fetchedObjects) {
            total += [sale.price doubleValue] * [sale.weight doubleValue];
        }
    }
    
    return [NSNumber numberWithDouble:total];
}

+ (NSNumber *)getQuantityTotal {
    GLAppDelegate *appDelegate = [[UIApplication sharedApplication]  delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:SALE inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:request error:&error];
    
    
    int total = 0;
    
    if (!error) {
        for (Sale *sale in fetchedObjects) {
            total += [sale.quantity intValue];
        }
    }
    
    return [NSNumber numberWithInt:total];
}

+ (NSNumber *)getWeightTotal {
    GLAppDelegate *appDelegate = [[UIApplication sharedApplication]  delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:SALE inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:request error:&error];
    
    
    double total = 0;
    
    if (!error) {
        for (Sale *sale in fetchedObjects) {
            total += [sale.weight doubleValue];
        }
    }
    
    return [NSNumber numberWithDouble:total];
}

+ (BOOL)removeSaleWithQuantity:(NSNumber *)quantity weight:(NSNumber *)weight andPrice:(NSNumber *)price {
    BOOL didRemoveSale = YES;
    
    GLAppDelegate *appDelegate = [[UIApplication sharedApplication]  delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *entityDescriptor = [NSEntityDescription entityForName:SALE inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"quantity == %@ AND weight == %@ AND price == %@", quantity, weight, price];
    [request setEntity:entityDescriptor];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *clientsFetched = [context executeFetchRequest:request error:&error];
    
    [context deleteObject:[clientsFetched firstObject]];
    
    [context save:&error];
    if (error) {
        NSLog(@"error: %@", error.localizedDescription);
        didRemoveSale = NO;
    }
    
    
    return didRemoveSale;
}

@end
