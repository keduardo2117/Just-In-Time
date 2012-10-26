//
//  Compresor.h
//  ManteinanceRemember
//
//  Created by Eduardo Carrillo Albor on 19/10/12.
//  Copyright (c) 2012 Eduardo Antonio Carrillo Albor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Empresa;

@interface Compresor : NSManagedObject

@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSNumber * maintenaceInterval;
@property (nonatomic, retain) NSString * model;
@property (nonatomic, retain) NSDate * nextMaintenance;
@property (nonatomic, retain) NSDate * lastMaintenance;
@property (nonatomic, retain) Empresa *buyer;

@end
