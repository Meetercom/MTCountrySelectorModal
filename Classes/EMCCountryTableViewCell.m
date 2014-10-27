//
//  EMCCountryTableViewCell.m
//  Pods
//
//  Created by Gaston Morixe on 8/28/14.
//
//

#import "EMCCountryTableViewCell.h"

@implementation EMCCountryTableViewCell

-(instancetype)init{
    self = [super init];
    if(self){
        [self setup];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self setup];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self setup];
    }
    return self;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self setup];
    }
    return self;
}

-(void)setup{
    self.backgroundColor = [UIColor clearColor];
    self.textLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:.4f];
//    self.textLabel.highlightedTextColor = [UIColor ]
    self.textLabel.font = [UIFont systemFontOfSize:24.0f];
    
    UIView *bgColorView = [[UIView alloc] init];
//    bgColorView.backgroundColor = [UIColor colorWithRed:1 green:0.149 blue:0 alpha:.9];
    bgColorView.backgroundColor = [UIColor colorWithRed:10/255.0f green:10/255.0f blue:10/255.0f alpha:.5];
    self.selectionStyle = UITableViewCellSelectionStyleDefault;
    self.selectedBackgroundView = bgColorView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}




@end
