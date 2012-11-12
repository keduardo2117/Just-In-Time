//
//  Empresa.h
//  ManteinanceRemember
//
//  Created by Eduardo Carrillo Albor on 12/11/12.
//  Copyright (c) 2012 Eduardo Antonio Carrillo Albor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Compresor;

@interface Empresa : NSManagedObject

@property (nonatomic, retain) NSString * correo;
@property (nonatomic, retain) NSString * imagen;
@property (nonatomic, retain) NSString * nombreEmpresa;
@property (nonatomic, retain) NSString * personaContacto;
@property (nonatomic, retain) NSNumber * telefono;
@property (nonatomic, retain) NSSet *compresores;
@end

@interface Empresa (CoreDataGeneratedAccessors)

- (void)addCompresoresObject:(Compresor *)value;
- (void)removeCompresoresObject:(Compresor *)value;
- (void)addCompresores:(NSSet *)values;
- (void)removeCompresores:(NSSet *)values;

@end
