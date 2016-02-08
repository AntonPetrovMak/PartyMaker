//
//  PAMNewViewController.h
//  PartyMaker
//
//  Created by Petrov Anton on 08.02.16.
//  Copyright © 2016 Softheme. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PAMNewViewController : UIViewController <UITextFieldDelegate, UIScrollViewDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *chooseButton;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePiker;
@property (weak, nonatomic) IBOutlet UITextField *partyNameTextField;

@property (weak, nonatomic) IBOutlet UISlider *startSlider;
@property (weak, nonatomic) IBOutlet UISlider *endSlider;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;

@property (weak, nonatomic) IBOutlet UIScrollView *typeEventScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *typeEventPageControl;
@property (weak, nonatomic) IBOutlet UITextView *partyDescription;
@property (weak, nonatomic) IBOutlet UIToolbar *descriptionToolbar;

@property (strong, nonatomic) IBOutlet UIView *datePikerView;
@property (weak, nonatomic) IBOutlet UIView *cursorView;

@property(strong, nonatomic) NSDate *partyDate;

- (IBAction)actionMoveCursor:(UIView *) sender;

- (IBAction)actionChooseButton:(UIButton *)sender;
- (IBAction)actionSaveButton:(UIButton *)sender;
- (IBAction)actionCloseButton:(UIButton *)sender;

- (IBAction)actionCancelDatePiker:(id)sender;
- (IBAction)actionDoneDatePiker:(id)sender;

- (IBAction)actionSlideChanged:(UISlider *)sender;

- (IBAction)actionPageChange:(UIPageControl *)sender;

- (IBAction)actionCancelDescription:(UIBarButtonItem *)sender;
- (IBAction)actionDoneDescription:(UIBarButtonItem *)sender;



@end
