//
//  PAMAddEventViewController.m
//  PartyMaker
//
//  Created by Petrov Anton on 03.02.16.
//  Copyright © 2016 Softheme. All rights reserved.
//

#import "PAMAddEventViewController.h"

@interface PAMAddEventViewController () <UITextFieldDelegate>

@property(strong,nonatomic) PAMAddEventViewController *createPartyView;

@property(strong, nonatomic) UIView *viewWihtDatePicker;
@property(strong, nonatomic) UIDatePicker *datePiker;
@property(strong, nonatomic) UIToolbar *toolbar;

@property(strong, nonatomic) UIButton *chooseButton;
@property(strong, nonatomic) UIButton *closeButton;
@property(strong, nonatomic) UIButton *saveButton;

@property(strong, nonatomic) UITextField *partyNameTextField;

@property(strong, nonatomic) UILabel *startTimeLabel;
@property(strong, nonatomic) UILabel *endTimeLabel;

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
    [self creatingPartyViewController];
}

#pragma mark - UIToolbar

- (void) actionCancelTolbar {
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
                             }
                             [weakSelf.viewWihtDatePicker removeFromSuperview];
                         }
                     }];
}

- (void) actionDoneTolbar {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"MM.dd.yyyy"];
    [self.chooseButton setTitle: [dateFormatter stringFromDate:self.datePiker.date] forState:UIControlStateNormal];
    [self actionCancelTolbar];
    NSLog(@"onCancelTolbar");
}

- (void) creatingToolbar {
     NSDictionary *attributesForItem = @{ NSFontAttributeName:[UIFont fontWithName:@"MyriadPro-Bold" size:15],
                                         NSForegroundColorAttributeName:[UIColor whiteColor]
                                         };
    
    UIToolbar* toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetMaxX(self.view.bounds), 50)];
    [toolbar setBarStyle:UIBarStyleBlack];
    [toolbar setBarTintColor:[UIColor colorWithRed:68/255.f green:73/255.f blue:83/255.f alpha:1]];
    UIBarButtonItem *itemCancel = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(actionCancelTolbar)];
    
    UIBarButtonItem *itemDone = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                 style:UIBarButtonItemStyleDone
                                                                target:self
                                                                action:@selector(actionDoneTolbar)];
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

- (void)actionDateChanged:(UIDatePicker *) sender {
    
   
}

- (void)creatingViewWihtDatePicker {
    UIView *viewWihtDatePicker = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.view.bounds), CGRectGetMaxX(self.view.bounds), 200)];
    self.viewWihtDatePicker = viewWihtDatePicker;
    [self.createPartyView.view addSubview:viewWihtDatePicker];
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 44, CGRectGetMaxX(self.view.bounds), 156)];
    self.datePiker = datePicker;
    [datePicker addTarget:self
                   action:@selector(actionDateChanged:)
         forControlEvents:UIControlEventValueChanged];
    [datePicker setMinimumDate:[NSDate date]];
    [datePicker setBackgroundColor:[UIColor whiteColor]];
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    [viewWihtDatePicker addSubview:datePicker];
    [self.createPartyView.view addSubview:viewWihtDatePicker];
    
    [self creatingToolbar];
}

#pragma mark - UIButton

-(void) chooseButtonClicked {
    self.chooseButton.userInteractionEnabled = NO;
    [self creatingViewWihtDatePicker];
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

-(void)actionButtonClicked:(UIButton *) button {
    if([button isEqual:self.chooseButton]) {
        [self chooseButtonClicked];
    }
}

-(UIButton *)newButtonWithRect:(CGRect) rectButton title:(NSString *) title backgroundColor:(UIColor *) backgroundColor {
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:rectButton];
    [button.titleLabel setFont: [UIFont fontWithName:@"MyriadPro-Bold" size:16]];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundColor:backgroundColor];
    [button.layer setCornerRadius:5];
    [button setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.3] forState:UIControlStateHighlighted];
    
    [button addTarget:self action:@selector(actionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.createPartyView.view addSubview:button];
    return button;
}

-(void) creatingButtons {
    self.chooseButton = [self newButtonWithRect:CGRectMake(CGRectGetMaxX(self.createPartyView.view.bounds) - 200, 80, 190, 36)
                                          title:@"CHOOSE DATE"
                                backgroundColor:[UIColor colorWithRed:239/255.f green:177/255.f blue:27/255.f alpha:1]];
    
    self.saveButton = [self newButtonWithRect:CGRectMake(CGRectGetMaxX(self.createPartyView.view.bounds) - 200,
                                                         CGRectGetMaxY(self.createPartyView.view.bounds) - 90, 190, 36)
                                        title:@"SAVE"
                              backgroundColor:[UIColor lightGrayColor]];
    
    self.closeButton = [self newButtonWithRect:CGRectMake(CGRectGetMaxX(self.createPartyView.view.bounds) - 200,
                                                          CGRectGetMaxY(self.createPartyView.view.bounds) - 46, 190, 36)
                                         title:@"CLOSE"
                               backgroundColor:[UIColor lightGrayColor]];
}

#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (void) creatingTextField {
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.createPartyView.view.bounds) - 200, 126, 190, 36)];
    self.partyNameTextField = textField;
    [textField setPlaceholder:@"Your party name"];
    [textField setTextAlignment:NSTextAlignmentCenter];
    [textField setTextColor:[UIColor whiteColor]];
    [textField setFont:[UIFont fontWithName:@"MariadPro-Regular" size:20]];
    [textField setBackgroundColor: [UIColor grayColor]];
    [textField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [textField setReturnKeyType:UIReturnKeyDone];
    [textField.layer setCornerRadius:5];
    textField.delegate = self.createPartyView;
    [self.view addSubview:textField];
    [self.createPartyView.view addSubview:textField];
}

#pragma mark - UISlider

-(void)actionSlideChanged:(UISlider *) slider {
    self.startTimeLabel.text = [NSString stringWithFormat:@"%d", (int)slider.value];
}

-(void) creatingSliders {
    UISlider *startSlider = [[UISlider alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.createPartyView.view.bounds) - 200, 170, 190, 30)];
    [startSlider setMinimumValueImage: [UIImage imageNamed:@"TimePopup"]];
    startSlider.minimumTrackTintColor = [UIColor orangeColor];
    startSlider.maximumTrackTintColor = [UIColor blackColor];
    startSlider.thumbTintColor = [UIColor whiteColor];
    startSlider.tintColor = [UIColor blackColor];
    startSlider.value = 0;
    startSlider.minimumValue = 0;
    startSlider.maximumValue = 24*60 - 30;
    [startSlider addTarget:self action:@selector(actionSlideChanged:) forControlEvents:UIControlEventValueChanged];
    
    UILabel *startTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,100, 70, 30)];
    startTimeLabel.backgroundColor = [UIColor whiteColor];
    startTimeLabel.text = @"0";
    self.startTimeLabel = startTimeLabel;
    [self.createPartyView.view addSubview:startTimeLabel];
    [self.createPartyView.view addSubview:startSlider];
    //[slider setMaximumValueImage: [UIImage imageNamed:@"TimePopup180"]];
}

#pragma mark - Other

-(void)creatingPartyViewController {
    PAMAddEventViewController *createPartyVC = [[PAMAddEventViewController alloc] init];
    createPartyVC.view = [[UIView alloc] initWithFrame:self.navigationController.view.frame];
    [createPartyVC.view setBackgroundColor:[UIColor colorWithRed:46/255.f green:49/255.f blue:56/255.f alpha:1]];
    createPartyVC.title = @"CREATE PARTY";
    self.createPartyView = createPartyVC;
    [self creatingButtons];
    [self creatingTextField];
    [self creatingSliders];
    
    [self.navigationController pushViewController:createPartyVC animated:YES];
}


@end
