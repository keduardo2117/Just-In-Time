//
//  DatosEmpresaViewController.h
//  ManteinanceRemember
//
//  Created by Eduardo Carrillo Albor on 08/09/12.
//  Copyright (c) 2012 Eduardo Antonio Carrillo Albor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewCompressorController.h"
@class Empresa;
@interface ListOfCompressorsController : UITableViewController<NewCompressorDelegate>

@property(nonatomic,strong) NSDictionary* companyData;
@property(nonatomic, weak) Empresa* company;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *showCompanyDataTap;

@end
