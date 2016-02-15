//
//  PAMLoginViewController.m
//  PartyMaker
//
//  Created by Petrov Anton on 15.02.16.
//  Copyright © 2016 Softheme. All rights reserved.
//

#import "PAMLoginViewController.h"

@interface PAMLoginViewController () {
    BOOL isKeyboardShow;
}

@end

@implementation PAMLoginViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    isKeyboardShow = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.substrateForLoginView.layer setBorderWidth:2.f];
    [self.substrateForLoginView.layer setBorderColor:[UIColor whiteColor].CGColor];
    
    [self.loginTextField setFont:[UIFont fontWithName:@"MariadPro-Regular" size:16]];
    [self.passwordTextField setFont:[UIFont fontWithName:@"MariadPro-Regular" size:16]];
    NSDictionary *attributedDictionary = @{ NSForegroundColorAttributeName: [UIColor colorWithRed:76/255. green:82/255. blue:92/255. alpha:1]};
    NSAttributedString *attributedForLogin = [[NSAttributedString alloc] initWithString:@"Login"
                                                                           attributes:attributedDictionary];
    NSAttributedString *attributedForPassword = [[NSAttributedString alloc] initWithString:@"Password"
                                                                                attributes:attributedDictionary];
    [self.loginTextField setAttributedPlaceholder:attributedForLogin];
    [self.passwordTextField setAttributedPlaceholder:attributedForPassword];
}

#pragma mark - Action

- (IBAction)actionClickRegister:(UIButton *)sender {
    
}

- (IBAction)actionClickSingIn:(UIButton *)sender {
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if(!isKeyboardShow) {
//        __weak PAMLoginViewController *weakSelf = self;
//        [UIView animateWithDuration:0.3
//                         animations:^{
//                             CGRect viewFrame = weakSelf.view.frame;
//                             viewFrame.origin.y -= 50;
//                             weakSelf.view.frame = viewFrame;
//                         }];
        isKeyboardShow = YES;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if([textField isEqual:self.loginTextField]) {
        [self.passwordTextField becomeFirstResponder];
    } else {
        if(isKeyboardShow) {
//            __weak PAMLoginViewController *weakSelf = self;
//            [UIView animateWithDuration:0.3
//                             animations:^{
//                                 CGRect viewFrame = weakSelf.view.frame;
//                                 viewFrame.origin.y = 0;
//                                 weakSelf.view.frame = viewFrame;
//                             }];
            isKeyboardShow = NO;
        }
        
        [textField resignFirstResponder];
    }
    return YES;
}


@end
