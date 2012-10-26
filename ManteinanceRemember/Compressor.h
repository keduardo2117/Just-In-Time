//
//  Compressor.h
//  ManteinanceRemember
//
//  Created by Eduardo Carrillo Albor on 19/10/12.
//  Copyright (c) 2012 Eduardo Antonio Carrillo Albor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Company;

@interface Compressor : NSManagedObject

@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSNumber * maintenanceInterval;
@property (nonatomic, retain) NSString * model;
@property (nonatomic, retain) NSDate * nextMaintenance;
@property (nonatomic, retain) NSDate * lastMaintenance;
@property (nonatomic, retain) Company *buyer;

@end
