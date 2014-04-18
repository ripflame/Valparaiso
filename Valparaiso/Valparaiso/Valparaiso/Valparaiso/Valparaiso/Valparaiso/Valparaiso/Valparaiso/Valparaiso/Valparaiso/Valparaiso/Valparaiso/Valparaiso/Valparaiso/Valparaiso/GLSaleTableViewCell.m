//
//  GLSaleTableViewCell.m
//  Valparaiso
//
//  Created by Gilberto Leon Enriquez on 17/4/14.
//  Copyright (c) 2014 Ripflame. All rights reserved.
//

#import "GLSaleTableViewCell.h"

@implementation GLSaleTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
