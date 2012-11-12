//
//  Compresor.h
//  ManteinanceRemember
//
//  Created by Eduardo Carrillo Albor on 12/11/12.
//  Copyright (c) 2012 Eduardo Antonio Carrillo Albor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Empresa;

@interface Compresor : NSManagedObject

@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSNumber * maintennaceInterval;
@property (nonatomic, retain) NSString * modelo;
@property (nonatomic, retain) NSDate * proximoMantenimiento;
@property (nonatomic, retain) NSDate * ultimoMantenimiento;
@property (nonatomic, retain) NSString * observations;
@property (nonatomic, retain) Empresa *comprador;

@end
