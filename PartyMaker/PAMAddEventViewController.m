//
//  PAMAddEventViewController.m
//  PartyMaker
//
//  Created by Petrov Anton on 03.02.16.
//  Copyright © 2016 Softheme. All rights reserved.
//

#import "PAMAddEventViewController.h"

@interface PAMAddEventViewController ()

@end

@implementation PAMAddEventViewController

-(instancetype)init {
    self = [super init];
    if(!self) return nil;
    //[self.navigationItem setHidesBackButton:YES];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Hendles

- (void) handleAddViewController:(UIBarButtonItem *) sender {
    [self createPartyViewController];
}

#pragma mark - Other

-(void) createPartyViewController {
    PAMAddEventViewController *createPartyVC = [[PAMAddEventViewController alloc] init];
    createPartyVC.view = [[UIView alloc] initWithFrame:self.navigationController.view.frame];
    [createPartyVC.view setBackgroundColor:[UIColor colorWithRed:46/255.f green:49/255.f blue:56/255.f alpha:1]];
    createPartyVC.title = @"CREATE PARTY";
    [self.navigationController pushViewController:createPartyVC animated:YES];
}


@end
