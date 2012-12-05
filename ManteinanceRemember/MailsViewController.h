//
//  MailsViewController.h
//  ManteinanceRemember
//
//  Created by Eduardo Carrillo Albor on 19/11/12.
//  Copyright (c) 2012 Eduardo Antonio Carrillo Albor. All rights reserved.
//

@protocol MailsDelegate
-(void) didFinishAddingMails:(NSArray*)mails;
@end
#import <UIKit/UIKit.h>

@class TPKeyboardAvoidingScrollView;
@interface MailsViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txfMail0;
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIStepper *stepper;
@property (nonatomic, strong) NSArray *previousEMails;
@property (nonatomic, weak) id<MailsDelegate> delegate;
@property (nonatomic, strong)  NSMutableArray * textFields;
- (IBAction)stepperDidChangeValue:(id)sender;
-(IBAction) hideAllTextFields:(id) sender;
@end
