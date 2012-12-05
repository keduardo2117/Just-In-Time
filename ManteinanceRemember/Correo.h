//
//  Correo.h
//  ManteinanceRemember
//
//  Created by Eduardo Carrillo Albor on 04/12/12.
//  Copyright (c) 2012 Eduardo Antonio Carrillo Albor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Empresa;

@interface Correo : NSManagedObject

@property (nonatomic, retain) NSString * correo;
@property (nonatomic, retain) Empresa *empresaRelacionada;

@end
