//
//  Sale.h
//  Valparaiso
//
//  Created by Gilberto Leon Enriquez on 16/4/14.
//  Copyright (c) 2014 Ripflame. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Sale : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * quantity;
@property (nonatomic, retain) NSNumber * weight;
@property (nonatomic, retain) NSNumber * price;

@end
