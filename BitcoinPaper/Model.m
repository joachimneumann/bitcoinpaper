//
//  Model.m
//  BitcoinPaper
//
//  Created by Joachim Neumann on 22/11/13.
//  Copyright (c) 2013 Joachim Neumann. All rights reserved.
//

#import "Model.h"

@implementation Model
@synthesize totalOccurances;
@synthesize searchResultText;
@synthesize searchTerm;
@synthesize publications;

+(Model*) instance {
    static Model *sharedSingleton = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSingleton = [[Model alloc] init];
    });
    return sharedSingleton;
}

- (id)init {
    self = [super init];
    if (self) {
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Model" ofType:@"json"];
        if (!path) {
            NSLog(@"Model.json not found");
        }
        NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        NSString *content2 = [content stringByReplacingOccurrencesOfString: @"\\\n" withString:@""];
        NSString *content3 = [content2 stringByReplacingOccurrencesOfString: @"\n" withString:@""];
        NSData *data = [content3 dataUsingEncoding:NSUTF8StringEncoding];
        NSError * error = nil;
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if (!json) {
            NSLog(@"json parsing error %@, %@", error, [error userInfo]);
        }
        
        publications = [[NSMutableArray alloc] init];
        NSDictionary * json_all_publications = [json objectForKey:@"publications"];
        // Parse and loop through the JSON
        for (NSDictionary * json_publication in json_all_publications) {
            Publication *p = [[Publication alloc] initWithJson:json_publication];
            [publications addObject:p];
//            NSLog(@"new publication:\n %@", p);
        }
    }
    return self;
}


- (void) search: (NSString*) _searchTerm {
    searchResultText = @"";
    searchTerm = [_searchTerm stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    BOOL allowedSearch = YES;
    if([searchTerm rangeOfString:@"<"].location != NSNotFound) allowedSearch = NO;
    if([searchTerm rangeOfString:@">"].location != NSNotFound) allowedSearch = NO;
    if ([searchTerm caseInsensitiveCompare:@"type"] == NSOrderedSame) allowedSearch = NO;
    if ([searchTerm caseInsensitiveCompare:@"li"] == NSOrderedSame) allowedSearch = NO;
    if ([searchTerm caseInsensitiveCompare:@"dl"] == NSOrderedSame) allowedSearch = NO;
    if ([searchTerm caseInsensitiveCompare:@"dd"] == NSOrderedSame) allowedSearch = NO;
    if (!allowedSearch) {
        searchResultText = [NSString stringWithFormat:@"Search term \"%@\" is not allowed", searchTerm];
    }
    if([searchTerm length] <= 2) {
        searchResultText = [NSString stringWithFormat:@"Search term \"%@\" too short", searchTerm];
        allowedSearch = NO;
    }
    if (allowedSearch) {
        for (Publication* p in publications) {
            NSInteger temp = [p search: searchTerm];
            totalOccurances += temp;
        }
        if (totalOccurances == 1) {
            searchResultText = [NSString stringWithFormat:@"%li result in all publications", (long)totalOccurances];
        } else {
            searchResultText = [NSString stringWithFormat:@"%li results in all publications", (long)totalOccurances];
        }
    } else {
        totalOccurances = 0;
        [self cancelSearch];
    }
}

- (void) cancelSearch {
    totalOccurances = 0;
    for (Publication* p in publications) {
        [p cancelSearch];
    }
}

@end
