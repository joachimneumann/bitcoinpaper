//
//  DirectiveViewController.h
//  BitcoinPaper
//
//  Created by Joachim Neumann on 04/11/13.
//  Copyright (c) 2013 Joachim Neumann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentViewController.h"
#import "Model.h"

@interface PublicationsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate>


@property (weak, nonatomic) IBOutlet UITableView *publicationsTableView;
@property (strong, nonatomic) ContentViewController* c;
@property (weak, nonatomic) IBOutlet UISearchBar *directiveSearchBar;
@end
