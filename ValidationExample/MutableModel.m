//
//  Model.m
//  ValidationExample
//
//  Created by Dan Zinngrabe on 7/24/14.
//  Copyright (c) 2014 Dan Zinngrabe. All rights reserved.
//

#import "MutableModel.h"

// CoreData defines the individual validation error codes, we are just borrowing them.
// In a production application you would define your error codes and error domain, with error code values between
// NSValidationErrorMinimum and NSValidationErrorMaximum

#import <CoreData/CoreData.h>

@implementation MutableModel
@synthesize name;

/**
 *  Key-Value Coding validation method for the property "name"
 *
 *  @param ioValue  The value to validate
 *  @param ioError The error describing a validation failure.
 *
 *  @return YES if the input passed validation.
 */

-(BOOL)validateName:(inout id __autoreleasing *)ioValue error:(inout NSError * __autoreleasing *)ioError {
    BOOL    result  			= YES;
	NSError	*validationError	= nil;
    
    // Do not proceed unless both pointers are not NULL.
	if ((ioValue != NULL) && (ioError != NULL)){
		validationError = [*ioError copy];
        // Test wether the input is valid
	    if (![(NSString *)*ioValue isEqualToString:@"John"]){
            // It's not valid, build an error describing the probelm and set the result to NO
	        validationError = [self nameIsNotJohnError:*ioValue];
	        result = NO;
	    }
        
        // Under ARC, setting the autoreleasing outError to the strong validationError prevents
        // a possible crash if an enclosing autorelease pool has been drained while we are inside this method.
		if (result != YES){
	        *ioError = validationError;
		}
    }
	
    return result;
}

/**
 *  Method for constructing an error describing the validation error
 *
 *  @param value The failing validation value
 *
 *  @return Error describing why the value failed validation
 */

- (NSError * __autoreleasing)nameIsNotJohnError:(id)value {
    NSError             *result		= nil;
	NSMutableDictionary	*userInfo	= nil;
	
    userInfo = [[NSMutableDictionary alloc] init];
    [userInfo setValue:NSLocalizedString(@"Name must be John", @"Name must be John") forKey:NSLocalizedDescriptionKey];
    [userInfo setValue:self forKey:NSValidationObjectErrorKey];
    [userInfo setValue:@"firstName" forKey:NSValidationKeyErrorKey];
    [userInfo setValue:value forKey:NSValidationValueErrorKey];
    
	result = [[NSError alloc] initWithDomain:NSCocoaErrorDomain code:NSValidationStringTooShortError userInfo:[userInfo copy]];
	return result;
}

#pragma mark NSCopying

- (id) copyWithZone:(NSZone *)zone {
    id result   = nil;
    
    result = [[[self class] alloc] init];
    if (result != nil){
        [result setName:[self name]];
    }
    return result;
}

@end
