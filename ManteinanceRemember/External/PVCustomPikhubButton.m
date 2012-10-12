//
//  PVBarButtonItem.m
//  Pikhub
//
//  Created by Ricardo Hernández Gómez on 06/12/11.
//  Copyright (c) 2011 Touchtastic. All rights reserved.
//

#import "PVCustomPikhubButton.h"

@implementation PVCustomPikhubButton{
    UIButton *button;
}

- (id)initWithFrame:(CGRect)frame isBackButton:(BOOL)isBackButton
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backButton = isBackButton;
        
        UIImage *normalButtonImage;
        UIImage *stretchableNormalButtonImage;
        
        if (self.backButton)
        {
            normalButtonImage = [UIImage imageNamed:@"ipad-back.png"];
            stretchableNormalButtonImage = [normalButtonImage stretchableImageWithLeftCapWidth:19 topCapHeight:0];
        }else
        {
            normalButtonImage = [UIImage imageNamed:@"menubar-button"];
            stretchableNormalButtonImage = [normalButtonImage stretchableImageWithLeftCapWidth:15 topCapHeight:0];
        }
        
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:stretchableNormalButtonImage forState:UIControlStateNormal];
                
        [[button titleLabel] setFont:[UIFont systemFontOfSize:14]];
        [button setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
        [[button titleLabel] setShadowOffset:CGSizeMake(0, -1)];
        
        [self addSubview:button];
    }
    return self;

}

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    [button addTarget:target action:action forControlEvents:controlEvents];
}



- (void)setButtonTitle:(NSString *)title;
{
    [button setTitle:title forState:UIControlStateNormal];
    CGSize textSize = [[[button titleLabel] text] sizeWithFont:[[button titleLabel] font]];
    CGFloat strikeWidth = textSize.width;
    if ([self isBackButton]) {
        [button setFrame:CGRectMake(0, 0, strikeWidth + 20, 30)];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
        [self setFrame:button.frame];
    }
    [button setFrame:CGRectMake(0, 0, strikeWidth + 20, 30)];
    [self setFrame:button.frame];
}

- (void)layoutSubViews
{
    [super layoutSubviews];
}

@end
