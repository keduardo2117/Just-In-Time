//
//  CompressorObservationsViewController.m
//  ManteinanceRemember
//
//  Created by Eduardo Carrillo Albor on 12/11/12.
//  Copyright (c) 2012 Eduardo Antonio Carrillo Albor. All rights reserved.
//

#import "CompressorObservationsViewController.h"

@interface CompressorObservationsViewController ()

@end

@implementation CompressorObservationsViewController

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
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"ipad-BG-pattern.png"]]];
    [self.txtVObservations.layer setCornerRadius:8.0f];
    self.txtVObservations.text = self.observation;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.delegate textView:self.txtVObservations didChageContent:self.txtVObservations.text];
    NSLog(@"Vamos a salir de las observaciones");
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark UITextViewDelegate
-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    return YES;
}
@end
