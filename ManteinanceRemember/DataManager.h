//
//  DataManager.h
//  ManteinanceRemember
//
//  Created by Eduardo Carrillo Albor on 27/09/12.
//  Copyright (c) 2012 Eduardo Antonio Carrillo Albor. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Empresa, Compresor;
@interface DataManager : NSObject

+(id)sharedInstance;
-(NSMutableArray*) getListOfCompanies;
-(NSMutableArray*) getCompressorsFromCompany:(Empresa*)company;
-(NSMutableArray*) getAllCompressors;
-(NSDictionary*)saveNewCompressor:(NSDictionary *)compressorData forCompany:(Empresa*)company;
-(NSDictionary*)saveNewCompany:(NSDictionary*)companyData;
-(void) deleteCompressorFromDB:(Compresor*) compressorToDelete;
-(void) deleteCompanyFromDB:(Empresa*) companyToDelete;
-(void) modifyCompressorInDB:(NSDictionary*) compressorData;
+(BOOL)isFirstTime;
-(void) createFirstTimeMarker;
@end
