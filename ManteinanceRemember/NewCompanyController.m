//
//  NuevaEmpresaViewController.m
//  ManteinanceRemember
//
//  Created by Eduardo Carrillo Albor on 08/09/12.
//  Copyright (c) 2012 Eduardo Antonio Carrillo Albor. All rights reserved.
//

#import "NewCompanyController.h"
#import "BlockBackground.h"
#import "BlockAlertView.h"
#import "PVCustomPikhubButton.h"
@interface NewCompanyController ()

@end

@implementation NewCompanyController
@synthesize txfCompanyName;
@synthesize txfContactPersonName;
@synthesize txfThelephone;
@synthesize txfMail;
@synthesize imgVPhoto;

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
    [self.view setBackgroundColor:bgColor];
    self.title = @"Nueva empresa";
    [self setPaddingForTextfields];
    PVCustomPikhubButton *doneBtn = [[PVCustomPikhubButton alloc] initWithFrame:CGRectZero isBackButton:NO];
    [doneBtn addTarget:self action:@selector(addCompany:) forControlEvents:UIControlEventTouchUpInside];
    [doneBtn setButtonTitle:@"Done"];
    PVCustomPikhubButton *cancelBtn = [[PVCustomPikhubButton alloc] initWithFrame:CGRectZero isBackButton:NO];
    [cancelBtn addTarget:self action:@selector(closeView:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setButtonTitle:@"Cancel"];
    UIBarButtonItem *barBtnDone = [[UIBarButtonItem alloc] initWithCustomView:doneBtn];
    UIBarButtonItem *barBtnCancel = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
    [self.navigationItem setRightBarButtonItem:barBtnDone animated:YES];
    [self.navigationItem setLeftBarButtonItem:barBtnCancel animated:YES];
    
    
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setTxfCompanyName:nil];
    [self setTxfContactPersonName:nil];
    [self setTxfThelephone:nil];
    [self setTxfMail:nil];
    [self setImgVPhoto:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (IBAction)addPhoto:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIActionSheet *photoSourceSelector = [[UIActionSheet alloc] initWithTitle:@"Seleccionar fuente" delegate:self cancelButtonTitle:@"Cancelar" destructiveButtonTitle:nil otherButtonTitles:@"Camera roll",@"Camera", nil];
        [photoSourceSelector showInView:self.view];
    }else{
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        [imagePicker setDelegate:self];
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [self.navigationController presentViewController:imagePicker animated:YES completion:nil];
    }
    
    
}

- (void)addCompany:(id)sender {
    if ([self validateIntroducedData]) {
        NSDictionary* newCompanyData = @{
        @"name" : self.txfCompanyName.text,
        @"contactPerson": self.txfContactPersonName.text,
        @"thelephone":self.txfThelephone.text,
        @"mail":self.txfMail.text};
        [[DataManager sharedInstance] saveNewCompany:newCompanyData];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }else{
        BlockAlertView *alert = [BlockAlertView alertWithTitle:@"Error" message:@"Uno o mas campos estan incompletos."];
        
        [alert setDestructiveButtonWithTitle:@"Ok" block:nil];
        [alert show];
        
    }
}

- (void)closeView:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case UIImagePickerControllerSourceTypeCamera:
            NSLog(@"No tiene camara");
            break;
        case UIImagePickerControllerSourceTypePhotoLibrary:{
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            [imagePicker setDelegate:self];
            [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            [self.navigationController presentViewController:imagePicker animated:YES completion:nil];
        }
            
            break;
        default:
            break;
    }
}
-(BOOL)validateIntroducedData{
    BOOL isDataValid = YES;
    if ([self.txfCompanyName.text isEqualToString:@""]) {
        isDataValid = NO;
    }else if ([self.txfContactPersonName.text isEqualToString:@""]){
        isDataValid = NO;
    }else if ([self.txfMail.text isEqualToString:@""]){
        isDataValid = NO;
    } else if ([self.txfThelephone.text isEqualToString:@""]){
        isDataValid = NO;
    }
    return isDataValid;
}

-(void) setPaddingForTextfields{
    
    UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 20)];
    self.txfCompanyName.leftView = paddingView1;
    self.txfCompanyName.leftViewMode = UITextFieldViewModeAlways;
    UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 20)];
    self.txfContactPersonName.leftView = paddingView2;
    self.txfContactPersonName.leftViewMode = UITextFieldViewModeAlways;
    UIView *paddingView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 20)];
    self.txfMail.leftView = paddingView3;
    self.txfMail.leftViewMode = UITextFieldViewModeAlways;
    UIView *paddingView4 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 20)];
    self.txfThelephone.leftView = paddingView4;
    self.txfThelephone.leftViewMode = UITextFieldViewModeAlways;
}
@end
