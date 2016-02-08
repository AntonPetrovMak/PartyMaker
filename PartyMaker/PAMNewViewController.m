//
//  PAMNewViewController.m
//  PartyMaker
//
//  Created by Petrov Anton on 08.02.16.
//  Copyright © 2016 Softheme. All rights reserved.
//

#import "PAMNewViewController.h"
#import "PAMParty.h"

@interface PAMNewViewController ()
@property(strong, nonatomic) NSMutableArray *arrayWithMainControllers;
@property(strong, nonatomic) UIView *cursorView;

@end

@implementation PAMNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.arrayWithMainControllers = [[NSMutableArray alloc] init];
    [self.navigationItem setHidesBackButton:YES];
    [self creatingTextField];
    [self creatingScrollView];
    [self creatingTextView];
    [self creatingStatusCursor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)blockControllersBesides:(id) controller userInteractionEnabled:(BOOL) isBlock {
    for (UIView *view in self.view.subviews) {
        if(![view isEqual:controller]){
            view.userInteractionEnabled = isBlock;
        }
    }
}

-(NSString *) getCustomTimeWithIntervale:(int) interval {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat:@"HH:mm"];
    return [formatter stringFromDate:[NSDate dateWithTimeIntervalSinceReferenceDate:interval * 60]];
}

#pragma mark - Creating controllers

- (void)creatingTextField {
    [self.partyNameTextField setTextColor:[UIColor whiteColor]];
    [self.partyNameTextField setFont:[UIFont fontWithName:@"MariadPro-Regular" size:16]];
    self.partyNameTextField.delegate = self;
    NSDictionary *attributedDictionary = @{ NSForegroundColorAttributeName: [UIColor colorWithRed:76/255. green:82/255. blue:92/255. alpha:1]};
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"Your party Name"
                                                                           attributes:attributedDictionary];
    [self.partyNameTextField setAttributedPlaceholder:attributedString];
}

- (void)creatingScrollView {
    self.typeEventScrollView.delegate = self;
    for (int i = 0; i < 6; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"PartyLogo_Small_%d", i]];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(190*i, 0, 190, 80)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [imageView setImage:image];
        [self.typeEventScrollView addSubview:imageView];
    }
    
    CGRect frame = self.typeEventPageControl.frame;
    frame.size.height = 22.0;
    self.typeEventPageControl.frame = frame;
}

- (void)creatingTextView {
    self.partyDescription.delegate = self;
    self.descriptionToolbar.frame =CGRectMake(0, 0, CGRectGetMaxX(self.view.bounds), 50);
    [self.descriptionToolbar sizeToFit];
    self.partyDescription.inputAccessoryView = self.descriptionToolbar;
}

- (void)creatingStatusCursor {
    NSString *statusName[] = {@"CHOOSE DATE",@"PARTY NAME", @"START", @"END", @"LOGO", @"DESCRIPTION", @"FINAL"};
    [self.arrayWithMainControllers addObject:self.chooseButton];
    [self.arrayWithMainControllers addObject:self.partyNameTextField];
    [self.arrayWithMainControllers addObject:self.startSlider];
    [self.arrayWithMainControllers addObject:self.endSlider];
    [self.arrayWithMainControllers addObject:self.typeEventScrollView];
    [self.arrayWithMainControllers addObject:self.partyDescription];
    [self.arrayWithMainControllers addObject:self.closeButton];
    
    float heightLine = [[self.arrayWithMainControllers lastObject] center].y - [[self.arrayWithMainControllers firstObject] center].y;
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15-0.5, [[self.arrayWithMainControllers firstObject] center].y, 1, heightLine)];
    [lineView setBackgroundColor: [UIColor colorWithRed:230/255.f green:224/255.f blue:213/255.f alpha:1]];
    [self.view addSubview:lineView];
    
    for (UIView* object in self.arrayWithMainControllers) {
        UIView *circleView = [[UIView alloc] initWithFrame:CGRectMake(15-4.5, object.center.y - 4.5, 9, 9)];
        [circleView.layer setCornerRadius:4.5];
        [circleView setBackgroundColor: [UIColor colorWithRed:230/255.f green:224/255.f blue:213/255.f alpha:1]];
        [self.view addSubview:circleView];
        
        UILabel *statusNameLable = [[UILabel alloc] initWithFrame:CGRectMake(29, object.center.y - 6, 80, 12)];
        [statusNameLable setFont:[UIFont fontWithName:@"MyriadPro-Regular" size:12]];
        [statusNameLable setTextColor:[UIColor colorWithRed:230/255.f green:224/255.f blue:213/255.f alpha:1]];
        [statusNameLable setText: statusName[[self.arrayWithMainControllers indexOfObject:object]]];
        [self.view addSubview:statusNameLable];
    }
    
    UIView *cursorView = [[UIView alloc] initWithFrame:CGRectMake(15-6.5, [[self.arrayWithMainControllers firstObject] center].y - 6.5, 13, 13)];
    [cursorView.layer setCornerRadius:6.5];
    [cursorView setBackgroundColor: [[UIColor whiteColor] colorWithAlphaComponent:0.4]];
    [self.view addSubview:cursorView];
    self.cursorView = cursorView;
}

#pragma mark - Action
- (IBAction)moveCursor:(UIView *) view {
    __weak PAMNewViewController* weakSelf = self;
    [UIView animateWithDuration:0.3
                     animations:^{
                         weakSelf.cursorView.center = CGPointMake(weakSelf.cursorView.center.x, view.center.y);
                     }];
}

- (IBAction)actionMoveCursor:(UIView *) sender {
    
}

- (IBAction)actionChooseButton:(UIButton *)sender {
    [self blockControllersBesides:nil userInteractionEnabled:NO];
    self.datePikerView.frame = CGRectMake(0, self.view.frame.size.height,
                                          self.datePikerView.bounds.size.width, self.datePikerView.bounds.size.height);
    __weak PAMNewViewController* weakSelf = self;
    [UIView animateWithDuration:0.3
                     animations:^{
                         CGRect rect = weakSelf.datePikerView.frame;
                         rect.origin.y -= CGRectGetMaxY(weakSelf.datePikerView.bounds);
                         weakSelf.datePikerView.frame = rect;
                     }];
    [self.view addSubview:self.datePikerView];
}

- (IBAction)actionSaveButton:(UIButton *)sender {
    [self moveCursor:self.closeButton];
    __weak PAMNewViewController *weakSelf = self;
    if(!self.partyDate) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error!"
                                                                       message:@"You should enter a party date!"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *actionOK = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                         handler: ^(UIAlertAction* action) {
                                                             [weakSelf actionChooseButton:sender];
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
                                                             [weakSelf.partyNameTextField becomeFirstResponder];
                                                         }];
        [alert addAction:actionOK];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        NSError *error;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        NSString *documentsPathWithFile = [documentsPath stringByAppendingPathComponent:@"logs.plist"];
        NSMutableArray *arrayPartyes = [[NSMutableArray alloc] init];
        
        NSCalendar *calendar =[NSCalendar currentCalendar];
        
        NSDateComponents *components = [calendar components:NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:self.partyDate];
        NSInteger intervale = ((components.hour-2) * 60 * 60) + (components.minute * 60) + components.second;
        
        NSDate *partyDate = [self.partyDate dateByAddingTimeInterval:-intervale];
        
        PAMParty *party = [[PAMParty alloc] initWithName:self.partyNameTextField.text
                                               startDate:[partyDate dateByAddingTimeInterval:self.startSlider.value*60]
                                                 endDate:[partyDate dateByAddingTimeInterval:self.endSlider.value*60]
                                                paryType:self.typeEventPageControl.currentPage
                                             description:self.partyDescription.text];
        
        if ([fileManager fileExistsAtPath:documentsPathWithFile]) {
            NSData *oldData =[NSData dataWithContentsOfFile:documentsPathWithFile];
            arrayPartyes = [NSKeyedUnarchiver unarchiveObjectWithData: oldData];
        } else {
            NSString *logsPlistPath = [[NSBundle mainBundle] pathForResource:@"logs" ofType:@"plist"];
            [fileManager copyItemAtPath:logsPlistPath toPath:documentsPathWithFile error:&error];
        }
        [arrayPartyes addObject:party];
        NSData* newData = [NSKeyedArchiver archivedDataWithRootObject: arrayPartyes];
        [newData writeToFile:documentsPathWithFile atomically:YES];
    }
    [self actionCloseButton:sender];
}

- (IBAction)actionCloseButton:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)actionCancelButtonToolbar:(id)sender {
    [self blockControllersBesides:nil userInteractionEnabled:YES];
    __weak PAMNewViewController* weakSelf = self;
    [UIView animateWithDuration:0.3
                     animations:^{
                         CGRect rect = weakSelf.datePikerView.frame;
                         rect.origin.y += CGRectGetMaxY(weakSelf.datePikerView.bounds);
                         weakSelf.datePikerView.frame = rect;
                     }
                     completion:^(BOOL finished) {
                         [weakSelf.datePikerView removeFromSuperview];
                     }];
}

- (IBAction)actionDoneButtonToolbar:(id)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"MM.dd.yyyy"];
    [self.chooseButton setTitle: [dateFormatter stringFromDate:self.datePiker.date] forState:UIControlStateNormal];
    self.partyDate = self.datePiker.date;
    [self actionCancelButtonToolbar:sender];
}

- (IBAction)actionSlideChanged:(UISlider *)sender {
    //[self moveCursor:slider];
    if([sender isEqual:self.startSlider]) {
        if(self.endSlider.value - sender.value <= 0) {
            self.endSlider.value = sender.value;
            self.startTimeLabel.text = [self getCustomTimeWithIntervale:(int)sender.value];
            self.endTimeLabel.text = [self getCustomTimeWithIntervale:(int)sender.value + 30];
        }
        self.startTimeLabel.text = [self getCustomTimeWithIntervale:(int)sender.value];
    } else if([sender isEqual:self.endSlider]) {
        if(self.startSlider.value - sender.value > 0) {
            self.startSlider.value = sender.value;
            self.endTimeLabel.text = [self getCustomTimeWithIntervale:(int)sender.value];
            self.startTimeLabel.text = [self getCustomTimeWithIntervale:(int)sender.value - 30];
        }
        self.endTimeLabel.text = [self getCustomTimeWithIntervale:(int)sender.value];
    }

}

- (IBAction)actionPageChange:(UIPageControl *)sender {
    [self moveCursor:self.typeEventScrollView];
    CGPoint contentOffset = CGPointMake(sender.currentPage * self.typeEventScrollView.bounds.size.width, 0);
    [self.typeEventScrollView setContentOffset:contentOffset animated:YES];
}

- (IBAction)actionCancelDescriptioToolbar:(UIBarButtonItem *)sender {
    [self.partyDescription resignFirstResponder];
}

- (IBAction)actionDoneDescriptioToolbar:(UIBarButtonItem *)sender {
    [self.partyDescription resignFirstResponder];
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self blockControllersBesides:textField userInteractionEnabled:NO];
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self blockControllersBesides:self.partyNameTextField userInteractionEnabled:YES];
    [textField resignFirstResponder];
    return NO;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self moveCursor:scrollView];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger currentPage = scrollView.contentOffset.x/scrollView.bounds.size.width;
    [self.typeEventPageControl setCurrentPage:currentPage];
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    [self moveCursor:textView];
    __weak PAMNewViewController *weakSelf = self;
    [UIView animateWithDuration:0.3
                     animations:^{
                         CGRect viewFrame = weakSelf.view.frame;
                         viewFrame.origin.y -= 250;
                         weakSelf.view.frame = viewFrame;
                     }];
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    __weak PAMNewViewController *weakSelf = self;
    [UIView animateWithDuration:0.2
                     animations:^{
                         CGRect viewFrame = weakSelf.view.frame;
                         viewFrame.origin.y = 0;
                         weakSelf.view.frame = viewFrame;
                     }];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSString *string = [textView.text stringByReplacingCharactersInRange:range withString:text];
    return !(string.length > 500);
}



@end
