//
//  BlurView.m
//
//  Created by Peter Gulyas on 2/5/2014.
//  Copyright (c) 2014 DATInc. All rights reserved.
//
//

#import "DATBlurView.h"
#import <objc/objc.h>

@interface DATBlurView ()

@property (nonatomic, strong) UIToolbar *toolbar;

@end

@implementation DATBlurView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (void)setup {
    self.clipsToBounds = YES;

    self.toolbar = [[UIToolbar alloc] initWithFrame:self.bounds];
    self.toolbar.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.toolbar.barStyle = UIBarStyleBlack;
    [self insertSubview:self.toolbar atIndex:0];

}

-(void)setBarStyle:(UIBarStyle)style{
    self.toolbar.barStyle = style;
}



@end
