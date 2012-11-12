//
//  ExtrasViewController.h
//  ManteinanceRemember
//
//  Created by Eduardo Carrillo Albor on 11/11/12.
//  Copyright (c) 2012 Eduardo Antonio Carrillo Albor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExtrasViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *hidedView;
@property (weak, nonatomic) IBOutlet UIView *coverView;
- (IBAction)showContactInfo:(id)sender;
@end
