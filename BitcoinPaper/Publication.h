//
//  Article.h
//  BitcoinPaper
//
//  Created by Joachim Neumann on 22/11/13.
//  Copyright (c) 2013 Joachim Neumann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Publication : NSObject {
@public
    NSString* title;
    NSString* subTitle;
    NSString* text;
    NSString* published;
    NSString* copyright;
    NSString* textHighlighted;
    NSString* searchTerm;
}

@property (nonatomic) NSInteger occurrences;

- (id)initWithJson: (NSDictionary*) json;
- (NSInteger) search: (NSString*) _searchTerm;
- (NSString*) title;
- (NSString*) subTitle;
- (NSString*) text;
- (NSString*) published;
- (NSString*) copyright;
- (NSAttributedString*) attributedSubTitle;
- (void) cancelSearch;
@end
