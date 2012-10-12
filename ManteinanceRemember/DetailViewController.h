//
//  DetailViewController.h
//  ManteinanceRemember
//
//  Created by Eduardo Carrillo Albor on 08/09/12.
//  Copyright (c) 2012 Eduardo Antonio Carrillo Albor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Empresa.h"
@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lblNombreDeEmpresa;
@property (weak, nonatomic) IBOutlet UILabel *lblPersonaContacto;
@property (weak, nonatomic) IBOutlet UILabel *lblTelefono;
@property (weak, nonatomic) IBOutlet UILabel *lblCorreo;

@property (strong, nonatomic) Empresa *empresa;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
- (IBAction)verCompresores:(id)sender;

@end
