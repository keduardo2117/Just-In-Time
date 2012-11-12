//
//  ExtrasViewController.m
//  ManteinanceRemember
//
//  Created by Eduardo Carrillo Albor on 11/11/12.
//  Copyright (c) 2012 Eduardo Antonio Carrillo Albor. All rights reserved.
//

#import "ExtrasViewController.h"
@interface ExtrasViewController ()

@end

@implementation ExtrasViewController

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
    UIColor* bgColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ipad-BG-pattern.png"]];

    [self.coverView setBackgroundColor:bgColor];
    [self.view setBackgroundColor:bgColor];
    [self.view.layer addSublayer:[self createShadowWithFrame:CGRectMake(0, 0, 320, 5)]];
    [self.hidedView.layer addSublayer:[self createShadowWithFrame:CGRectMake(0, 0, 320, 5)]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CALayer *)createShadowWithFrame:(CGRect)frame
{
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = frame;
    
    UIColor* lightColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    UIColor* darkColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    gradient.colors = [NSArray arrayWithObjects:(id)darkColor.CGColor, (id)lightColor.CGColor, nil];
    
    return gradient;
}

- (IBAction)showContactInfo:(id)sender {
    NSLog(@"Preciono");
    [UIView animateWithDuration:0.3 animations:^(void){
        self.coverView.transform = CGAffineTransformMakeTranslation(0, 184);
    }];
}

@end
