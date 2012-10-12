//
//  NuevoCompresorViewController.h
//  ManteinanceRemember
//
//  Created by Eduardo Carrillo Albor on 11/09/12.
//  Copyright (c) 2012 Eduardo Antonio Carrillo Albor. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NewCompressorController, Compresor, Empresa;
@protocol NewCompressorDelegate

-(void) saveNewCompressor:(NSDictionary*)companyData;
-(void) modifyCompressor:(NSDictionary*)companyData;
@end
@interface NewCompressorController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txfModeloCompresor;
@property (weak, nonatomic) IBOutlet UITextField *txfMaintenanceInterval;
@property (weak, nonatomic) IBOutlet UITextField *txfLastMaintenance;
@property (weak, nonatomic) IBOutlet UIView *lastMaintenancePickerContainer;
@property (weak, nonatomic) IBOutlet UIView *maintenanceIntervalPickerContainer;
@property (weak, nonatomic) IBOutlet UIPickerView *maintenanceIntervalPicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *lastMaintenanceDatePicker;
@property (weak, nonatomic) id<NewCompressorDelegate> delegate;
@property (strong, nonatomic) Empresa *empresa;
@property (strong, nonatomic) Compresor *compressor;
- (IBAction)cancelIntervalSelection:(id)sender;
- (IBAction)acceptNewMaintenanceInterval:(id)sender;
- (IBAction)acceptNewDateInsertion:(id)sender;
- (IBAction)cancelDateInsertion:(id)sender;
- (IBAction)acceptNewCompressor:(id)sender;
- (IBAction)closeView:(id)sender;
@end
