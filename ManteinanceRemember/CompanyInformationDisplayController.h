//
//  CompanyInformationDisplayController.h
//  ManteinanceRemember
//
//  Created by Eduardo Carrillo Albor on 25/09/12.
//  Copyright (c) 2012 Eduardo Antonio Carrillo Albor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MFMessageComposeViewController.h>
@class Empresa;
@interface CompanyInformationDisplayController : UIViewController<MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate>
@property(nonatomic, strong) Empresa* company;
@property (weak, nonatomic) IBOutlet UILabel *lblCompanyName;
@property (weak, nonatomic) IBOutlet UILabel *lblContactPersonName;
@property (weak, nonatomic) IBOutlet UILabel *lblTelephone;
@property (weak, nonatomic) IBOutlet UILabel *lblMail;

@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *closeViewTap;
@property (weak, nonatomic) IBOutlet UIView *actionSheet;


- (IBAction)closeView:(id)sender;
-(IBAction)openMailOrMessageSelector:(id)sender;

#pragma mark actionSheet methods
-(IBAction)openMailComposer;
-(IBAction)openMessageComposer;
-(IBAction) cancelMailOrMessageSending;
@end
