//
//  Empresa.h
//  ManteinanceRemember
//
//  Created by Eduardo Carrillo Albor on 04/12/12.
//  Copyright (c) 2012 Eduardo Antonio Carrillo Albor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Compresor;

@interface Empresa : NSManagedObject

@property (nonatomic, retain) NSString * nombreEmpresa;
@property (nonatomic, retain) NSString * personaContacto;
@property (nonatomic, retain) NSNumber * telefono;
@property (nonatomic, retain) NSSet *compresores;
@property (nonatomic, retain) NSSet *correos;
@end

@interface Empresa (CoreDataGeneratedAccessors)

- (void)addCompresoresObject:(Compresor *)value;
- (void)removeCompresoresObject:(Compresor *)value;
- (void)addCompresores:(NSSet *)values;
- (void)removeCompresores:(NSSet *)values;

- (void)addCorreosObject:(NSManagedObject *)value;
- (void)removeCorreosObject:(NSManagedObject *)value;
- (void)addCorreos:(NSSet *)values;
- (void)removeCorreos:(NSSet *)values;

@end
