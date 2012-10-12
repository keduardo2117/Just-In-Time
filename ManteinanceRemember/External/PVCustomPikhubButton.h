//
//  PVBarButtonItem.h
//  Pikhub
//
//  Created by Ricardo Hernández Gómez on 06/12/11.
//  Copyright (c) 2011 Touchtastic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PVCustomPikhubButton : UIView

@property(nonatomic, assign, getter = isBackButton) BOOL backButton;
-(id)initWithFrame:(CGRect)frame isBackButton:(BOOL)isBackButton;
- (void)setButtonTitle:(NSString *)title;
- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

@end

