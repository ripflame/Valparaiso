//
//  GLSaleTableViewCell.h
//  Valparaiso
//
//  Created by Gilberto Leon Enriquez on 17/4/14.
//  Copyright (c) 2014 Ripflame. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GLSaleTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *quantityLabel;
@property (weak, nonatomic) IBOutlet UILabel *weightLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;

@end
