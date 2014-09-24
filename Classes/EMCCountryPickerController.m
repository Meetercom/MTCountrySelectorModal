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
    
    //    DATBlurView* blurView = [[DATBlurView alloc] initWithFrame:self.view.frame];
    //    blurView.autoresizingMask =  UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    //    [self.view insertSubview:blurView atIndex:0];
    
    
    
    countryTable = [[UITableView alloc] init];
    countryTable.dataSource = self;
    countryTable.delegate   = self;
    [countryTable registerClass:[EMCCountryTableViewCell class] forCellReuseIdentifier:@"identifier"];
    countryTable.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:countryTable];
    countryTable.backgroundColor = [UIColor clearColor];
    countryTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    countryTable.indicatorStyle = UIScrollViewIndicatorStyleWhite;

    
//    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
////    self.searchController.dimsBackgroundDuringPresentation = NO;
////    self.searchController.hidesNavigationBarDuringPresentation = NO;
//    self.searchController.searchResultsUpdater             = self;
//    self.searchController.delegate                         = self;
//    self.searchController.active                           = NO;
//    [self.view addSubview:self.searchController.searchBar];
//    self.searchController.searchBar.frame = CGRectMake(0, 0,
//                                                       self.view.bounds.size.width, 100);
//    self.searchController.searchBar.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
//    [self.searchController.searchBar sizeToFit];
//    
//    [countryTable autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
//    [countryTable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
//    [countryTable autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
//    [countryTable autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.searchController.searchBar];
    
    [countryTable autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
}

//
//- (void)loadView
//{
//    NSLog(@"load view");
//    rootView = [[UIView alloc] initWithFrame:CGRectZero];
//    rootView.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:.5f];
////    rootView.autoresizesSubviews = YES;
//    
//
////    [[[self searchDisplayController] searchResultsTableView] registerClass:[EMCCountryTableViewCell class]
////                                                    forCellReuseIdentifier:@"identifier"];
//    
////    if ([self searchDisplayController] == nil) NSLog(@"Search DC is nil");
//    
//    
//
//    
////    displayController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
////    displayController.searchResultsTableView.backgroundColor = [UIColor clearColor];
//    
////    searchBar.backgroundColor = [UIColor clearColor];
////    searchBar.barTintColor = [UIColor clearColor];
////    searchBar.backgroundImage = [[UIImage alloc] init];
////    searchBar.tintColor = [UIColor whiteColor];
////    searchBar.layer.borderWidth = 0.0f;
//    
////    UITextField* searchBarField = [searchBar firstSubviewOfClass:[UITextField class]];
////    searchBarField.background = [UIImage new];
////    searchBarField.layer.borderWidth = 0.0f;
////    searchBarField.font = [UIFont systemFontOfSize:20];
////    searchBarField.textColor = [UIColor whiteColor];
////    searchBarField.frame = CGRectInset(searchBarField.frame, 0, 10);
////    searchBarField.translatesAutoresizingMaskIntoConstraints = false;
////    searchBarField.backgroundColor = [UIColor clearColor];
////    
//    
//    self.view = rootView;
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Settings Management


- (void)loadDefaults
{
}

#pragma mark - Table View Management

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (tableView == self.searchDisplayController.searchResultsTableView)
//    {
//        return [_countrySearchResults count];
//    }
    
    // Return the number of rows in the section.
    return [_countries count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Selected row: %ld", (long)indexPath.row);
    
//    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    if (tableView == self.searchDisplayController.searchResultsTableView)
//    {
//        _selectedCountry = [_countrySearchResults objectAtIndex:indexPath.row];
//        [self loadCountrySelection];
//    }
//    else
//    {
        _selectedCountry = [_countries objectAtIndex:indexPath.row];
//    }
    
    if (!self.countryDelegate)
    {
        NSLog(@"Delegate is not set, the view controller will not be dismissed.");
    }
    
    [self.countryDelegate countryController:self didSelectCountry:_selectedCountry];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifier" forIndexPath:indexPath];
    

    EMCCountry *currentCountry;
    
//    if (tableView == self.searchDisplayController.searchResultsTableView)
//    {
//        currentCountry = [_countrySearchResults objectAtIndex:indexPath.row];
//    }
//    else
//    {
    currentCountry = [_countries objectAtIndex:indexPath.row];
//    }
    
//    NSString *countryCode = [currentCountry countryCode];
    
    if (self.countryNameDisplayLocale){
        cell.textLabel.text = [currentCountry countryNameWithLocale:self.countryNameDisplayLocale];
    }else{
        cell.textLabel.text = [NSString stringWithFormat:@"%@ +%@", [currentCountry countryName], [currentCountry countryPhoneCode]];
    }
    
    if (_selectedCountry && [_selectedCountry isEqual:currentCountry]) {
        NSLog(@"Selection is %ld:%ld.", (long)tableView.indexPathForSelectedRow.section, (long)tableView.indexPathForSelectedRow.row);
//        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kEMCCountryCellControllerMinCellHeight;
}



//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    return self.searchController.searchBar;
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 100.0f;
//}
//


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


//-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
//{
//    
//    [self filterContentForSearchText:searchString
//                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
//                                      objectAtIndex:[self.searchDisplayController.searchBar
//                                                     selectedScopeButtonIndex]]];
//    return YES;
//}
//
//-(void)searchDisplayController:(UISearchDisplayController *)controller didShowSearchResultsTableView:(UITableView *)tableView{
//    // Hides border
//    dispatch_async(dispatch_get_main_queue(), ^{
//        UIView* searchShadow = [tableView firstSubviewOfClass:NSClassFromString(@"_UISearchBarShadowView")];
//        searchShadow.hidden = YES;
//        searchShadow.alpha = 0.0f;
//    });
//}
//
//-(void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView{
//    countryTable.alpha = 0.0f;
//}
//
//- (void)searchDisplayController:(UISearchDisplayController *)controller didHideSearchResultsTableView:(UITableView *)tableView
//{
//    countryTable.alpha = 1.0f;
//    [self loadCountrySelection];
//}

#pragma mark - Country Management

- (void)chooseCountry:(NSString *)countryCode
{
    _selectedCountry = [[EMCCountryManager countryManager] countryWithCode:countryCode];
    
//    _selectedCountry = [_countries objectAtIndex:indexPath.row];

    if (!self.countryDelegate)
    {
        NSLog(@"Delegate is not set, the view controller will not be dismissed.");
    }else{
        [self.countryDelegate countryController:self didSelectCountry:_selectedCountry];
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
