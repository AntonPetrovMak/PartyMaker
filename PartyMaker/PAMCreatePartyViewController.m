//
//  PAMCreatePartyViewController.m
//  PartyMaker
//
//  Created by Petrov Anton on 18.02.16.
//  Copyright © 2016 Softheme. All rights reserved.
//

#import "PAMCreatePartyViewController.h"

@interface PAMCreatePartyViewController ()

@end

@implementation PAMCreatePartyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"CREATE PARTY";
    //[self.navigationItem setHidesBackButton:YES];
    [self creatingTextField];
    [self creatingTextView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    CGRect rect = self.typeEventScrollView.frame;
    rect.size.height = ([UIScreen mainScreen].bounds.size.height - 369)/2;
    rect.size.width = [UIScreen mainScreen].bounds.size.width - 128;
    self.typeEventScrollView.frame = rect;
    [self creatingScrollView];
    
    
    self.party = [[PAMParty alloc] init];
    if(self.partyCore) {
        [self enterDataForEdit];
    }
}

- (void)enterDataForEdit {
    self.partyDate = [NSDate dateWithTimeIntervalSince1970:self.partyCore.startDate];
     [self.chooseButton setTitle: [NSString stringPrityDateWithDate:[NSDate dateWithTimeIntervalSince1970:self.partyCore.startDate]]
                        forState: UIControlStateNormal];
     self.partyNameTextField.text = self.partyCore.name;
     
     self.startSlider.value = [self countMinutesInDay:[NSDate dateWithTimeIntervalSince1970:self.partyCore.startDate]];
     self.startTimeLabel.text = [NSString stringHourAndMinutesWithDate:[NSDate dateWithTimeIntervalSince1970:self.partyCore.startDate]];
     
     self.endSlider.value = [self countMinutesInDay:[NSDate dateWithTimeIntervalSince1970:self.partyCore.endDate]];
     self.endTimeLabel.text = [NSString stringHourAndMinutesWithDate:[NSDate dateWithTimeIntervalSince1970:self.partyCore.endDate]];
     
     CGPoint contentOffset = CGPointMake(self.partyCore.partyType * self.typeEventScrollView.bounds.size.width, 0);
     [self.typeEventScrollView setContentOffset:contentOffset animated:NO];
     self.typeEventPageControl.currentPage = self.partyCore.partyType;
     self.partyDescription.text = self.partyCore.partyDescription;
}

#pragma mark - Helpers

- (NSInteger) countMinutesInDay:(NSDate *) date {
    NSCalendar *calendar =[NSCalendar currentCalendar];
    NSDateComponents *startComponents = [calendar components:NSCalendarUnitHour | NSCalendarUnitMinute
                                                    fromDate:[date dateByAddingTimeInterval:-7200]];
    NSInteger interval = (startComponents.hour * 60) + startComponents.minute;
    return interval;
}

- (void)blockControllersBesides:(id) controller userInteractionEnabled:(BOOL) isBlock {
    for (UIView *view in self.view.subviews) {
        if(![view isEqual:controller]){
            view.userInteractionEnabled = isBlock;
        }
    }
}

#pragma mark - Creating controllers
- (void)creatingTextField {
    [self.partyNameTextField setFont:[UIFont fontWithName:@"MariadPro-Regular" size:16]];
    NSDictionary *attributedDictionary = @{ NSForegroundColorAttributeName: [UIColor colorWithRed:76/255. green:82/255. blue:92/255. alpha:1]};
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"Your party Name"
                                                                           attributes:attributedDictionary];
    [self.partyNameTextField setAttributedPlaceholder:attributedString];
}

- (void)creatingScrollView {
    [self.typeEventScrollView setContentSize:CGSizeMake(CGRectGetMaxX(self.typeEventScrollView.bounds)*6, CGRectGetMaxY(self.typeEventScrollView.bounds))];
    for (int i = 0; i < 6; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"PartyLogo_Small_%d", i]];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.typeEventScrollView.bounds)*i, 5,
                                                                               CGRectGetMaxX(self.typeEventScrollView.bounds), CGRectGetMaxY(self.typeEventScrollView.bounds)-27)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [imageView setImage:image];
        [self.typeEventScrollView addSubview:imageView];
    }
}

- (void)creatingTextView {
    UIToolbar* toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetMaxX(self.view.bounds), 50)];
    [toolbar setBarStyle:UIBarStyleBlack];
    [toolbar setBarTintColor:[UIColor colorWithRed:68/255.f green:73/255.f blue:83/255.f alpha:1]];
    
    UIBarButtonItem *itemCancel = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(actionCancelDescription:)];
    UIBarButtonItem *itemDone = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                 style:UIBarButtonItemStyleDone
                                                                target:self
                                                                action:@selector(actionDoneDescription:)];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                   target:nil
                                                                                   action:nil];
    itemDone.tintColor = itemCancel.tintColor = [UIColor whiteColor];
    toolbar.items = @[itemCancel, flexibleSpace, itemDone];
    [toolbar sizeToFit];
    self.partyDescription.inputAccessoryView = toolbar;
}

#pragma mark - Action

- (IBAction)actionMoveCursor:(UIView *) sender {
    if([[sender class] isEqual:[UISlider class]]) {
        self.cursorTopConstraint.constant = sender.center.y - 0.5;
    } else {
        self.cursorTopConstraint.constant = sender.center.y;
    }
    __weak PAMCreatePartyViewController* weakSelf = self;
    [UIView animateWithDuration:0.3
                     animations:^{
                         [weakSelf.view layoutIfNeeded];
                     }];
}

- (IBAction)actionChooseButton:(UIButton *)sender {
    [self blockControllersBesides:nil userInteractionEnabled:NO];
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([PAMCustomDatePiker class]) owner:nil options:nil];
    PAMCustomDatePiker *datePikerView = nibContents[0];
    [datePikerView.datePiker setMinimumDate:[NSDate date]];
    datePikerView.delegate = self;
    datePikerView.frame = CGRectMake(0, self.view.frame.size.height,
                                     self.view.bounds.size.width, datePikerView.bounds.size.height);
    [UIView animateWithDuration:0.3
                     animations:^{
                         CGRect rect = datePikerView.frame;
                         rect.origin.y -= CGRectGetMaxY(datePikerView.bounds);
                         datePikerView.frame = rect;
                     }];
    
    [self.view addSubview:datePikerView];
}

- (IBAction)actionSaveButton:(id)sender {
    if(!self.partyDate) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error!"
                                                                       message:@"You should enter a party date!"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *actionOK = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                         handler: ^(UIAlertAction* action) {
                                                             //[weakSelf actionChooseButton:sender];
                                                         }];
        [alert addAction:actionOK];
        [self presentViewController:alert animated:YES completion:nil];
    }else if(!self.partyNameTextField.text.length) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error!"
                                                                       message:@"You should enter a party name!"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *actionOK = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                         handler: ^(UIAlertAction* action) {
                                                             //[weakSelf.partyNameTextField becomeFirstResponder];
                                                         }];
        [alert addAction:actionOK];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        NSCalendar *calendar =[NSCalendar currentCalendar];
        
        NSDateComponents *components = [calendar components:NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond
                                                   fromDate:self.partyDate];
        
        NSInteger intervale = ((components.hour-2) * 60 * 60) + (components.minute * 60) + components.second;
        
        NSDate *partyDate = [self.partyDate dateByAddingTimeInterval:-intervale];
        self.party.partyId = arc4random_uniform(1000000);
        self.party.partyName = self.partyNameTextField.text;
        self.party.partyDescription = self.partyDescription.text;
        self.party.partyStartDate = [[partyDate dateByAddingTimeInterval:self.startSlider.value * 60] timeIntervalSince1970];
        self.party.partyEndDate = [[partyDate dateByAddingTimeInterval:self.endSlider.value * 60] timeIntervalSince1970];
        self.party.partyType = self.typeEventPageControl.currentPage;
        
        __weak PAMCreatePartyViewController *weakSelf = self;
        if(self.partyCore) {
            NSManagedObjectID *objectID = [self.partyCore.objectID copy];
            [[PAMDataStore standartDataStore] performWriteOperation:^(NSManagedObjectContext *context) {
                NSError *error = nil;
                PAMPartyCore *partyCore = [context existingObjectWithID:objectID error:&error];
                NSLog(@"%s, error happened - %@", __PRETTY_FUNCTION__, error);
                partyCore.name = weakSelf.party.partyName;
                partyCore.partyDescription = weakSelf.party.partyDescription;
                partyCore.partyId = weakSelf.party.partyId;
                partyCore.partyType = weakSelf.party.partyType;
                partyCore.startDate = weakSelf.party.partyStartDate;
                partyCore.endDate = weakSelf.party.partyEndDate;
            } completion:^{
                NSLog(@"completion edit");
            }];
        } else {
            [[PAMDataStore standartDataStore] performWriteOperation:^(NSManagedObjectContext *context) {
                PAMPartyCore *partyCore = [NSEntityDescription insertNewObjectForEntityForName:@"PAMPartyCore" inManagedObjectContext:context];
                partyCore.name = weakSelf.party.partyName;
                partyCore.partyDescription = weakSelf.party.partyDescription;
                partyCore.partyId = weakSelf.party.partyId;
                partyCore.partyType = weakSelf.party.partyType;
                partyCore.startDate = weakSelf.party.partyStartDate;
                partyCore.endDate = weakSelf.party.partyEndDate;
            } completion:^{
                NSLog(@"completion write");
            }];
        }
        [self actionCloseButton:sender];
    }
}

- (IBAction)actionCloseButton:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)actionSlideChanged:(UISlider *)sender {
    if([sender isEqual:self.startSlider]) {
        if(self.endSlider.value - sender.value <= 0) {
            self.endSlider.value = sender.value;
            self.startTimeLabel.text = [NSString stringHourAndMinutesWithInterval:sender.value];
            self.endTimeLabel.text = [NSString stringHourAndMinutesWithInterval:sender.value + 30];
        }
        self.startTimeLabel.text = [NSString stringHourAndMinutesWithInterval:sender.value];
    } else if([sender isEqual:self.endSlider]) {
        if(self.startSlider.value - sender.value > 0) {
            self.startSlider.value = sender.value;
            self.endTimeLabel.text = [NSString stringHourAndMinutesWithInterval:sender.value];
            self.startTimeLabel.text = [NSString stringHourAndMinutesWithInterval:sender.value - 30];
        }
        self.endTimeLabel.text = [NSString stringHourAndMinutesWithInterval:sender.value];
    }
    
}

- (IBAction)actionPageChange:(UIPageControl *)sender {
    [self actionMoveCursor:self.typeEventScrollView];
    CGPoint contentOffset = CGPointMake(sender.currentPage * self.typeEventScrollView.bounds.size.width, 0);
    [self.typeEventScrollView setContentOffset:contentOffset animated:YES];
}

- (void)actionCancelDescription:(UIBarButtonItem *)sender {
    self.partyDescription.text = self.party.partyDescription;
    [self.partyDescription resignFirstResponder];
}

- (void)actionDoneDescription:(UIBarButtonItem *)sender {
    self.party.partyDescription = self.partyDescription.text;
    [self.partyDescription resignFirstResponder];
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self blockControllersBesides:textField userInteractionEnabled:NO];
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self blockControllersBesides:textField userInteractionEnabled:YES];
    [textField resignFirstResponder];
    return NO;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self actionMoveCursor:scrollView];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger currentPage = scrollView.contentOffset.x/scrollView.bounds.size.width;
    [self.typeEventPageControl setCurrentPage:currentPage];
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    self.party.partyDescription = textView.text;
    [self actionMoveCursor:textView];
    __weak PAMCreatePartyViewController *weakSelf = self;
    [UIView animateWithDuration:0.3
                     animations:^{
                         CGRect viewFrame = weakSelf.view.frame;
                         viewFrame.origin.y -= 218;
                         weakSelf.view.frame = viewFrame;
                     }];
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    __weak PAMCreatePartyViewController *weakSelf = self;
    [UIView animateWithDuration:0.2
                     animations:^{
                         CGRect viewFrame = weakSelf.view.frame;
                         viewFrame.origin.y = 64;
                         weakSelf.view.frame = viewFrame;
                     }];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSString *string = [textView.text stringByReplacingCharactersInRange:range withString:text];
    return !(string.length > 500);
}

#pragma mark - PAMDatePikerDelegate
- (void)actionCancelDatePiker:(PAMCustomDatePiker *)sender {
    [self blockControllersBesides:nil userInteractionEnabled:YES];
    [UIView animateWithDuration:0.3
                     animations:^{
                         CGRect rect = sender.frame;
                         rect.origin.y += CGRectGetMaxY(sender.bounds);
                         sender.frame = rect;
                     }
                     completion:^(BOOL finished) {
                         [sender removeFromSuperview];
                     }];
}

- (void)actionDoneDatePiker:(PAMCustomDatePiker *)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"MM.dd.yyyy"];
    [self.chooseButton setTitle: [dateFormatter stringFromDate:sender.datePiker.date] forState:UIControlStateNormal];
    self.partyDate = sender.datePiker.date;
    [self actionCancelDatePiker:sender];
}


@end
