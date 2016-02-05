//
//  PAMAddEventViewController.m
//  PartyMaker
//
//  Created by Petrov Anton on 03.02.16.
//  Copyright © 2016 Softheme. All rights reserved.
//

#import "PAMAddEventViewController.h"

@interface PAMAddEventViewController () <UITextFieldDelegate, UIScrollViewDelegate, UITextViewDelegate>

//@property(strong,nonatomic) PAMAddEventViewController *createPartyView;

@property(weak, nonatomic) UIView *viewWihtDatePicker;
@property(strong, nonatomic) UIDatePicker *datePiker;
@property(strong, nonatomic) UIToolbar *toolbar;

@property(strong, nonatomic) UIButton *chooseButton;
@property(strong, nonatomic) UIButton *closeButton;
@property(strong, nonatomic) UIButton *saveButton;

@property(strong, nonatomic) UITextField *partyNameTextField;

@property(strong, nonatomic) UILabel *startTimeLabel;
@property(strong, nonatomic) UILabel *endTimeLabel;

@property(strong, nonatomic) UISlider *startSlider;
@property(strong, nonatomic) UISlider *endSlider;

@property(strong, nonatomic) UIScrollView* typeEventScrollView;
@property(strong, nonatomic) UIPageControl* typeEventPageControl;

@property(strong, nonatomic) UITextView *descriptionTextView;

@end

@implementation PAMAddEventViewController   

#pragma mark - init

-(void)keyboardWillShow:(NSNotification*)notification {
    CGRect keyboardRect = [[[notification userInfo] objectForKey: UIKeyboardFrameEndUserInfoKey] CGRectValue];
    float duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    __block __weak PAMAddEventViewController *weakSelf = self;
    [UIView animateWithDuration:duration
                     animations:^{
                         CGRect viewFrame = weakSelf.view.frame;
                         viewFrame.origin.y -= keyboardRect.size.height;
                         weakSelf.view.frame = viewFrame;
                     }];
}

-(void)keyboardWillHide:(NSNotification*)notification {
    float duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    __block __weak PAMAddEventViewController *weakSelf = self;
    [UIView animateWithDuration:duration
                     animations:^{
                         CGRect viewFrame = weakSelf.view.frame;
                         viewFrame.origin.y = 0;
                         weakSelf.view.frame = viewFrame;
                     }];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    /*[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];*/
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    /*[[NSNotificationCenter defaultCenter] removeObserver:self];*/
}

-(instancetype)init {
    self = [super init];
    if(!self) return nil;
    //[self.navigationItem setHidesBackButton:YES];
    return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)creatingPartyViewController {
    PAMAddEventViewController *createPartyVC = [[PAMAddEventViewController alloc] init];
    createPartyVC.view = [[UIView alloc] initWithFrame:self.navigationController.view.frame];
    [createPartyVC.view setBackgroundColor:[UIColor colorWithRed:46/255.f green:49/255.f blue:56/255.f alpha:1]];
    createPartyVC.title = @"CREATE PARTY";
    [createPartyVC creatingButtons];
    [createPartyVC creatingTextField];
    [createPartyVC creatingSlidersWithLabels];
    [createPartyVC creatingScrollView];
    [createPartyVC creatingTextView];

    [self.navigationController pushViewController:createPartyVC animated:YES];
}
#pragma mark - UITextView and UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    __block __weak PAMAddEventViewController *weakSelf = self;
    [UIView animateWithDuration:0.3
                     animations:^{
                         CGRect viewFrame = weakSelf.view.frame;
                         viewFrame.origin.y -= 250;
                         weakSelf.view.frame = viewFrame;
                     }];
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    __block __weak PAMAddEventViewController *weakSelf = self;
    [UIView animateWithDuration:0.2
                     animations:^{
                         CGRect viewFrame = weakSelf.view.frame;
                         viewFrame.origin.y = 0;
                         weakSelf.view.frame = viewFrame;
                     }];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSString *string = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if (string.length>100) return NO;
    return YES;
}

- (void)actionCancelTextView {
    [self.descriptionTextView resignFirstResponder];
}

-(void)actionDoneTextView {
    [self.descriptionTextView resignFirstResponder];
}

- (void) creatingTextView {
    UIView *viewLine = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.view.bounds) - 200, 360, 190, 5)];
    [viewLine setBackgroundColor:[UIColor colorWithRed:40/255.f green:132/255.f blue:175/255.f alpha:1]];
    [self.view addSubview:viewLine];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.view.bounds) - 200, 365, 190, 100)];
    [textView setFont:[UIFont fontWithName:@"MariadPro-Regular" size:18]];
    [textView setBackgroundColor:[UIColor colorWithRed:35/255.f green:37/255.f blue:43/255.f alpha:1]];
    [textView setTextColor:[UIColor whiteColor]];
    textView.delegate = self;
    
    UIToolbar* toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetMaxX(self.view.bounds), 50)];
    toolbar.barStyle = UIBarStyleBlackTranslucent;
    [toolbar setBackgroundColor:[UIColor colorWithRed:68/255.f green:73/255.f blue:83/255.f alpha:1]];
    UIBarButtonItem *itemCancel = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                   style:UIBarButtonItemStylePlain target:self action:@selector(actionCancelTextView)];
    UIBarButtonItem *itemDone = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                 style:UIBarButtonItemStyleDone target:self action:@selector(actionDoneTextView)];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                   target:nil action:nil];
    itemDone.tintColor = itemCancel.tintColor = [UIColor whiteColor];
    toolbar.items = @[itemCancel, flexibleSpace, itemDone];
    [toolbar sizeToFit];
    textView.inputAccessoryView = toolbar;
    
    
    self.descriptionTextView = textView;
    [self.view addSubview:textView];
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger currentPage = scrollView.contentOffset.x/scrollView.bounds.size.width;
    [self.typeEventPageControl setCurrentPage:currentPage];
}

-(void)actionPageChanged:(UIPageControl *) pageControl {
    CGPoint contentOffset = CGPointMake(pageControl.currentPage * self.typeEventScrollView.bounds.size.width, 0);
    [self.typeEventScrollView setContentOffset:contentOffset animated:YES];
}

-(void) creatingScrollView {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.view.bounds) - 200, 250, 190, 100)];
    self.typeEventScrollView = scrollView;
    scrollView.contentSize = CGSizeMake(190*6, 100);
    scrollView.pagingEnabled = YES;
    scrollView.layer.cornerRadius = 5;
    scrollView.backgroundColor = [UIColor colorWithRed:68/255.f green:73/255.f blue:83/255.f alpha:1];
    scrollView.delegate = self;
    for (int i = 0; i < 6; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"PartyLogo_Small_%d", i]];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(190*i, 0, 190, 80)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [imageView setImage:image];
        [scrollView addSubview:imageView];
    }
    [self.view addSubview:scrollView];
    
    
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(CGRectGetMinX(scrollView.frame),
                                                                                 CGRectGetMaxY(scrollView.frame) - 22,
                                                                                 CGRectGetMaxX(scrollView.bounds), 22)];
    pageControl.numberOfPages = 5;
    [pageControl addTarget:self
                    action:@selector(actionPageChanged:)
          forControlEvents:UIControlEventValueChanged];
    self.typeEventPageControl = pageControl;
    [self.view addSubview:pageControl];
}


#pragma mark - Hendles

- (void) handleAddViewController:(UIBarButtonItem *) sender {
    [self creatingPartyViewController];
}

#pragma mark - UIToolbar

- (void) actionCancelTolbar {
    self.chooseButton.userInteractionEnabled = YES;
    [UIView animateWithDuration:0.3
                     animations:^{
                         CGRect rect = self.viewWihtDatePicker.frame;
                         rect.origin.y += CGRectGetMaxY(self.viewWihtDatePicker.bounds);
                         self.viewWihtDatePicker.frame = rect;
                     }
                     completion:^(BOOL finished) {
                        [self.viewWihtDatePicker removeFromSuperview];
                     }];
}

- (void) actionDoneTolbar {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"MM.dd.yyyy"];
    [self.chooseButton setTitle: [dateFormatter stringFromDate:self.datePiker.date] forState:UIControlStateNormal];
    [self actionCancelTolbar];
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
    [self.view addSubview:viewWihtDatePicker];
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 44, CGRectGetMaxX(self.view.bounds), 156)];
    self.datePiker = datePicker;
    [datePicker addTarget:self
                   action:@selector(actionDateChanged:)
         forControlEvents:UIControlEventValueChanged];
    [datePicker setMinimumDate:[NSDate date]];
    [datePicker setBackgroundColor:[UIColor whiteColor]];
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    [viewWihtDatePicker addSubview:datePicker];
    [self.view addSubview:viewWihtDatePicker];
    
    [self creatingToolbar];
}

#pragma mark - UIButton

-(void)chooseButtonClicked {
    self.chooseButton.userInteractionEnabled = NO;
    [self creatingViewWihtDatePicker];
    [UIView animateWithDuration:0.3
                     animations:^{
                         CGRect rect = self.viewWihtDatePicker.frame;
                         rect.origin.y -= CGRectGetMaxY(self.viewWihtDatePicker.bounds);
                         self.viewWihtDatePicker.frame = rect;
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
    return button;
}

-(void) creatingButtons {
    self.chooseButton = [self newButtonWithRect:CGRectMake(CGRectGetMaxX(self.view.bounds) - 200, 80, 190, 36)
                                          title:@"CHOOSE DATE"
                                backgroundColor:[UIColor colorWithRed:239/255.f green:177/255.f blue:27/255.f alpha:1]];
    [self.view addSubview:self.chooseButton];
    
    self.saveButton = [self newButtonWithRect:CGRectMake(CGRectGetMaxX(self.view.bounds) - 200,
                                                         CGRectGetMaxY(self.view.bounds) - 90, 190, 36)
                                        title:@"SAVE"
                              backgroundColor:[UIColor colorWithRed:140/255.f green:186/255.f blue:29/255.f alpha:1]];
    [self.view addSubview:self.saveButton];
    self.closeButton = [self newButtonWithRect:CGRectMake(CGRectGetMaxX(self.view.bounds) - 200,
                                                          CGRectGetMaxY(self.view.bounds) - 46, 190, 36)
                                         title:@"CLOSE"
                               backgroundColor:[UIColor colorWithRed:236/255.f green:71/255.f blue:19/255.f alpha:1]];
    [self.view addSubview:self.closeButton];
}

#pragma mark - UITextFieldDelegate and UITextField

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

-(void)creatingTextField {
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.view.bounds) - 200, 126, 190, 36)];
    self.partyNameTextField = textField;
    [textField setPlaceholder:@"Your party name"];
    [textField setTextAlignment:NSTextAlignmentCenter];
    [textField setTextColor:[UIColor whiteColor]];
    [textField setFont:[UIFont fontWithName:@"MariadPro-Regular" size:16]];
    [textField setBackgroundColor: [UIColor colorWithRed:35/255.f green:37/255.f blue:43/255.f alpha:1]];
    [textField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [textField setReturnKeyType:UIReturnKeyDone];
    [textField.layer setCornerRadius:5];
    textField.delegate = self;
    NSDictionary *attributedDictionary = @{ NSForegroundColorAttributeName: [UIColor colorWithRed:76/255. green:82/255. blue:92/255. alpha:1]};
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"Your party Name"
                                                                           attributes:attributedDictionary];
    [textField setAttributedPlaceholder:attributedString];
    [self.view addSubview:textField];
}

#pragma mark - UISlider and UILable

-(NSString *) getCustomTimeWithIntervale:(int) interval {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat:@"HH:mm"];
    return [formatter stringFromDate:[NSDate dateWithTimeIntervalSinceReferenceDate:interval * 60]];
}

-(void)actionSlideChanged:(UISlider *) slider {
    if([slider isEqual:self.startSlider]) {
        if(self.endSlider.value - slider.value <= 0) {
            self.endSlider.value = slider.value;
            self.startTimeLabel.text = [self getCustomTimeWithIntervale:(int)slider.value];
            self.endTimeLabel.text = [self getCustomTimeWithIntervale:(int)slider.value + 30];
        }
        self.startTimeLabel.text = [self getCustomTimeWithIntervale:(int)slider.value];
    } else if([slider isEqual:self.endSlider]) {
        if(self.startSlider.value - slider.value > 0) {
            self.startSlider.value = slider.value;
            self.endTimeLabel.text = [self getCustomTimeWithIntervale:(int)slider.value];
            self.startTimeLabel.text = [self getCustomTimeWithIntervale:(int)slider.value - 30];
        }
        self.endTimeLabel.text = [self getCustomTimeWithIntervale:(int)slider.value];
    }
}

-(UILabel *)newLabelForSliderWithRect:(CGRect) rect test:(NSString *) text {
    UILabel *label = [[UILabel alloc] initWithFrame: rect];

    [label setText:text];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setTextColor:[UIColor whiteColor]];
    [label setFont:[UIFont fontWithName:@"MyriadPro-Regular" size:12]];
    return label;
}

-(UISlider *)newCustomSliderWithRect:(CGRect) rectSlider {
    UISlider *slider = [[UISlider alloc] initWithFrame:rectSlider];
    slider.minimumTrackTintColor = [UIColor colorWithRed:239/255.f green:177/255.f blue:27/255.f alpha:1];
    slider.maximumTrackTintColor = [UIColor colorWithRed:35/255.f green:37/255.f blue:43/255.f alpha:1];
    slider.tintColor = [UIColor blackColor];
    slider.value = 0;
    [slider addTarget:self action:@selector(actionSlideChanged:) forControlEvents:UIControlEventValueChanged];
    return slider;
}

-(void)creatingSlidersWithLabels {
    self.startSlider = [self newCustomSliderWithRect:CGRectMake(CGRectGetMaxX(self.view.bounds) - 200, 170, 190, 30)];
    [self.view addSubview:self.startSlider];
    [self.startSlider setMinimumValueImage: [UIImage imageNamed:@"TimePopup"]];
    [self.startSlider setMinimumValue:0];
    [self.startSlider setMaximumValue:24*60 - 31];
    
    self.startTimeLabel = [self newLabelForSliderWithRect:CGRectMake(CGRectGetMinX(self.startSlider.frame),CGRectGetMinY(self.startSlider.frame),31, 30)
                                                     test:@"00:00"];
    [self.view addSubview:self.startTimeLabel];
    
    self.endSlider = [self newCustomSliderWithRect:CGRectMake(CGRectGetMaxX(self.view.bounds) - 200, 210, 190, 30)];
    [self.view addSubview:self.endSlider];
    [self.endSlider setMaximumValueImage: [UIImage imageNamed:@"TimePopup180"]];
    [self.endSlider setMinimumValue:30];
    [self.endSlider setMaximumValue:24*60-1];
    
    self.endTimeLabel = [self newLabelForSliderWithRect:CGRectMake(CGRectGetMaxX(self.endSlider.frame) - 31,CGRectGetMinY(self.endSlider.frame),30, 30)
                                                     test:@"00:30"];
    [self.view addSubview:self.endTimeLabel];
}

#pragma mark - Other

@end
