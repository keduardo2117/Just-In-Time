//
//  DataManager.m
//  ManteinanceRemember
//
//  Created by Eduardo Carrillo Albor on 27/09/12.
//  Copyright (c) 2012 Eduardo Antonio Carrillo Albor. All rights reserved.
//

#import "DataManager.h"
#import "AppDelegate.h"
#import "Empresa.h"
#import "Compresor.h"
#import "Correo.h"
#import "BlockAlertView.h"
@implementation DataManager{
     NSManagedObjectContext *context;
}

- (id)init
{
    self = [super init];
    if (self) {
        context = [(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
    }
    return self;
}

+(id)sharedInstance{
    static DataManager *sharedInstance;
    if (sharedInstance == nil) {
        sharedInstance = [[DataManager alloc] init];
    }
    return sharedInstance;
}
-(NSMutableArray *)getListOfCompanies{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Empresa"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    return [NSMutableArray arrayWithArray:[context executeFetchRequest:fetchRequest error:&error]];
}
-(NSMutableArray*) getCompressorsFromCompany:(Empresa*)company{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"comprador.nombreEmpresa == %@",company.nombreEmpresa];
    [fetchRequest setPredicate:predicate];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Compresor" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError* error = nil;
    return [NSMutableArray arrayWithArray:[context executeFetchRequest:fetchRequest error:&error]];
}

-(NSMutableArray*) getAllCompressors{
    NSArray * compressors = [NSMutableArray array];
    NSArray * companies = [[DataManager sharedInstance] getListOfCompanies];
    for (Empresa * empresa in companies) {
        compressors = [compressors arrayByAddingObjectsFromArray:[[DataManager sharedInstance] getCompressorsFromCompany:empresa]];
    }
    return [NSMutableArray arrayWithArray:compressors];
}

-(NSDictionary*)saveNewCompressor:(NSDictionary *)compressorData forCompany:(Empresa*)company
{
    NSError* error = nil;
    Empresa *comp = (Empresa*)[context objectWithID:company.objectID];
    NSMutableSet *compressorsSet = [comp mutableSetValueForKey:@"compresores"];
    Compresor * compressor = [NSEntityDescription insertNewObjectForEntityForName:@"Compresor" inManagedObjectContext:context];
    compressor.comprador = comp;
    compressor.identifier = [compressorData valueForKey:@"identifier"];
    compressor.modelo = [compressorData valueForKey:@"model"];
    compressor.ultimoMantenimiento = [compressorData valueForKey:@"lastMaintenance"];
    compressor.proximoMantenimiento = [compressorData valueForKey:@"nextMaintenance"];
    compressor.maintennaceInterval = [compressorData valueForKey:@"hoursToNotifyBeforeMaintenance"];
    compressor.observations = compressorData[@"observations"];
    [compressorsSet addObject:compressor];
    
    NSDictionary *response;
    if ([context save:&error])
        response = @{ @"success" : @YES, @"compressor" : compressor};
    else{
        response = @{ @"success" : @NO };
    }
    return response;
}

-(NSDictionary *)saveNewCompany:(NSDictionary *)companyData{
    
    
    NSError * error = nil;
    NSDictionary * response;
    @try {
        Empresa *company = [NSEntityDescription insertNewObjectForEntityForName:@"Empresa" inManagedObjectContext:context];
        company.nombreEmpresa = [companyData valueForKey:@"name"];
        company.personaContacto = [companyData valueForKey:@"contactPerson"];
        
        for (NSString * mail in companyData[@"mail"]) {
            Correo * correo = [NSEntityDescription insertNewObjectForEntityForName:@"Correo" inManagedObjectContext:context];
            correo.correo = mail;
            correo.empresaRelacionada = company;
        }
        
        
        company.telefono = [NSNumber numberWithInteger:[[companyData valueForKey:@"thelephone"] integerValue]];
        [context save:&error];
        response = @{ @"success" : @YES };
    }
    @catch (NSException *exception) {
        BlockAlertView *alert = [[BlockAlertView alloc] initWithTitle:@"Error" message:@"Hubo un problema al salvar, intenta de nuevo."];
        [alert addButtonWithTitle:@"Ok" block:nil];
        [alert show];
        response = @{ @"success" : @NO };
    }
    @finally {
        
    }
        
    return response;
}
-(void) deleteCompressorFromDB:(Compresor*) compressorToDelete{
    Compresor *compressor = (Compresor*)[context objectWithID:[compressorToDelete objectID]];
    NSArray *notificaitonsList = [[UIApplication sharedApplication] scheduledLocalNotifications];
    
    for (UILocalNotification *aNotification in notificaitonsList) {
        NSLog(@"ID de la notificacion %@ == ID del compresor a borrar %@", [aNotification.userInfo valueForKey:@"identifier"], compressor.identifier);
        if ([[aNotification.userInfo valueForKey:@"identifier"] isEqualToString:[compressorToDelete identifier]]) {
            [[UIApplication sharedApplication] cancelLocalNotification:aNotification];
            NSLog(@"Se borro la notificacion");
            break;
        }
    }
    
    NSError *error = nil;
    @try {
        [context deleteObject:compressor];
        [context save:&error];
    }
    @catch (NSException *exception) {
    }
}

-(void) deleteCompanyFromDB:(Empresa*) companyToDelete{
    Empresa *company = (Empresa*)[context objectWithID:[companyToDelete objectID]];
    NSError *error = nil;
    @try {
        [context deleteObject:company];
        [context save:&error];
    }
    @catch (NSException *exception) {
    }
}

-(void)modifyCompressorInDB:(NSDictionary *)compressorData{
    NSEntityDescription * descriptor = [NSEntityDescription entityForName:@"Compresor" inManagedObjectContext:context];
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier = %@",[compressorData valueForKey:@"identifier"]];
    [request setEntity:descriptor];
    [request setPredicate:predicate];
    
    NSError* error = nil;
    Compresor *compressor = (Compresor*)[[context executeFetchRequest:request error:&error] objectAtIndex:0];
    compressor.modelo = [compressorData valueForKey:@"model"];
    compressor.maintennaceInterval = [compressorData valueForKey:@"maintenanceInterval"];
    compressor.identifier = [compressorData valueForKey:@"identifier"];
    compressor.proximoMantenimiento = [compressorData valueForKey:@"nextMaintenance"];
    compressor.ultimoMantenimiento = [compressorData valueForKey:@"lastMaintenance"];
    [context save:&error];
}

+(BOOL)isFirstTime{
    NSString* directory = [NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, NO) objectAtIndex:0];
    NSString *filePath = @"FirstTimeConfig.plist";
    NSString * absoluthePath = [NSString stringWithFormat:@"%@/%@",directory,filePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:absoluthePath]) {
        NSMutableDictionary *FirstTimeConfig = [NSMutableDictionary dictionaryWithContentsOfFile:absoluthePath];
        return (BOOL)[FirstTimeConfig valueForKey:@"isFirstTime"];
    }else{
        return YES;
    }
}

-(void) createFirstTimeMarker{
    NSString* directory = [NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, NO) objectAtIndex:0];
    NSString *filePath = @"FirstTimeConfig.plist";
    NSString * absoluthePath = [NSString stringWithFormat:@"%@/%@",directory,filePath];
    
    NSMutableDictionary *FirstTimeConfig = [NSMutableDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"FirstTimeConfig" ofType:@"plist"]];
    if ([FirstTimeConfig writeToFile:absoluthePath atomically:YES]) {
        NSLog(@"Exito creando marcador");
    }
}

@end
