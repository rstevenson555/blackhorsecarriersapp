//
//  MyLocation.m
//  BlackHorseCarriersApp
//
//  Created by Robert Stevenson on 9/10/12.
//  Copyright (c) 2012 Robert Stevenson. All rights reserved.
//

#import "TerminalAnnotation.h"

@implementation TerminalAnnotation
@synthesize name, street, city, state_zip, phone, managerName, managerTitle, coordinate;

- (id)initWithName:(NSString*)tname address:(NSString*)taddress coordinate:(CLLocationCoordinate2D)tcoordinate phone:(NSString*)tphone manager:(NSString*)tmgr title:(NSString*)ttl
{
    if ((self = [super init])) {
        name = [tname copy];
        
        NSRange range = [taddress rangeOfString:@"," options:NSLiteralSearch range:NSMakeRange(0, [taddress length])];
        street = [[taddress substringToIndex:range.location] copy];
        
        NSString *secondpart = [taddress substringFromIndex:range.location+1];
        
        range = [secondpart rangeOfString:@"," options:NSLiteralSearch range:NSMakeRange(0, [secondpart length])];
        
        city = [[secondpart substringToIndex:range.location] copy];
        state_zip = [[secondpart substringFromIndex:range.location+1] copy];
        coordinate = tcoordinate;
        
        phone = [tphone copy];
        managerTitle = [ttl copy];
        managerName = [tmgr copy];
        
    }
    return self;
}

/*
 this is the city label on the annotation
 */
- (NSString *)title {
    if ([name isKindOfClass:[NSNull class]])
        return @"Unknown charge";
    else
        return name;
}

+ (NSString*)cityStateZip:(NSString *)inputStr
{
    NSRange range = [inputStr rangeOfString:@"," options:NSLiteralSearch range:NSMakeRange(0, [inputStr length])];
    if ( range.length>0) {
        NSString *substring = [inputStr substringFromIndex:range.location+1];
        return substring;
    }
    return inputStr;
}

/* this is the title on the annotation popup flag label */
- (NSString *)subtitle {
    NSString *result = @"";
    result = [result stringByAppendingString:street];
    return result;
}

@end