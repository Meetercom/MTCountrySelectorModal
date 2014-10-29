//
//  EMCChooseCountryViewControllerManual.m
//  EMCCountryPickerController
//
//  Created by Enrico Maria Crisostomo on 12/05/14.
//  Copyright (c) 2014 Enrico M. Crisostomo. All rights reserved.
//

#import "EMCCountryPickerController.h"
#import "UIImage+UIImage_EMCImageResize.h"
#import "EMCCountryManager.h"
#import "DATBlurView.h"
#import "EMCCountryTableViewCell.h"

#import "UIView+hirarchy.h"
#import <PureLayout.h>
#import <QuartzCore/QuartzCore.h>

#if !__has_feature(objc_arc)
#error This class requires ARC support to be enabled.
#endif

static const CGFloat kEMCCountryCellControllerMinCellHeight = 80.0f;

@interface EMCCountryPickerController ()
@property (nonatomic, strong) UISearchController* searchController;
@property (nonatomic, strong) UIFont* lightFont;
@property (nonatomic, strong) UIFont* strongFont;
@end

@implementation EMCCountryPickerController
{
    UITableView *countryTable;
    EMCCountry * _selectedCountry;
    NSArray *_countries;
    NSArray *_countrySearchResults;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        [self loadDefaults];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        [self loadDefaults];
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadCountrySelection];
}


- (void)loadCountrySelection
{
    if (!_selectedCountry)
        return;
    
    NSUInteger selectedObjectIndex = [_countries indexOfObject:_selectedCountry];
    
    if (selectedObjectIndex != NSNotFound)
    {
        NSIndexPath * ip = [NSIndexPath indexPathForItem:selectedObjectIndex inSection:0];
        if(![countryTable.indexPathsForVisibleRows containsObject:ip]){
            [countryTable selectRowAtIndexPath:ip animated:NO scrollPosition:UITableViewScrollPositionTop];
        }
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //    [self validateSettings];
    [self loadCountries];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    

    CAGradientLayer *l                = [CAGradientLayer layer];
    l.frame                           = self.view.bounds;
    l.colors                          = @[(id)[UIColor whiteColor].CGColor, (id)[UIColor clearColor].CGColor];
    l.startPoint                      = CGPointMake(0.5f, 0.5f);
    l.endPoint                        = CGPointMake(0.5f, 1.0f);
    self.view.layer.mask = l;
    
    
    countryTable = [[UITableView alloc] init];
    countryTable.dataSource = self;
    countryTable.delegate   = self;
    [countryTable registerClass:[EMCCountryTableViewCell class] forCellReuseIdentifier:@"identifier"];
    countryTable.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:countryTable];
    countryTable.backgroundColor = [UIColor clearColor];
    countryTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    countryTable.indicatorStyle = UIScrollViewIndicatorStyleWhite;

    [countryTable autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Settings Management


- (void)loadDefaults
{
    self.lightFont = [UIFont lightSystemFontOfSize:25.0f];
    self.strongFont = [UIFont systemFontOfSize:25.0f];
}

#pragma mark - Table View Management

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_countries count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Selected row: %ld", (long)indexPath.row);
    
    _selectedCountry = [_countries objectAtIndex:indexPath.row];
    
    if (!self.countryDelegate)
    {
        NSLog(@"Delegate is not set, the view controller will not be dismissed.");
    }
    
    [self.countryDelegate countryController:self didSelectCountry:_selectedCountry programatically:NO];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifier" forIndexPath:indexPath];
    

    EMCCountry *currentCountry;
    
    currentCountry = [_countries objectAtIndex:indexPath.row];
    
    if (self.countryNameDisplayLocale){
        cell.textLabel.text = [currentCountry countryNameWithLocale:self.countryNameDisplayLocale];
    }else{
        
        NSMutableAttributedString* attrString = [[NSMutableAttributedString alloc] initWithString:[currentCountry countryName] attributes:@{NSFontAttributeName: self.lightFont}];
        
        NSAttributedString* countryCodeAttributedString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" +%@", [currentCountry countryPhoneCode]] attributes:@{NSFontAttributeName: self.strongFont}];
        
        [attrString appendAttributedString:countryCodeAttributedString];
        
        cell.textLabel.attributedText = attrString;
    }
    
    if (_selectedCountry && [_selectedCountry isEqual:currentCountry]) {
        NSLog(@"Selection is %ld:%ld.", (long)tableView.indexPathForSelectedRow.section, (long)tableView.indexPathForSelectedRow.row);
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kEMCCountryCellControllerMinCellHeight;
}


#pragma mark - Search Box Management

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    NSLog(@"update search");
}



- (void)filterContentForSearchText:(NSString*)searchText
                             scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF.countryName contains[cd] %@", searchText];
    
    _countrySearchResults = [_countries filteredArrayUsingPredicate:resultPredicate];
}
#pragma mark - Country Management

- (void)chooseCountry:(NSString *)countryCode programatically:(BOOL)programatically
{
    _selectedCountry = [[EMCCountryManager countryManager] countryWithCode:countryCode];
    
    if (!self.countryDelegate)
    {
        NSLog(@"Delegate is not set, the view controller will not be dismissed.");
    }else{
        [self.countryDelegate countryController:self didSelectCountry:_selectedCountry programatically:programatically];
    }

}

- (NSArray *)filterAvailableCountries:(NSSet *)countryCodes
{
    EMCCountryManager *countryManager = [EMCCountryManager countryManager];
    NSMutableArray *countries = [[NSMutableArray alloc] initWithCapacity:[countryCodes count]];
    
    for (id code in self.availableCountryCodes)
    {
        if ([countryManager existsCountryWithCode:code])
        {
            [countries addObject:[countryManager countryWithCode:code]];
        }
        else
        {
            [NSException raise:@"Unknown country code"
                        format:@"Unknown country code %@", code];
        }
    }
    
    return countries;
}

- (void)loadCountries
{
    NSArray *availableCountries;
    
    if (self.availableCountryCodes)
    {
        availableCountries = [self filterAvailableCountries:self.availableCountryCodes];
    }
    else
    {
        availableCountries = [[EMCCountryManager countryManager] allCountries];
    }
    
    NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"countryName" ascending:YES];
    NSArray *descriptors = [NSArray arrayWithObjects:nameDescriptor, nil];
    _countries = [availableCountries sortedArrayUsingDescriptors:descriptors];
}

@end
