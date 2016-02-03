//
//  PAMViewController.m
//  PartyMaker
//
//  Created by Petrov Anton on 03.02.16.
//  Copyright © 2016 Softheme. All rights reserved.
//

#import "PAMViewController.h"
#import "PAMAddEventViewController.h"

@interface PAMViewController ()

@end

@implementation PAMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}



-(void)viewDidAppear:(BOOL)animated {
    PAMAddEventViewController *addEventViewController = [[PAMAddEventViewController alloc] init];
    addEventViewController.view = [[UIView alloc] initWithFrame:self.view.frame];
    [addEventViewController.view setBackgroundColor:[UIColor colorWithRed:46/255.f green:49/255.f blue:56/255.f alpha:1]];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem: UIBarButtonSystemItemAdd
                                  target:addEventViewController
                                  action:@selector(handleAddViewController:)];
    
    addEventViewController.navigationItem.rightBarButtonItem = addButton;
    addEventViewController.title = @"PARTY MAKER";
    addEventViewController.navigationItem.titleView.backgroundColor = [UIColor redColor];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController: addEventViewController];
    
    [navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [navigationController.navigationBar setBackgroundColor:[UIColor blackColor]];
    [navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:68/255.f green:73/255.f blue:83/255.f alpha:1]];
    
    [self presentViewController:navigationController animated:NO completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
