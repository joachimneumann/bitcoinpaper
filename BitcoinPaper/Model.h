//
//  Model.h
//  BitcoinPaper
//
//  Created by Joachim Neumann on 22/11/13.
//  Copyright (c) 2013 Joachim Neumann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Publication.h"

@interface Model : NSObject {
}

@property (strong, nonatomic) NSMutableArray *publications;
@property (nonatomic) NSInteger totalOccurances;
@property (nonatomic) NSString* searchResultText;
@property (nonatomic) NSString* searchTerm;

+ (Model*) instance;
- (void) search: (NSString*) searchTerm;
- (void) cancelSearch;

@end
