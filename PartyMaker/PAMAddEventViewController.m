//
//  PAMAddEventViewController.m
//  PartyMaker
//
//  Created by Petrov Anton on 03.02.16.
//  Copyright © 2016 Softheme. All rights reserved.
//

#import "PAMAddEventViewController.h"

@interface PAMAddEventViewController ()

@property(strong,nonatomic) PAMAddEventViewController *createPartyView;

@property(strong, nonatomic) UIView *viewWihtDatePicker;
@property(strong, nonatomic) UIDatePicker *datePiker;
@property(strong, nonatomic) UIToolbar *toolbar;

@property(strong, nonatomic) UIButton *chooseButton;
@property(strong, nonatomic) UIButton *closeButton;
@property(strong, nonatomic) UIButton *saveButton;

@end

@implementation PAMAddEventViewController

#pragma mark - init

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

#pragma mark - UIToolbar

- (void) onCancelTolbar {
    self.chooseButton.userInteractionEnabled = YES;
    __block __weak PAMAddEventViewController *weakSelf = self;
    [UIView animateWithDuration:0.3
                     animations:^{
                         CGRect rect = weakSelf.viewWihtDatePicker.frame;
                         rect.origin.y += CGRectGetMaxY(weakSelf.viewWihtDatePicker.bounds);
                         weakSelf.viewWihtDatePicker.frame = rect;
                     }
                     completion:^(BOOL finished) {
                         if(finished) {
                             for (UIView *view in [weakSelf.viewWihtDatePicker subviews]){
                                 [view removeFromSuperview];
                                 NSLog(@"%@", view );
                             }
                             [weakSelf.viewWihtDatePicker removeFromSuperview];
                         }
                     }];
}

- (void) onDoneTolbar {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"MM.dd.yyyy"];
    [self.chooseButton setTitle: [dateFormatter stringFromDate:self.datePiker.date] forState:UIControlStateNormal];
    [self onCancelTolbar];
    NSLog(@"onCancelTolbar");
}

- (void) createToolbar {
     NSDictionary *attributesForItem = @{ NSFontAttributeName:[UIFont fontWithName:@"MyriadPro-Bold" size:15],
                                         NSForegroundColorAttributeName:[UIColor whiteColor]
                                         };
    
    UIToolbar* toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetMaxX(self.view.bounds), 50)];
    [toolbar setBarStyle:UIBarStyleBlack];
    [toolbar setBarTintColor:[UIColor colorWithRed:68/255.f green:73/255.f blue:83/255.f alpha:1]];
    UIBarButtonItem *itemCancel = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(onCancelTolbar)];
    
    UIBarButtonItem *itemDone = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                 style:UIBarButtonItemStyleDone
                                                                target:self
                                                                action:@selector(onDoneTolbar)];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                   target:nil
                                                                                   action:nil];
    [itemCancel setTitleTextAttributes:attributesForItem forState:UIControlStateNormal];
    [itemDone setTitleTextAttributes:attributesForItem forState:UIControlStateNormal];
    
    
    toolbar.items = @[itemCancel, flexibleSpace, itemDone];
    [toolbar sizeToFit];
    self.toolbar = toolbar;
    [self.viewWihtDatePicker addSubview:toolbar];
}

#pragma mark - UIDatePicker

- (void)onDateChanged:(UIDatePicker *) sender {
    
   
}

- (void)createViewWihtDatePicker {
    UIView *viewWihtDatePicker = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.view.bounds), CGRectGetMaxX(self.view.bounds), 200)];
    self.viewWihtDatePicker = viewWihtDatePicker;
    [self.createPartyView.view addSubview:viewWihtDatePicker];
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 44, CGRectGetMaxX(self.view.bounds), 156)];
    self.datePiker = datePicker;
    [datePicker addTarget:self
                   action:@selector(onDateChanged:)
         forControlEvents:UIControlEventValueChanged];
    [datePicker setMinimumDate:[NSDate date]];
    [datePicker setBackgroundColor:[UIColor whiteColor]];
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    [viewWihtDatePicker addSubview:datePicker];
    [self.createPartyView.view addSubview:viewWihtDatePicker];
    
    [self createToolbar];
}

#pragma mark - UIButton

-(void)onButtonClicked:(UIButton *) button {
    if([button isEqual:self.chooseButton]) {
        self.chooseButton.userInteractionEnabled = NO;
        [self createViewWihtDatePicker];
        __block __weak PAMAddEventViewController *weakSelf = self;
        [UIView animateWithDuration:0.3
                         animations:^{
                             CGRect rect = weakSelf.viewWihtDatePicker.frame;
                             rect.origin.y -= CGRectGetMaxY(weakSelf.viewWihtDatePicker.bounds);
                             weakSelf.viewWihtDatePicker.frame = rect;
                         }
                         completion:^(BOOL finished) {
                             
                         }];
    }
}

/*- (void)createButton {
    UIButton* chooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [chooseButton setFrame:CGRectMake(CGRectGetMaxX(self.createPartyView.view.bounds) - 200, 80, 190, 36)];
    [chooseButton.titleLabel setFont: [UIFont fontWithName:@"MyriadPro-Bold" size:16]];
    [chooseButton setTitle:@"CHOOSE DATE" forState:UIControlStateNormal];
    [chooseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [chooseButton setBackgroundColor:[UIColor colorWithRed:239/255.f green:177/255.f blue:27/255.f alpha:1]];
    [chooseButton.layer setCornerRadius:5];
    [chooseButton setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.3] forState:UIControlStateHighlighted];
    
    [chooseButton addTarget:self action:@selector(onButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.chooseButton = chooseButton;
    [self.createPartyView.view addSubview:chooseButton];
}*/

- (UIButton *)createButtonWithRect:(CGRect) rectButton title:(NSString *) title backgroundColor:(UIColor *) backgroundColor {
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:rectButton];
    [button.titleLabel setFont: [UIFont fontWithName:@"MyriadPro-Bold" size:16]];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundColor:backgroundColor];
    [button.layer setCornerRadius:5];
    [button setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.3] forState:UIControlStateHighlighted];
    
    [button addTarget:self action:@selector(onButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.createPartyView.view addSubview:button];
    return button;
}

#pragma mark - Other

-(void)createPartyViewController {
    PAMAddEventViewController *createPartyVC = [[PAMAddEventViewController alloc] init];
    createPartyVC.view = [[UIView alloc] initWithFrame:self.navigationController.view.frame];
    [createPartyVC.view setBackgroundColor:[UIColor colorWithRed:46/255.f green:49/255.f blue:56/255.f alpha:1]];
    createPartyVC.title = @"CREATE PARTY";
    self.createPartyView = createPartyVC;
    self.chooseButton = [self createButtonWithRect:CGRectMake(CGRectGetMaxX(self.createPartyView.view.bounds) - 200, 80, 190, 36)
                                             title:@"CHOOSE DATE"
                                   backgroundColor:[UIColor colorWithRed:239/255.f green:177/255.f blue:27/255.f alpha:1]];
    
    self.closeButton = [self createButtonWithRect:CGRectMake(CGRectGetMaxX(self.createPartyView.view.bounds) - 200, 130, 190, 36)
                                             title:@"CLOSE"
                                   backgroundColor:[UIColor colorWithRed:239/255.f green:177/255.f blue:27/255.f alpha:1]];

    
    self.saveButton = [self createButtonWithRect:CGRectMake(CGRectGetMaxX(self.createPartyView.view.bounds) - 200, 190, 190, 36)
                                             title:@"SAVE"
                                   backgroundColor:[UIColor colorWithRed:239/255.f green:177/255.f blue:27/255.f alpha:1]];
    
    [self.navigationController pushViewController:createPartyVC animated:YES];
}


@end
