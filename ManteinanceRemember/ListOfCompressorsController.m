//
//  DatosEmpresaViewController.m
//  ManteinanceRemember
//
//  Created by Eduardo Carrillo Albor on 08/09/12.
//  Copyright (c) 2012 Eduardo Antonio Carrillo Albor. All rights reserved.
//

#import "ListOfCompressorsController.h"
#import "Empresa.h"
#import "Compresor.h"
#import "NewCompressorController.h"
#import "CompanyInformationDisplayController.h"
#import "PVCustomPikhubButton.h"
#import "BlockAlertView.h"

@interface ListOfCompressorsController ()

@end

@implementation ListOfCompressorsController{
    NSMutableArray *compressors;
    NSString *sortValue;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"newCompressor"]){
        UINavigationController *navCon = segue.destinationViewController;
        NewCompressorController* newCompressorView = [navCon.viewControllers objectAtIndex:0];
        [newCompressorView setEmpresa:self.company];
        newCompressorView.delegate = self;
    }else if([segue.identifier isEqualToString:@"companyData"]){
        UINavigationController *navCon = segue.destinationViewController;
        CompanyInformationDisplayController* newInfoDisplayerView = [navCon.viewControllers objectAtIndex:0];
        [newInfoDisplayerView setCompany:self.company];
    }else if ([segue.identifier isEqualToString:@"editCompressor"]){
        UINavigationController *navCon = segue.destinationViewController;
        NewCompressorController* newCompressorView = [navCon.viewControllers objectAtIndex:0];
        UITableViewCell *cell = sender;
        newCompressorView.compressor = [compressors objectAtIndex:cell.tag];
        newCompressorView.delegate =self;
    }
}
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    CALayer* shadowLayer = [self createShadowWithFrame:CGRectMake(0, 0, 320, 5)];
    [self.view.layer addSublayer:shadowLayer];
    
    sortValue = @"proximoMantenimiento";
    UIColor* bgColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ipad-BG-pattern.png"]];
    [self.view setBackgroundColor:bgColor];

    
    if (self.company) {
        [self setTitleView];
        compressors = [[DataManager sharedInstance] getCompressorsFromCompany:self.company];
    }else{
        compressors = [[DataManager sharedInstance] getAllCompressors];
        [self.navigationItem setRightBarButtonItem:nil];
    }
    NSLog(@"COMPRESORES %d",compressors.count);
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 5)];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillAppear:(BOOL)animated{
    [self becomeFirstResponder];
    [super viewWillAppear:animated];
    if (self.company) {
        compressors = [[DataManager sharedInstance] getCompressorsFromCompany:self.company];
    }else{
        compressors = [[DataManager sharedInstance] getAllCompressors];
        [self.navigationItem setRightBarButtonItem:nil];
    }
    [self sortListByValue:sortValue];
    if (compressors.count != 0 && [[self.tableView.tableFooterView.layer sublayers] count] == 0) {
        [self.tableView.tableFooterView.layer addSublayer:[self createShadowWithFrame:CGRectMake(0, 0, 320, 5)]];
    }
    [self.tableView reloadData];
}

-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    if (event.subtype == UIEventSubtypeMotionShake) {
        if ([sortValue isEqualToString:@"modelo"]) {
            [SVProgressHUD showSuccessWithStatus:@"Por mantenimieto mas proximo"];
            sortValue = @"proximoMantenimiento";
        }else if ([sortValue isEqualToString:@"proximoMantenimiento"]){
            [SVProgressHUD showSuccessWithStatus:@"Por ultimo mantenimieto"];
            sortValue = @"ultimoMantenimiento";
        }else{
            [SVProgressHUD showSuccessWithStatus:@"Por orden alfabetico"];
            sortValue = @"modelo";
        }
        [self sortListByValue:sortValue];
        [self.tableView reloadData];
    }
    if ([super respondsToSelector:@selector(motionEnded:withEvent:)])
        [super motionEnded:motion withEvent:event];
}
-(BOOL)canBecomeFirstResponder{
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [compressors count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    Compresor* compressor = [compressors objectAtIndex:indexPath.row];
    UILabel *lblNameOfCompressor = (UILabel*)[cell viewWithTag:100];
    UILabel *lblLastMaintenance = (UILabel*) [cell viewWithTag:101];
    UILabel * lblNextMaintenance = (UILabel*) [cell viewWithTag:102];
    lblNameOfCompressor.text = compressor.modelo;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setDateStyle:NSDateFormatterLongStyle];
    lblLastMaintenance.text = [NSString stringWithFormat:@"Ultimo mantenimiento %@", [formatter stringFromDate:compressor.ultimoMantenimiento]];
    lblNextMaintenance.text = [NSString stringWithFormat:@"Prox. mantenimiento %@",[formatter stringFromDate:compressor.proximoMantenimiento]];
    
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        BlockAlertView * alert = [[BlockAlertView alloc] initWithTitle:@"Precaucion" message:@"Estas a punto de borrar un compresor. ¿Deseas continuar?"];
        [alert setDestructiveButtonWithTitle:@"NO" block:^(void){}];
        __weak UITableView* table = self.tableView;
        __weak NSMutableArray *mutableArray = compressors;
        __weak DataManager* dataManager = [DataManager sharedInstance];
        [alert addButtonWithTitle:@"Let's do this!" block:^(void){
            [dataManager deleteCompressorFromDB:[mutableArray objectAtIndex:indexPath.row]];
            [mutableArray removeObjectAtIndex:indexPath.row];
            [table deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
        }];
        [alert show];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.company) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.tag = indexPath.row;
        [self performSegueWithIdentifier:@"editCompressor" sender:cell];
    }
}
#pragma mark NewCompressorDelegate
-(void)saveNewCompressor:(NSDictionary *)companyData{
    NSMutableDictionary* data = [NSMutableDictionary dictionaryWithDictionary:companyData];
    [data setValue:self.company.nombreEmpresa forKey:@"buyer"];
    [self createLocalNotificationWithData:data];
    [[DataManager sharedInstance] saveNewCompressor:data forCompany:self.company];
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void)modifyCompressor:(NSDictionary *)companyData{
    NSMutableDictionary* data = [NSMutableDictionary dictionaryWithDictionary:companyData];
    [data setValue:self.company.nombreEmpresa forKey:@"buyer"];
    [[DataManager sharedInstance] modifyCompressorInDB:data];
    
    [self eraseOldNotification:data];
    [self createLocalNotificationWithData:data];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark private methods
-(void) sortListByValue:(NSString*)value{
    NSSortDescriptor *alphabeticSorter = [[NSSortDescriptor alloc] initWithKey:value ascending:YES];
    [compressors sortUsingDescriptors:@[ alphabeticSorter ]];
}

-(void)showCompanyData{
    [self performSegueWithIdentifier:@"companyData" sender:self];
}

-(void)setTitleView{
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 37)];
    [lblTitle setTextAlignment:NSTextAlignmentCenter];
    [lblTitle setFont:[UIFont systemFontOfSize:18]];
    [lblTitle setBackgroundColor:[UIColor clearColor]];
    [lblTitle setUserInteractionEnabled:YES];
    lblTitle.textColor = [UIColor whiteColor];
    lblTitle.shadowColor = [UIColor blackColor];
    [lblTitle setShadowOffset:CGSizeMake(0, -1)];
    lblTitle.text = self.company.nombreEmpresa;
    [lblTitle addGestureRecognizer:self.showCompanyDataTap];
    [self.navigationItem setTitleView:lblTitle];
}
-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
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

-(void)openNewCompressorView{
    [self performSegueWithIdentifier:@"newCompressor" sender:nil];
}

-(void)createLocalNotificationWithData:(NSDictionary*)compressorData{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[compressorData valueForKey:@"identifier"],@"identifier", [compressorData valueForKey:@"buyer"],@"buyer", nil];
    NSTimeInterval interval = [[compressorData valueForKey:@"hoursToNotifyBeforeMaintenance"] intValue]*60*60;
    NSDate* lastMaintenanceDate = [compressorData valueForKey:@"nextMaintenance"];
    NSDate* notificationDate = [lastMaintenanceDate dateByAddingTimeInterval:interval];
    
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    localNotif.timeZone = [NSTimeZone localTimeZone];
    localNotif.userInfo = userInfo;
    localNotif.fireDate = notificationDate;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
    NSLog(@"Se creo nueva notificacion con user data %@",userInfo);
}

-(void)eraseOldNotification:(NSDictionary*)compressorData{
    NSArray *notificaitonsList = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification *aNotification in notificaitonsList) {
        if ([[aNotification.userInfo valueForKey:@"identifier"] isEqualToString:[compressorData valueForKey:@"identifier"]]) {
            [[UIApplication sharedApplication] cancelLocalNotification:aNotification];
            NSLog(@"Se borro la notificacion");
            break;
        }
    }
}
@end
