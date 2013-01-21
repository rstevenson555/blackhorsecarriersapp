//
//  MyLocation.m
//  BlackHorseCarriersApp
//
//  Created by Robert Stevenson on 9/10/12.
//  Copyright (c) 2012 Robert Stevenson. All rights reserved.
//

#import "TerminalAnnotation.h"

@implementation TerminalAnnotation

- (id)initWithName:(NSString*)name address:(NSString*)_address coordinate:(CLLocationCoordinate2D)coordinate phone:(NSString*)phone manager:(NSString*)mgr title:(NSString*)ttl
    {
    if ((self = [super init])) {
        _name = [name copy];
        
        NSRange range = [_address rangeOfString:@"," options:NSLiteralSearch range:NSMakeRange(0, [_address length])];
        _street = [_address substringToIndex:range.location];
        
        NSString *secondpart = [_address substringFromIndex:range.location+1];
        
        range = [secondpart rangeOfString:@"," options:NSLiteralSearch range:NSMakeRange(0, [secondpart length])];
        
        _city = [[secondpart substringToIndex:range.location] copy];
        _state_zip = [secondpart substringFromIndex:range.location+1];
        _coordinate = coordinate;
        
        _phone = [phone copy];
        _managerTitle = [ttl copy];
        _managerName = [mgr copy];
        
    }
    return self;
}

/*
 this is the city label on the annotation 
 */
- (NSString *)title {
    if ([_name isKindOfClass:[NSNull class]])
        return @"Unknown charge";
    else
        return _name;
}

+ (NSString*)cityStateZip:(NSString *)inputStr
{
    //NSLog(@"original: '%@'",inputStr);
    NSRange range = [inputStr rangeOfString:@"," options:NSLiteralSearch range:NSMakeRange(0, [inputStr length])];
    //NSLog(@"range.location: %u", range.location);
    if ( range.length>0) {
        NSString *substring = [inputStr substringFromIndex:range.location+1];
        //NSLog(@"substring: '%@'", substring);
        return substring;
    }
    return inputStr;
}

/* this is the title on the annotation popup flag label */
- (NSString *)subtitle {
    //return _address;
    // return the city, state , zip
    //return [TerminalAnnotation cityStateZip:_city];
    NSString *result = @"";
    result = [result stringByAppendingString:_street];
    //result = [result stringByAppendingString:@", "];
    //result = [result stringByAppendingString:_phone];

    return result;
}

@end