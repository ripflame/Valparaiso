//
//  GLSaleViewController.m
//  Valparaiso
//
//  Created by Gilberto Leon Enriquez on 16/4/14.
//  Copyright (c) 2014 Ripflame. All rights reserved.
//

#import "GLSaleViewController.h"
#import "GLDatabaseController.h"

typedef enum {
    kEditingDateState,
    kStandbyDateState
} dateState;

@interface GLSaleViewController ()
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UITextField *quantityField;
@property (weak, nonatomic) IBOutlet UITextField *weightField;
@property (weak, nonatomic) IBOutlet UITextField *priceField;
@property (weak, nonatomic) IBOutlet UITextField *sumField;
@property (weak, nonatomic) IBOutlet UITextField *totalField;
@property (weak, nonatomic) IBOutlet UIButton *datePickerButton;

@property (assign, nonatomic) dateState state;

@property (strong, nonatomic) UITextField *activeTextField;
@property (strong, nonatomic) UIDatePicker *picker;

- (IBAction)changeDatePressed:(UIButton *)sender;
- (IBAction)donePressed:(UIButton *)sender;
@end

@implementation GLSaleViewController

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
    
    //Set date picker state
    self.state = kStandbyDateState;
    
    //Adding delegates to text fields
    self.quantityField.delegate = self;
    self.quantityField.tag = 100;
    self.weightField.delegate = self;
    self.priceField.delegate = self;
    
    //Addding tap recognizer to the background
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped:)];
    [tapRecognizer setNumberOfTapsRequired:1];
    [self.view addGestureRecognizer:tapRecognizer];
    
    //Set to the current date
    NSDate *currentDate = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    
    [self.dateLabel setText:[formatter stringFromDate:currentDate]];
    
    //Update sum field
    [self updateSumField];
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

#pragma mark - Button actions

- (IBAction)changeDatePressed:(UIButton *)sender {
    
    switch (self.state) {
        case kStandbyDateState:
        {
            self.state = kEditingDateState;
            
            self.picker = [[UIDatePicker alloc] init];
            self.picker.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            self.picker.datePickerMode = UIDatePickerModeDate;
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"dd/MM/yyyy"];
            NSDate *pickerDate = [formatter dateFromString:self.dateLabel.text];
            
            [self.picker setDate:pickerDate animated:YES];
            
            [self.picker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
            CGSize pickerSize = [self.picker sizeThatFits:CGSizeZero];
            self.picker.frame = CGRectMake(0, 250, pickerSize.width, 460);
            self.picker.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:self.picker];
            
            [self.datePickerButton setTitle:@"Aceptar" forState:UIControlStateNormal];
        }
            break;
            
        case kEditingDateState:
        {
            self.state = kStandbyDateState;
            
            [self.picker removeFromSuperview];
            
            [self.datePickerButton setTitle:@"Cambiar" forState:UIControlStateNormal];
            
            [self updateSumField];
            [self clearFields];
        }
            break;
    }
}

- (IBAction)donePressed:(UIButton *)sender {
    if ([self fieldsAreValid] ) {
        [self saveSale];
        [self updateTotalField];
        [self updateSumField];
        [self clearSale];
    }
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.activeTextField = textField;
    if ( textField.tag != 100 ) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.35f];
        CGRect frame = self.view.frame;
        frame.origin.y = -100;
        [self.view setFrame:frame];
        [UIView commitAnimations];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.activeTextField = nil;
    [textField resignFirstResponder];
    if ( textField.tag != 100 ) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.35f];
        CGRect frame = self.view.frame;
        frame.origin.y = 0;
        [self.view setFrame:frame];
        [UIView commitAnimations];
    }
}

#pragma mark - helper methods

- (void)clearFields {
    [self.quantityField setText:@""];
    [self.weightField setText:@""];
    [self.priceField setText:@""];
    [self.totalField setText:@""];
}

- (void)clearSale {
    [self.quantityField setText:@""];
    [self.weightField setText:@""];
    [self.priceField setText:@""];
}

- (void)dateChanged:(UIDatePicker *)sender {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    [self.dateLabel setText:[formatter stringFromDate:sender.date]];
}

- (void) backgroundTapped:(UITapGestureRecognizer *)recognizer {
    if (self.activeTextField) {
        [self.activeTextField resignFirstResponder];
    }
}

- (void) updateTotalField {
    double totalValue = [self.weightField.text doubleValue] * [self.priceField.text doubleValue];
    [self.totalField setText:[NSString stringWithFormat:@"$%.2f", totalValue]];
}

- (void) updateSumField {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    NSDate *date = [formatter dateFromString:self.dateLabel.text];
    [self.sumField setText:[NSString stringWithFormat:@"$%.2f", [[GLDatabaseController getSalesTotalFromDay:date] doubleValue]]];
}

- (void) saveSale {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    NSDate *date = [formatter dateFromString:self.dateLabel.text];
    
    NSNumber *quantity = [NSNumber numberWithInt:[self.quantityField.text intValue]];
    
    NSNumber *weight = [NSNumber numberWithDouble:[self.weightField.text doubleValue]];
    
    NSNumber *price = [NSNumber numberWithDouble:[self.priceField.text doubleValue]];
    
    NSDictionary *creationMessage = [GLDatabaseController createSaleWithDate:date quantity:quantity weight:weight andPrice:price];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[creationMessage[@"error"] boolValue]? @"Oops!" : @"Éxito!" message:creationMessage[@"message"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
}

- (BOOL) fieldsAreValid {
    BOOL areValid = YES;
    
    if ( [self.quantityField.text isEqualToString:@""] || [self.weightField.text isEqualToString:@""] || [self.priceField.text isEqualToString:@""] ) {
        areValid = NO;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Al parecer dejaste unos campos vacios!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }
    
    return areValid;
}

@end
