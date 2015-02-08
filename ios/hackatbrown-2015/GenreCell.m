//
//  GenreCell.m
//  hackatbrown-2015
//
//  Created by Matt Cooper on 2/7/15.
//  Copyright (c) 2015 Matthew Cooper. All rights reserved.
//

#import "GenreCell.h"

#import "ColorConstants.h"

@implementation GenreCell

- (instancetype)init{
    if (self = [super init]) {
        UIView * selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
        [selectedBackgroundView setBackgroundColor:[UIColor clearColor]]; // set color here
        [self setSelectedBackgroundView:selectedBackgroundView];
    }
    
    return self;
    
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super initWithCoder:aDecoder]) {
        UIView * selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
        [selectedBackgroundView setBackgroundColor:[UIColor clearColor]]; // set color here
        [self setSelectedBackgroundView:selectedBackgroundView];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    
    UIColor *newColor;
    BOOL checkmarkAlpha;
    if (selected) {
        newColor = kOrangeColor;
        checkmarkAlpha = 1;
    }else{
        newColor = kBlueColor;
        checkmarkAlpha = 0;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        [self setBackgroundColor:newColor];
        [self.checkmark setAlpha:checkmarkAlpha];
    }];
    
    [super setSelected:selected animated:animated];

}

@end
