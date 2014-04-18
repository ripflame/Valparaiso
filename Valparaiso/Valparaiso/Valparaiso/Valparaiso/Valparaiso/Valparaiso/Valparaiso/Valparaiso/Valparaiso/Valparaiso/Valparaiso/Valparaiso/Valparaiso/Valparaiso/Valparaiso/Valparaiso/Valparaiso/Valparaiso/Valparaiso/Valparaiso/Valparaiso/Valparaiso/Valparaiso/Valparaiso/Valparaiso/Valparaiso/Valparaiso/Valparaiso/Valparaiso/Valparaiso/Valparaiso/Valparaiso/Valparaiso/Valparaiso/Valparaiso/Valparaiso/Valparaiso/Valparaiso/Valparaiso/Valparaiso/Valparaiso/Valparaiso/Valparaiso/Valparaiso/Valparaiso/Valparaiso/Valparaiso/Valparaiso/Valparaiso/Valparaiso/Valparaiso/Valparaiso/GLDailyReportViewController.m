//
//  GLDailyReportViewController.m
//  Valparaiso
//
//  Created by Gilberto Leon Enriquez on 17/4/14.
//  Copyright (c) 2014 Ripflame. All rights reserved.
//

#import "GLDailyReportViewController.h"
#import "GLDatabaseController.h"

typedef enum {
    kEditingDateState,
    kStandbyDateState
} dateState;

@interface GLDailyReportViewController ()
@property (weak, nonatomic) IBOutlet UIButton *dateButtonOutlet;
@property (weak, nonatomic) IBOutlet UILabel *quantityLabel;
@property (weak, nonatomic) IBOutlet UILabel *weightLabel;
@property (weak, nonatomic) IBOutlet UILabel *earningsLabel;

@property (assign, nonatomic) dateState state;

@property (strong, nonatomic) UIDatePicker *picker;

- (IBAction)sendEmailTapped:(UIButton *)sender;
- (IBAction)dateButtonTapped:(UIButton *)sender;
@end

@implementation GLDailyReportViewController

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
    
    //Set date picker state
    self.state = kStandbyDateState;
    
    //Update data
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd / MM / yyyy"];
    [self.dateButtonOutlet setTitle:[formatter stringFromDate:[NSDate date]] forState:UIControlStateNormal];
    
    [self updateDataForDay:[formatter dateFromString:self.dateButtonOutlet.titleLabel.text]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark - Actions

- (IBAction)sendEmailTapped:(UIButton *)sender {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        
        mailer.mailComposeDelegate = self;
        
        [mailer setSubject:@"Reporte diario de venta de mojarra"];
        [mailer setToRecipients:@[@"tornosleon@msn.com"]];
        
        NSString *date = self.dateButtonOutlet.titleLabel.text;
        NSString *quantity = self.quantityLabel.text;
        NSString *weight = self.weightLabel.text;
        NSString *earnings = self.earningsLabel.text;
        
        NSString *message = [NSString stringWithFormat:@"Reporte de venta con fecha: %@\n-------------------------------------------------\nMojarras vendidas: %@\nPeso total acumulado: %@\nGanancias totales del día: %@", date, quantity, weight, earnings];
        
        [mailer setMessageBody:message isHTML:NO];
        
        [self presentViewController:mailer animated:YES completion:nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Tu dispositivo no puede mandar emails"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)dateButtonTapped:(UIButton *)sender {
    switch (self.state) {
        case kStandbyDateState:
        {
            self.state = kEditingDateState;
            
            self.picker = [[UIDatePicker alloc] init];
            self.picker.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            self.picker.datePickerMode = UIDatePickerModeDate;
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"dd / MM / yyyy"];
            NSDate *pickerDate = [formatter dateFromString:self.dateButtonOutlet.titleLabel.text];
            
            [self.picker setDate:pickerDate animated:YES];
            
            [self.picker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
            CGSize pickerSize = [self.picker sizeThatFits:CGSizeZero];
            self.picker.frame = CGRectMake(0, 250, pickerSize.width, 460);
            self.picker.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:self.picker];
        }
            break;
            
        case kEditingDateState:
        {
            self.state = kStandbyDateState;
            
            [self.picker removeFromSuperview];
        }
            break;
    }
}

#pragma mark - Mailer delegate

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Helper methods

- (void)updateDataForDay:(NSDate *)day {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd / MM / yyyy"];
    
    [self.quantityLabel setText:[[GLDatabaseController getQuantityTotalFromDay:day] stringValue]];
    [self.weightLabel setText:[NSString stringWithFormat:@"%.2f Kg", [[GLDatabaseController getWeightTotalFromDay:day] doubleValue]]];
    [self.earningsLabel setText:[NSString stringWithFormat:@"$%.2f", [[GLDatabaseController getSalesTotalFromDay:day] doubleValue]]];
}

- (void)dateChanged:(UIDatePicker *)sender {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd / MM / yyyy"];
    [self.dateButtonOutlet setTitle:[formatter stringFromDate:sender.date] forState:UIControlStateNormal];
    [self updateDataForDay:sender.date];
}
@end
