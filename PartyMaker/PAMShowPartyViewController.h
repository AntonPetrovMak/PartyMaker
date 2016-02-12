//
//  PAMShowPartyViewController.h
//  PartyMaker
//
//  Created by Petrov Anton on 11.02.16.
//  Copyright © 2016 Softheme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PAMParty.h"

@interface PAMShowPartyViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *partyTypeImageView;
@property (weak, nonatomic) IBOutlet UILabel *partyNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *partyDescriptionTextView;

@property (weak, nonatomic) IBOutlet UILabel *partyDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *partyTimeStartLabel;
@property (weak, nonatomic) IBOutlet UILabel *partyTimeEndLabel;

@property (weak, nonatomic) IBOutlet UIButton *locationButton;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descriptionHeightConstraint;

@property (nonatomic, strong) PAMParty *party;

@end
