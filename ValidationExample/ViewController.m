//
//  ViewController.m
//  ValidationExample
//
//  Created by Dan Zinngrabe on 7/24/14.
//  Copyright (c) 2014 Dan Zinngrabe. All rights reserved.
//

#import "ViewController.h"
#import "MutableModel.h"

@interface ViewController ()<UITextFieldDelegate>
@property   (nonatomic, weak)   IBOutlet    UITextField     *nameField;

@property   (nonatomic, copy)               MutableModel    *model;
@end

@implementation ViewController
@synthesize nameField;
@synthesize model;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark    UITextFieldDelegate methods

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSString    *text               = [textField text];
    NSError     *validationError    = nil;
    
    // If the model does not already exist, create it. This is optional
    if ([self model] == nil){
        MutableModel    *lazyModel    = nil;
        
        lazyModel = [[MutableModel alloc] init];
        [self setModel:lazyModel];
    }
    // You must call validateValue:forKey:error: and not validateName:error: for Foundation and/or CoreData to validate correctly.
    // Because the validation method can modify the value it is passed by reference
    if ([[self model] validateValue:&text forKey:@"name" error:&validationError]){
        [[self model] setValue:text forKey:@"name"];
    } else {
        [self didFailWithError:validationError];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

#pragma mark    Error handling

- (void) didFailWithError:(NSError *)error {
    UIAlertView     *alertView  = nil;
    
    if (error != nil){
        alertView = [[UIAlertView alloc] initWithTitle:([error localizedRecoverySuggestion] ?: [error localizedDescription])
                                             message:[error localizedFailureReason]
                                            delegate:nil
                                   cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                   otherButtonTitles:nil];
        [alertView show];
    }
}

@end
