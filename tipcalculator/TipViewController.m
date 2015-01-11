//
//  ViewController.m
//  tipcalculator
//
//  Created by Baeksan Oh on 1/11/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "TipViewController.h"
#import "SettingsViewController.h"

@interface TipViewController ()
@property (strong, nonatomic) IBOutlet UITextField *billTextField;
@property (strong, nonatomic) IBOutlet UILabel *tipLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalLabel;
@property (strong, nonatomic) IBOutlet UISegmentedControl *tipControl;
- (IBAction)onTap:(id)sender;
- (void)updateValues;
- (void)onSettingsButton;

@end

@implementation TipViewController
NSUserDefaults *defaults;

- (void)viewWillAppear:(BOOL)animated {
    int defaultTipPercentage = (int)[defaults integerForKey:@"default_tip_percentage"];
    self.tipControl.selectedSegmentIndex = defaultTipPercentage;
}

- (void)viewDidAppear:(BOOL)animated {
    [self onTap:self];
}

- (void)viewWillDisappear:(BOOL)animated {
    [defaults setObject:self.billTextField.text forKey:@"bill_amount"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Tip Calculator";
    defaults = [NSUserDefaults standardUserDefaults];
    
    //Populate Bill Amount if the app was restarted within 10 minutes
    NSDate* terminatedAt = [defaults objectForKey:@"terminated_at"];
    
    int secs = -[terminatedAt timeIntervalSinceNow];
    NSLog(@"terminatedAt=%@, secs=%d", terminatedAt, secs);
    if (secs/60 < 10) {
        NSString* billAmountString = [defaults objectForKey:@"bill_amount"];
        self.billTextField.text = billAmountString;
    } else {
        self.billTextField.text = @"";
    }
    
    //Add Settings
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStylePlain target:self action:@selector(onSettingsButton)];
    
    [self updateValues];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onSettingsButton {
    [self.navigationController pushViewController:[[SettingsViewController alloc] init] animated:YES];
}

- (void)updateValues {
    float billAmount = [self.billTextField.text floatValue];
    NSArray* tipValues = @[@(0.1), @(0.15), @(0.2)];
    float tipAmount = billAmount * [tipValues[self.tipControl.selectedSegmentIndex] floatValue];
    float totalAmount = tipAmount + billAmount;
    
    NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setLocale:[NSLocale currentLocale]];
    
    
    self.tipLabel.text = [formatter stringFromNumber:[NSNumber numberWithFloat:tipAmount]];//[NSString stringWithFormat:@"$%.2f", tipAmount];
    self.totalLabel.text = [formatter stringFromNumber:[NSNumber numberWithFloat:totalAmount]];//[NSString stringWithFormat:@"%.2f", totalAmount];
}

- (IBAction)onTap:(id)sender {
    [self.view endEditing:YES];
    [self updateValues];
}
@end
