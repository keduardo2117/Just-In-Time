//
//  CompanyInformationDisplayController.m
//  ManteinanceRemember
//
//  Created by Eduardo Carrillo Albor on 25/09/12.
//  Copyright (c) 2012 Eduardo Antonio Carrillo Albor. All rights reserved.
//

#import "CompanyInformationDisplayController.h"
#import "Empresa.h"
#import "BlockAlertView.h"
#import "Reachability.h"
#import "Correo.h"
@interface CompanyInformationDisplayController ()
@end

@implementation CompanyInformationDisplayController{
    NSMutableArray * _mailsLabels;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.actionSheet.transform = CGAffineTransformMakeTranslation(0, 185);
    int i = 0;
    if (!_mailsLabels) {
        _mailsLabels = [@[] mutableCopy];
        for (Correo * mails in self.company.correos) {
            if (i==0){
                self.lblMail.text = mails.correo;
                self.lblMail.tag = i;
                [_mailsLabels addObject:self.lblMail];
            }else{
                UILabel * mail = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 280, 20)];
                mail.tag = i;
                mail.userInteractionEnabled = YES;
                mail.text = mails.correo;
                mail.alpha = 0.0f;
                mail.backgroundColor = [UIColor clearColor];
                [mail setFont:[UIFont systemFontOfSize:17]];
                [mail setTextColor:[UIColor colorWithRed:0 green:0.2666f blue:0.46274f alpha:1.0]];
                [_mailsLabels addObject:mail];
                UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openMailOrMessageSelector:)];
                [mail addGestureRecognizer:tap];
                [self.view addSubview:mail];
            }
            i++;
        }
    }
   
    [UIView animateWithDuration:0.3 animations:^(void){
        self.lblCompanyName.transform = CGAffineTransformMakeTranslation(0, 40);
        self.lblCompanyName.text = self.company.nombreEmpresa;
        self.lblCompanyName.alpha = 1;
        
        self.lblContactPersonName.transform = CGAffineTransformMakeTranslation(0, 80);
        self.lblContactPersonName.text = self.company.personaContacto;
        self.lblContactPersonName.alpha = 1;
       
        if(![self.company.telefono isEqualToNumber:@-1]){
            self.lblTelephone.transform = CGAffineTransformMakeTranslation(0, 120);
            self.lblTelephone.text = [self.company.telefono stringValue];
            self.lblTelephone.alpha = 1;
        }
        
        int xPos = 160;
        if(![[_mailsLabels[0] text] isEqualToString:@"-1"]){
            for (UILabel * mails in _mailsLabels) {
                mails.transform = CGAffineTransformMakeTranslation(0, xPos);
                mails.alpha = 1.0f;
                mails.layer.zPosition = -1;
                xPos += 40;
            }
        }
    }];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    CALayer* actionSheetShadowLayer = [self createShadowWithFrame:CGRectMake(0, 0, 320, 5)];
    [self.actionSheet.layer addSublayer:actionSheetShadowLayer];
    CALayer* viewShadowLayer = [self createShadowWithFrame:CGRectMake(0, 0, 320, 5)];
    [self.view.layer addSublayer:viewShadowLayer];
    UIColor* bgColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ipad-BG-pattern.png"]];
    [self.view setBackgroundColor:bgColor];
    [self setTitleView];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeView:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark private methods
-(CALayer *)createShadowWithFrame:(CGRect)frame
{
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = frame;
    
    UIColor* lightColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    UIColor* darkColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    gradient.colors = [NSArray arrayWithObjects:(id)darkColor.CGColor, (id)lightColor.CGColor, nil];
    
    return gradient;
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
    [lblTitle addGestureRecognizer:self.closeViewTap];
    [self.navigationItem setTitleView:lblTitle];
}

-(IBAction)openMailOrMessageSelector:(id)sender{
    for (UILabel * lbl in _mailsLabels) {
        if([lbl.gestureRecognizers[0] isEqual:sender]){
            [self openActionSheet:lbl.tag];
        }
    }
}
-(IBAction)openMailComposer{
    [self closeActionSheet];
    Reachability * reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus status = [reachability currentReachabilityStatus];
    if (status != NotReachable) {
        if ([MFMailComposeViewController canSendMail]) {
            MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
            mailComposer.mailComposeDelegate = self;
            [mailComposer setSubject:@"Aviso de mantenimiento"];
            UILabel * lbl = _mailsLabels[self.actionSheet.tag];
            [mailComposer setToRecipients:@[lbl.text]];
            [mailComposer setBccRecipients:@[@"tcste@prodigy.net.mx", @"tcsureste@gmail.com", @"mx.canmar@gmail.com"]];
            [mailComposer setMessageBody:@"Tecnocompresores del sureste \n Ing. Max Cano Marquez" isHTML:NO];
            [self presentViewController:mailComposer animated:YES completion:nil];
        }
    } else{
        BlockAlertView *alert = [[BlockAlertView alloc] initWithTitle:@"Error" message:@"No puedes enviar mails en este momento, revisa tu conexion a internet."];
        [alert setDestructiveButtonWithTitle:@"Recibido" block:nil];
        [alert show];
    }
}
-(IBAction)openMessageComposer{
    [self closeActionSheet];
    Reachability * reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus status = [reachability currentReachabilityStatus];
    if (status != NotReachable) {
        if ([MFMessageComposeViewController canSendText]) {
            MFMessageComposeViewController *messageComposer = [[MFMessageComposeViewController alloc] init];
            messageComposer.messageComposeDelegate = self;
            UILabel * lbl = _mailsLabels[self.actionSheet.tag];
            [messageComposer setRecipients:@[lbl.text]];
            [messageComposer setBody:@"Mantenimiento"];
            [self presentViewController:messageComposer animated:YES completion:nil];
        }
    }
    else{
        BlockAlertView *alert = [[BlockAlertView alloc] initWithTitle:@"Error"
                                                              message:@"No puedes enviar mails en este momento, revisa tu conexion a internet."];
        [alert setDestructiveButtonWithTitle:@"Recibido" block:nil];
        [alert show];
    }
}
-(IBAction) cancelMailOrMessageSending{
    [self closeActionSheet];
}
-(void)openActionSheet:(int)tag{
    [UIView animateWithDuration:0.3 animations:^(void){
        self.actionSheet.transform = CGAffineTransformMakeTranslation(0, -185);
        self.actionSheet.tag = tag;
    }];
}
-(void)closeActionSheet{
    [UIView animateWithDuration:0.3 animations:^(void){
        self.actionSheet.transform = CGAffineTransformMakeTranslation(0, 0);
    }];
}
#pragma mark MFMailComposeViewControllerDelegate
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    switch (result) {
        case MFMailComposeResultSent:{
            BlockAlertView *alert = [[BlockAlertView alloc] initWithTitle:@"Yay" message:@"El mensaje se envio con exito, viva yo."];
            [alert setDestructiveButtonWithTitle:@"Tu si sabes!" block:nil];
            [alert show];
        }
            break;
        case MFMailComposeResultFailed:{
            BlockAlertView *alert = [[BlockAlertView alloc] initWithTitle:@"Ouch!" message:@"El mensaje no se pudo enviar"];
            [alert setDestructiveButtonWithTitle:@"Ni modo :/" block:nil];
            [alert show];
        }
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark MFMessageComposeViewControllerDelegate
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    switch (result) {
        case MessageComposeResultSent:{
            BlockAlertView *alert = [[BlockAlertView alloc] initWithTitle:@"Yay" message:@"El mensaje se envio con exito, viva yo."];
            [alert setDestructiveButtonWithTitle:@"Tu si sabes!" block:nil];
            [alert show];
        }
            break;
        case MessageComposeResultFailed:{
            BlockAlertView *alert = [[BlockAlertView alloc] initWithTitle:@"Ouch!" message:@"El mensaje no se pudo enviar"];
            [alert setDestructiveButtonWithTitle:@"Ni modo :/" block:nil];
            [alert show];
        }
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
