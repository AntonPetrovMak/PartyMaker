//
//  PAMCreatePartyViewController.h
//  PartyMaker
//
//  Created by Petrov Anton on 18.02.16.
//  Copyright © 2016 Softheme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSString+PAMDateFormat.h"
#import "PAMCustomDatePiker.h"
#import "PAMPartyMakerSDK.h"
#import "PAMDataStore.h"
#import "PAMPartyCore.h"
#import "PAMParty.h"

@interface PAMCreatePartyViewController : UIViewController <UITextFieldDelegate, UIScrollViewDelegate, UITextViewDelegate, PAMDatePikerDelegate>

@property(strong, nonatomic) PAMPartyCore *partyCore;
@property(strong, nonatomic) PAMParty *party;

@property (weak, nonatomic) IBOutlet UIButton *chooseButton;
@property (weak, nonatomic) IBOutlet UITextField *partyNameTextField;

@property (weak, nonatomic) IBOutlet UISlider *startSlider;
@property (weak, nonatomic) IBOutlet UISlider *endSlider;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;

@property (weak, nonatomic) IBOutlet UIScrollView *typeEventScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *typeEventPageControl;
@property (weak, nonatomic) IBOutlet UITextView *partyDescription;

@property (weak, nonatomic) IBOutlet UIView *cursorView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cursorTopConstraint;

@property(strong, nonatomic) NSDate *partyDate;


- (IBAction)actionMoveCursor:(UIView *) sender;

- (IBAction)actionChooseButton:(UIButton *)sender;
- (IBAction)actionSaveButton:(id)sender;
- (IBAction)actionCloseButton:(id)sender;

- (IBAction)actionSlideChanged:(UISlider *)sender;

- (IBAction)actionPageChange:(UIPageControl *)sender;

@end
