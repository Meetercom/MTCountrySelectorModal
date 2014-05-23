//
//  PMMCountry.m
//  Push Money Mobile
//
//  Created by Enrico Maria Crisostomo on 18/05/14.
//  Copyright (c) 2014 Grey Systems. All rights reserved.
//

#import "EMCCountry.h"
#import "EMCCountryManager.h"

static NSString * const kDefaultLocale = @"en";

@implementation EMCCountry
{
    NSDictionary *_names;
}

+ (instancetype)countryWithCountryCode:(NSString *)code localizedNames:(NSDictionary *)names
{
    return [[EMCCountry alloc] initWithCountryCode:code localizedNames:names];
}

- (instancetype)init
{
    NSException* exception = [NSException
                              exceptionWithName:@"UnsupportedOperationException"
                              reason:@"This class cannot be instantiated."
                              userInfo:nil];
    @throw exception;
}

- (instancetype)initWithCountryCode:(NSString *)code localizedNames:(NSDictionary *)names
{
    self = [super init];
    
    if (self)
    {
        _countryCode = code;
        _names = [NSDictionary dictionaryWithDictionary:names];
    }
    
    return self;
}

- (BOOL)isEqual:(id)other
{
    if (other == self)
        return YES;
    if (!other || ![other isKindOfClass:[self class]])
        return NO;
    
    return [self isEqualToCountry:other];
}

- (BOOL)isEqualToCountry:(EMCCountry *)aCountry
{
    if (self == aCountry)
        return YES;
    
    return [[self countryCode] isEqualToString:[aCountry countryCode]];
}

- (NSString *)countryName
{
    NSString *localisedName = _names[[[NSLocale preferredLanguages] objectAtIndex:0]];
    
    if (localisedName)
    {
        return localisedName;
    }
    
    return _names[kDefaultLocale];
}

@end