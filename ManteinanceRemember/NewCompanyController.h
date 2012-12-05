//
//  NuevaEmpresaViewController.h
//  ManteinanceRemember
//
//  Created by Eduardo Carrillo Albor on 08/09/12.
//  Copyright (c) 2012 Eduardo Antonio Carrillo Albor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MailsViewController.h"
@interface NewCompanyController : UIViewController<UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MailsDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txfCompanyName;
@property (weak, nonatomic) IBOutlet UITextField *txfContactPersonName;
@property (weak, nonatomic) IBOutlet UITextField *txfThelephone;
@property (weak, nonatomic) IBOutlet UIImageView *imgVPhoto;

- (IBAction)openMailInsertionView:(id)sender;
- (IBAction)addPhoto:(id)sender;
@end
