//
//  Company.h
//  ManteinanceRemember
//
//  Created by Eduardo Carrillo Albor on 19/10/12.
//  Copyright (c) 2012 Eduardo Antonio Carrillo Albor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Compressor;

@interface Company : NSManagedObject

@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * companyName;
@property (nonatomic, retain) NSString * contactPerson;
@property (nonatomic, retain) NSNumber * telephone;
@property (nonatomic, retain) NSSet *compressors;
@end

@interface Company (CoreDataGeneratedAccessors)

- (void)addCompressorsObject:(Compressor *)value;
- (void)removeCompressorsObject:(Compressor *)value;
- (void)addCompressors:(NSSet *)values;
- (void)removeCompressors:(NSSet *)values;

@end
