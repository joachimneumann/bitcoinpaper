//
//  Article.m
//  BitcoinPaper
//
//  Created by Joachim Neumann on 22/11/13.
//  Copyright (c) 2013 Joachim Neumann. All rights reserved.
//

#import "Publication.h"

@implementation Publication
@synthesize occurrences;


- (id)initWithJson: (NSDictionary*) json {
    self = [super init];
    if (self) {
        title = [json objectForKey:@"title"];
        subTitle = [json objectForKey:@"subTitle"];
        text = [json objectForKey:@"text"];
        published = [json objectForKey:@"published"];
        textHighlighted = [json objectForKey:@"text"];
        copyright = [json objectForKey:@"copyright"];
        occurrences = 0;
    }
    return self;
}

- (NSInteger) search: (NSString*) _searchTerm {
    NSError *error = NULL;
    searchTerm = _searchTerm;
    NSString *original = @"NumberXXXXXX";

    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern: searchTerm options:NSRegularExpressionCaseInsensitive error:&error];
    NSUInteger matchesInText = [regex numberOfMatchesInString: text options:0 range:NSMakeRange(0, [text length])];
    if (matchesInText > 0) {
        textHighlighted = [regex stringByReplacingMatchesInString: text
                                                      options:0
                                                        range:NSMakeRange(0, [text length])
                                                 withTemplate: [NSString stringWithFormat:@"<a id='searchResult%@'></a><span style='background-color:yellow'>$0</span>", original]];
    } else {
        textHighlighted = text;
    }
    occurrences = matchesInText;
    
    long int length = textHighlighted.length;
    long int lastPostion = 0;
    for (int i = 0; i < occurrences; i++) {
        NSString *replacement = [NSString stringWithFormat:@"Number%06i", i+1];
        NSRange rOriginal = [textHighlighted rangeOfString: original options:NSCaseInsensitiveSearch range: NSMakeRange(lastPostion, length-lastPostion)];
        if (NSNotFound != rOriginal.location) {
            lastPostion = rOriginal.location;
            textHighlighted = [textHighlighted
                        stringByReplacingCharactersInRange: rOriginal
                        withString:                         replacement];
        }
    }
    return occurrences;
}

- (NSString*) title {
    return title;
}

- (NSString*) subTitle {
    return subTitle;
}
- (NSString*) text {
    return textHighlighted;
}
- (NSString*) published {
    return published;
}
- (NSString*) copyright {
    return copyright;
}

- (NSAttributedString*) attributedSubTitle {
    NSMutableAttributedString *textLabelStr;
    if (occurrences > 0) {
        NSString* firstString = [NSString stringWithFormat:@"%@   ", subTitle];
        NSString* secondString;
        if (occurrences == 1) secondString = [NSString stringWithFormat:@"%li result", (long)occurrences];
        if (occurrences > 1) secondString = [NSString stringWithFormat:@"%li results", (long)occurrences];

        textLabelStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@", firstString, secondString]];
        [textLabelStr setAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Italic" size:16]} range:NSMakeRange([firstString length]+1, [secondString length])];
    } else {
        textLabelStr = [[NSMutableAttributedString alloc] initWithString: subTitle];
    }
    return textLabelStr;
}

- (void) cancelSearch {
    occurrences = 0;
    textHighlighted = text;
}

@end
