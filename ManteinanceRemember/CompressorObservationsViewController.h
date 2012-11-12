//
//  CompressorObservationsViewController.h
//  ManteinanceRemember
//
//  Created by Eduardo Carrillo Albor on 12/11/12.
//  Copyright (c) 2012 Eduardo Antonio Carrillo Albor. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ObservationsDelegate<NSObject>
-(void) textView:(UITextView*)textView didChageContent:(NSString *) content;
@end
@interface CompressorObservationsViewController : UIViewController<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *txtVObservations;
@property (weak, nonatomic) id<ObservationsDelegate> delegate;
@property (nonatomic, strong) NSString *observation;
@end
