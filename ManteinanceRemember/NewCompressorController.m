//
//  NuevoCompresorViewController.m
//  ManteinanceRemember
//
//  Created by Eduardo Carrillo Albor on 11/09/12.
//  Copyright (c) 2012 Eduardo Antonio Carrillo Albor. All rights reserved.
//

#import "NewCompressorController.h"

#import "Empresa.h"
#import "Compresor.h"
#import "BlockAlertView.h"
#import "PVCustomPikhubButton.h"
#import "STSegmentedControl.h"
#import "NSData+MD5.h"

@interface NewCompressorController ()

@end

@implementation NewCompressorController{
    NSArray* intervalos;
    NSArray* modelos;
    NSArray* datos;
    NSInteger hoursToNotifyBeforeMaintenance;
}
@synthesize txfModeloCompresor;
@synthesize txfMaintenanceInterval;
@synthesize txfLastMaintenance;
@synthesize lastMaintenancePickerContainer;
@synthesize maintenanceIntervalPickerContainer;
@synthesize maintenanceIntervalPicker;
@synthesize lastMaintenanceDatePicker;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.compressor = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.compressor) {
        self.txfModeloCompresor.text = self.compressor.modelo;
        NSString * intervalo = [NSString stringWithFormat:@"%d",[self.compressor.maintennaceInterval intValue]];
        self.txfMaintenanceInterval.text = intervalo;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        
        self.txfLastMaintenance.text = [formatter stringFromDate:self.compressor.ultimoMantenimiento];
    }
    NSArray *objects = [NSArray arrayWithObjects:@"300", @"500", nil];
	STSegmentedControl *segment = [[STSegmentedControl alloc] initWithItems:objects];
	segment.frame = CGRectMake(100, 218, 120, 45);
	segment.selectedSegmentIndex = 0;
	segment.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    segment.layer.zPosition = -1;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(segmentedControlSelectedIndexDidChange:) name:@"selectedIndexDidChange" object:nil];
    [self.view addSubview:segment];
    hoursToNotifyBeforeMaintenance = 300;
    self.title = @"Nuevo compresor";
    [self setPaddingForTextfields];
    
    PVCustomPikhubButton *doneBtn = [[PVCustomPikhubButton alloc] initWithFrame:CGRectZero isBackButton:NO];
    [doneBtn addTarget:self action:@selector(acceptNewCompressor:) forControlEvents:UIControlEventTouchUpInside];
    [doneBtn setButtonTitle:@"Done"];
    PVCustomPikhubButton *cancelBtn = [[PVCustomPikhubButton alloc] initWithFrame:CGRectZero isBackButton:NO];
    [cancelBtn addTarget:self action:@selector(closeView:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setButtonTitle:@"Cancel"];
    UIBarButtonItem *barBtnDone = [[UIBarButtonItem alloc] initWithCustomView:doneBtn];
    UIBarButtonItem *barBtnCancel = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
    [self.navigationItem setRightBarButtonItem:barBtnDone animated:YES];
    [self.navigationItem setLeftBarButtonItem:barBtnCancel animated:YES];
    
    UIColor* bgColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ipad-BG-pattern.png"]];
    [self.view setBackgroundColor:bgColor];
    self.maintenanceIntervalPickerContainer.transform = CGAffineTransformMakeTranslation(0, 260);
    self.lastMaintenancePickerContainer.transform = CGAffineTransformMakeTranslation(0, 260);
    intervalos = @[@"15000", @"10000", @"5000"];
    modelos = @[ @"Compresor 1", @"Compresor 2", @"Compresor 3"];
    // Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setMaintenanceIntervalPickerContainer:nil];
    [self setMaintenanceIntervalPicker:nil];
    [self setLastMaintenanceDatePicker:nil];
    [self setLastMaintenancePickerContainer:nil];
    [self setTxfLastMaintenance:nil];
    [self setTxfMaintenanceInterval:nil];
    [self setTxfModeloCompresor:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    NSLog(@"rgegererggr %@",change);
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#pragma mark UIPickerViewDelegate && UIPickerDataSource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    NSInteger numeroDefilas;
    if ([datos isEqualToArray:intervalos]) {
        numeroDefilas = [intervalos count];
    }else{
        numeroDefilas = [modelos count];
    }
    return numeroDefilas;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *titulo;
    if ([datos isEqualToArray:intervalos]) {
        titulo = [intervalos objectAtIndex:row];
    }else{
        titulo = [modelos objectAtIndex:row];
    }
    return titulo;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
}
#pragma mark UITextFieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag == 100) {
        self.maintenanceIntervalPickerContainer.transform = CGAffineTransformMakeTranslation(0, 260);
        self.lastMaintenancePickerContainer.transform = CGAffineTransformMakeTranslation(0, 260);
    }
    else if (textField.tag == 101) {
        datos = intervalos;
        [self.maintenanceIntervalPicker reloadAllComponents];
        [UIView animateWithDuration:0.3 animations:^(){
            self.lastMaintenancePickerContainer.transform = CGAffineTransformMakeTranslation(0, 260);
            self.maintenanceIntervalPickerContainer.transform = CGAffineTransformMakeTranslation(0, 0);
            [self.txfModeloCompresor resignFirstResponder];
        }];
        return NO;
    }
    else if (textField.tag ==102){
        [UIView animateWithDuration:0.3 animations:^{
            self.maintenanceIntervalPickerContainer.transform = CGAffineTransformMakeTranslation(0, 260);
            self.lastMaintenancePickerContainer.transform = CGAffineTransformMakeTranslation(0, 0);
            [self.txfModeloCompresor resignFirstResponder];
            
        }];
        return NO;
    }else{
        datos = modelos;
    }
    
    return YES;
}
- (IBAction)cancelIntervalSelection:(id)sender {
    NSLog(@"Cancelo la seleccion");
    [self hideSelector];
}

- (IBAction)acceptNewMaintenanceInterval:(id)sender {
    NSInteger index = [self.maintenanceIntervalPicker selectedRowInComponent:0];
    self.txfMaintenanceInterval.text = [datos objectAtIndex:index];
    
    [self hideSelector];
}

- (IBAction)closeView:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)acceptNewCompressor:(id)sender {
    if ([self validarDatosIngresados]) {
        
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];
        [formater setTimeZone:[NSTimeZone localTimeZone]];
        [formater setDateStyle:NSDateFormatterMediumStyle];
        NSDate *ultimoMantenimiento = [formater dateFromString:self.txfLastMaintenance.text];
        NSInteger nextMaintenaceInterval = (([self.txfMaintenanceInterval.text intValue]*60)*60);
        NSDate *proximoMantenimiento = [ultimoMantenimiento dateByAddingTimeInterval:nextMaintenaceInterval];
        NSDictionary *newCompressorData = @{
        @"model" : self.txfModeloCompresor.text,
        @"identifier" : [[NSKeyedArchiver archivedDataWithRootObject:[NSDate date]] MD5],
        @"lastMaintenance" : ultimoMantenimiento,
        @"nextMaintenance" : proximoMantenimiento,
        @"hoursToNotifyBeforeMaintenance" : [NSNumber numberWithInt:[self.txfMaintenanceInterval.text intValue]],
        };
        
        if (self.compressor) {
            NSMutableDictionary * dicc = [NSMutableDictionary dictionaryWithDictionary:newCompressorData];
            [dicc setValue:self.compressor.identifier forKey:@"identifier"];
            [dicc setValue:[NSNumber numberWithInteger:[self.txfMaintenanceInterval.text integerValue]] forKey:@"maintenanceInterval"];
            NSLog(@"Datos: %@",dicc );
            [self.delegate modifyCompressor:dicc];
        }else{
            NSLog(@"Se creara compresor con data %@",newCompressorData);
            [self.delegate saveNewCompressor:newCompressorData];
        }

        [self.navigationController popViewControllerAnimated:YES];
    }else{
        BlockAlertView *alert = [BlockAlertView alertWithTitle:@"Error" message:@"Uno o mas campos estan incompletos."];
        
        [alert setDestructiveButtonWithTitle:@"Ok" block:nil];
        [alert show];
    }
}

- (IBAction)acceptNewDateInsertion:(id)sender {
    NSDateFormatter *formateador = [[NSDateFormatter alloc] init];
    formateador.dateStyle = NSDateFormatterMediumStyle;
    
    self.txfLastMaintenance.text = [formateador stringFromDate:self.lastMaintenanceDatePicker.date];
    [UIView animateWithDuration:0.3 animations:^{
        self.lastMaintenancePickerContainer.transform = CGAffineTransformMakeTranslation(0, 260);
    }];
}

- (IBAction)cancelDateInsertion:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        self.lastMaintenancePickerContainer.transform = CGAffineTransformMakeTranslation(0, 260);
    }];
}

#pragma mark metodos privados
-(void)hideSelector{
    [UIView animateWithDuration:0.3 animations:^(){
        self.maintenanceIntervalPickerContainer.transform = CGAffineTransformMakeTranslation(0, 260);
    }];
}
-(BOOL)validarDatosIngresados{
    BOOL sonValidos = YES;
    if ([self.txfLastMaintenance.text isEqualToString:@""]) {
        sonValidos = NO;
    }else if ([self.txfModeloCompresor.text isEqualToString:@""]){
        sonValidos = NO;
    }else if ([self.txfMaintenanceInterval.text isEqualToString:@""]){
        sonValidos = NO;
    }
    return sonValidos;
}


-(void) setPaddingForTextfields{
    
    UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 20)];
    self.txfLastMaintenance.leftView = paddingView1;
    self.txfLastMaintenance.leftViewMode = UITextFieldViewModeAlways;
    UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 20)];
    self.txfMaintenanceInterval.leftView = paddingView2;
    self.txfMaintenanceInterval.leftViewMode = UITextFieldViewModeAlways;
    UIView *paddingView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 20)];
    self.txfModeloCompresor.leftView = paddingView3;
    self.txfModeloCompresor.leftViewMode = UITextFieldViewModeAlways;
}

-(void)segmentedControlSelectedIndexDidChange:(NSNotification *)pNotification
{
    STSegmentedControl * control = (STSegmentedControl*)pNotification.object;
    if (control.selectedSegmentIndex == 0) {
        hoursToNotifyBeforeMaintenance = 300;
    }else{
        hoursToNotifyBeforeMaintenance = 500;
    }
}

@end
