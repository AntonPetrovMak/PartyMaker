//
//  PAMLoginViewController.h
//  PartyMaker
//
//  Created by Petrov Anton on 15.02.16.
//  Copyright © 2016 Softheme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PAMPartyMakerSDK.h"
#import "PAMUser.h"

@interface PAMLoginViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *loginTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIView *substrateForLoginView;
@property (weak, nonatomic) IBOutlet UIScrollView *loginScrollView;

- (IBAction)actionClickRegister:(UIButton *)sender;
- (IBAction)actionClickSingIn:(UIButton *)sender;
@end
