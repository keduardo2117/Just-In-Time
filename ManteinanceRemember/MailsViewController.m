//
//  MailsViewController.m
//  ManteinanceRemember
//
//  Created by Eduardo Carrillo Albor on 19/11/12.
//  Copyright (c) 2012 Eduardo Antonio Carrillo Albor. All rights reserved.
//

#import "MailsViewController.h"
#import "TPKeyboardAvoidingScrollView.h"
@interface MailsViewController ()

@end
@implementation MailsViewController{
    int _prevValue, _yPos;
    CGRect _TexftFieldFrame;
}

@synthesize textFields = _textFields;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSMutableArray * mails = [NSMutableArray array];
    for (UITextField * textField in self.textFields) {
        if (textField.text && !([textField.text isEqualToString:@""])) {
            [mails addObject:textField.text];
        }
    }
    [self.delegate didFinishAddingMails:mails];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIColor* bgColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ipad-BG-pattern.png"]];
    
    [self.view setBackgroundColor:bgColor];
    _prevValue = 0.0;
    _textFields = [NSMutableArray array];
    _yPos = 120.0;
    UIView *padding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 20)];
    self.txfMail0.leftView = padding;
    self.txfMail0.leftViewMode = UITextFieldViewModeAlways;
    [_textFields addObject:self.txfMail0];
	// Do any additional setup after loading the view.
    /*
    if (YES) {
        _prevValue++;
        for (int i = 0; i<3; i++) {
            [self.stepper setValue:(i+2)];
            _prevValue++;
            [self addMailTextField];
        }
    }*/
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)stepperDidChangeValue:(id)sender {
    UIStepper * stepper = (UIStepper*)sender;
    if (_prevValue < [stepper value]) {
        _prevValue = [stepper value];
        [self addMailTextField];
    }else{
        _prevValue = [stepper value];
        [self eraseMailTextField];
    }
}

-(void) addMailTextField{
    UITextField * txfMail = [[UITextField alloc] initWithFrame:CGRectMake(20, _yPos, 280, 38)];
    [txfMail setKeyboardType:UIKeyboardTypeEmailAddress];
    [txfMail setDelegate:self];
    [txfMail setBackground:[UIImage imageNamed:@"ipad-text-input.png"]];
    [txfMail setPlaceholder:[NSString stringWithFormat:@"Correo %d",_prevValue]];
    [txfMail setTextColor:[UIColor colorWithRed:0 green:0.2666 blue:0.4627 alpha:1.0]];
    [txfMail setFont:[UIFont systemFontOfSize:14]];
    [txfMail setAutocorrectionType:UITextAutocorrectionTypeNo];
    [txfMail setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [txfMail setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [txfMail setTag:_prevValue];
    UIView *padding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 20)];
    txfMail.leftView = padding;
    txfMail.leftViewMode = UITextFieldViewModeAlways;
    [_textFields addObject:txfMail];
    [self.scrollView addSubview:txfMail];
    _yPos += 59;
    
    
}

-(void) eraseMailTextField{
    UITextField *txfMail = [_textFields lastObject];
    [txfMail removeFromSuperview];
    _yPos -=59;
    [_textFields removeObject:txfMail];
}

-(void) hideAllTextFields:(id) sender
{
    for (UITextField * txf in _textFields) {
        [txf resignFirstResponder];
        [UIView animateWithDuration:0.2 animations:^(void){
            txf.transform = CGAffineTransformMakeTranslation(0, 0);
        }];
    }
}
#pragma mark UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self hideAllTextFields:nil];
    return YES;
}
@end
