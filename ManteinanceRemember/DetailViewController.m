//
//  DetailViewController.m
//  ManteinanceRemember
//
//  Created by Eduardo Carrillo Albor on 08/09/12.
//  Copyright (c) 2012 Eduardo Antonio Carrillo Albor. All rights reserved.
//

#import "DetailViewController.h"
#import "ListOfCompressorsController.h"
#import "Empresa.h"
#import "NewCompressorController.h"
@interface DetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation DetailViewController

#pragma mark - Managing the detail item
@synthesize lblNombreDeEmpresa = _lblNombreDeEmpresa;
@synthesize lblPersonaContacto = _lblPersonaContacto;
@synthesize lblTelefono = _lblTelefono;
@synthesize lblCorreo = _lblCorreo;

- (void)setDetailItem:(id)newDetailItem
{
    if (self.empresa != newDetailItem) {
        _empresa = newDetailItem;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	[self configureView];
}
-(void)configureView{
    UIColor* bgColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ipad-BG-pattern.png"]];
    [self.view setBackgroundColor:bgColor];
    self.lblNombreDeEmpresa.text = self.empresa.nombreEmpresa;
    self.lblPersonaContacto.text = self.empresa.personaContacto;
    //self.lblCorreo.text = self.empresa.correo;
    self.lblTelefono.text = [self.empresa.telefono stringValue];
}
- (void)viewDidUnload
{
    [self setLblNombreDeEmpresa:nil];
    [self setLblPersonaContacto:nil];
    [self setLblTelefono:nil];
    [self setLblCorreo:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"verCompresores"]) {
        ListOfCompressorsController *datosEmpresa = [segue destinationViewController];
        [datosEmpresa setCompany:self.empresa];
    }else if ([segue.identifier isEqualToString:@"nuevoCompresor"]){
        NSLog(@"Agregando nueva empresa");
        NewCompressorController* nuevoCompresor = [segue destinationViewController];
        [nuevoCompresor setEmpresa:self.empresa];
    }
}
#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

- (IBAction)verCompresores:(id)sender {
    
}
@end
