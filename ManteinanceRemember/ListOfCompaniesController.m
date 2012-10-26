//
//  MasterViewController.m
//  ManteinanceRemember
//
//  Created by Eduardo Carrillo Albor on 08/09/12.
//  Copyright (c) 2012 Eduardo Antonio Carrillo Albor. All rights reserved.
//

#import "ListOfCompaniesController.h"

#import "DetailViewController.h"
#import "ListOfCompressorsController.h"
#import "Empresa.h"
#import "BlockAlertView.h"
#import "PVCustomPikhubButton.h"
@interface ListOfCompaniesController ()
@end

@implementation ListOfCompaniesController

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Directorio";
    [self.view.layer addSublayer:[self createShadowWithFrame:CGRectMake(0, 0, 320, 5)]];
    [self becomeFirstResponder];
    UIColor* bgColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ipad-BG-pattern.png"]];
    [self.view setBackgroundColor:bgColor];
    /*
    PVCustomPikhubButton *addButton = [[PVCustomPikhubButton alloc] initWithFrame:CGRectZero isBackButton:NO];
    [addButton addTarget:self action:@selector(openNewCompanyView) forControlEvents:UIControlEventTouchUpInside];
    [addButton setButtonTitle:@"Agregar"];
    UIBarButtonItem *addNewCompany = [[UIBarButtonItem alloc] initWithCustomView:addButton];
    [self.navigationItem setRightBarButtonItem:addNewCompany animated:YES];
     */
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 5)];
    [self.tableView.tableFooterView.layer addSublayer:[self createShadowWithFrame:CGRectMake(0, 0, 320, 5)]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self becomeFirstResponder];
    self.companies = [[DataManager sharedInstance] getListOfCompanies];
    [self sortList];
    [self.tableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.companies count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];

    Empresa* empresa = [self.companies objectAtIndex:indexPath.row];
    UILabel *lblNombre = (UILabel*)[cell viewWithTag:100];
    UILabel *lblPersonaContacto = (UILabel*)[cell viewWithTag:101];
    lblNombre.text = empresa.nombreEmpresa;
    lblPersonaContacto.text = empresa.personaContacto;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        BlockAlertView * alert = [[BlockAlertView alloc] initWithTitle:@"Precaución" message:@"Estas apunto de eliminar una empresa y todos sus compresores. ¿Quieres seguir?"];
        [alert setDestructiveButtonWithTitle:@"NO" block:^(void){}];
        __weak DataManager* dataManager = [DataManager sharedInstance];
        __weak UITableView* table = self.tableView;
        __weak NSMutableArray *mutableArray = self.companies;
        [alert addButtonWithTitle:@"Burn, baby!" block:^(void){
            [self eraseNotificationsOfCompany:[mutableArray objectAtIndex:indexPath.row]];
            [dataManager deleteCompanyFromDB:[mutableArray objectAtIndex:indexPath.row]];
            [mutableArray removeObjectAtIndex:indexPath.row];
            [table deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
        }];
        [alert show];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Empresa *empresa = [self.companies objectAtIndex:indexPath.row];
    self.detailViewController.empresa = empresa;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

    if ([segue.identifier isEqualToString:@"verCompresores"]) {
        //ListOfCompressorsController *compresores  = segue.destinationViewController;
        NSIndexPath *index = [self.tableView indexPathForCell:sender];
        [[segue destinationViewController] setCompany:[self.companies objectAtIndex:index.row]];
        //compresores.company = [self.companies objectAtIndex:index.row];
    }
}

#pragma mark metodos privados
-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    if (event.subtype == UIEventSubtypeMotionShake) {
        NSLog(@"Se sacudio");
        NSSortDescriptor *alphabeticSorter = [[NSSortDescriptor alloc] initWithKey:@"nombreEmpresa" ascending:YES];
        [self.companies sortUsingDescriptors:@[ alphabeticSorter ]];
    }
}
-(BOOL)canBecomeFirstResponder{
    return YES;
}

-(void) sortList{
    NSSortDescriptor *alphabeticSorter = [[NSSortDescriptor alloc] initWithKey:@"nombreEmpresa" ascending:YES];
    [self.companies sortUsingDescriptors:@[ alphabeticSorter ]];
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
-(void)openNewCompanyView{
    [self performSegueWithIdentifier:@"agregarEmpresa" sender:nil];
}
-(void)eraseNotificationsOfCompany:(Empresa*)company{
    NSArray *notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification* aNotification in notifications) {
        if ([[aNotification.userInfo valueForKey:@"buyer"] isEqualToString:company.nombreEmpresa]) {
            NSLog(@"Se borrara notificacion de empresa %@ con data %@",company.nombreEmpresa, aNotification.userInfo);
            [[UIApplication sharedApplication] cancelLocalNotification:aNotification];
        }
    }
}
@end
