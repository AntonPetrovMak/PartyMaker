//
//  PAMViewController.m
//  PartyMaker
//
//  Created by Petrov Anton on 03.02.16.
//  Copyright © 2016 Softheme. All rights reserved.
//

#import "PAMViewController.h"
#import "PAMAddEventViewController.h"
#import "PAMNewViewController.h"

@interface PAMViewController ()

@end

@implementation PAMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}



-(void)viewDidAppear:(BOOL)animated {
    PAMAddEventViewController *addEventViewController = [[PAMAddEventViewController alloc] init];
    [addEventViewController.view setBackgroundColor:[UIColor colorWithRed:46/255.f green:49/255.f blue:56/255.f alpha:1]];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem: UIBarButtonSystemItemAdd
                                  target:addEventViewController
                                  action:@selector(actionAddViewController:)];
    
    addEventViewController.navigationItem.rightBarButtonItem = addButton;
    addEventViewController.title = @"PARTY MAKER";
    addEventViewController.navigationItem.titleView.backgroundColor = [UIColor redColor];
    
    
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController: addEventViewController];
    
    NSDictionary *attributes1 = @{ NSFontAttributeName:[UIFont fontWithName:@"MyriadPro-Bold" size:15],
                                   NSForegroundColorAttributeName:[UIColor whiteColor]};
    [navigationController.navigationBar setTitleTextAttributes:attributes1];
    [navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:68/255.f green:73/255.f blue:83/255.f alpha:1]];
    [navigationController.toolbar setBackgroundColor:[UIColor colorWithRed:68/255.f green:73/255.f blue:83/255.f alpha:1]];
    
    
    [self presentViewController:navigationController animated:NO completion:nil];
    PAMNewViewController* newView = [[PAMNewViewController alloc] initWithNibName:@"PAMNewViewController" bundle:nil];
    [navigationController pushViewController:newView animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
