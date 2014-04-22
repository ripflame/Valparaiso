//
//  GLGeneralReportViewController.m
//  Valparaiso
//
//  Created by Gilberto Leon Enriquez on 22/4/14.
//  Copyright (c) 2014 Ripflame. All rights reserved.
//

#import "GLGeneralReportViewController.h"
#import "GLDatabaseController.h"

@interface GLGeneralReportViewController ()
@property (weak, nonatomic) IBOutlet UILabel *totalQuantityLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalWeightLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalEarningsLabel;

@end

@implementation GLGeneralReportViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self updateData];
}

- (void)viewDidAppear:(BOOL)animated {
    [self updateData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helper methods

- (void)updateData {
    [self.totalQuantityLabel setText:[NSString stringWithFormat:@"%@", [GLDatabaseController getQuantityTotal]]];
    [self.totalWeightLabel setText:[NSString stringWithFormat:@"%.3f Kg", [[GLDatabaseController getWeightTotal] doubleValue]]];
    [self.totalEarningsLabel setText:[NSString stringWithFormat:@"$%.2f", [[GLDatabaseController getSalesTotal] doubleValue]]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
