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
//    self.view convertRect:<#(CGRect)#> toView:<#(nullable UIView *)#>
//    NSLog(@"%@", NSStringFromCGRect(textField.frame));
//    int value = (self.view.frame.size.height - 432) - CGRectGetMaxY(textField.frame);
//    if(value <= 0){
//        CGSize contentWithKeyboard = self.loginScrollView.contentSize;
//        contentWithKeyboard.height +=value;
//        self.loginScrollView.contentSize = contentWithKeyboard;
//        
//        CGPoint contentOffset = CGPointMake(0,value);
//        
//        [self.loginScrollView setContentOffset:contentOffset animated:YES];
//    }
    if(!isKeyboardShow) {
        CGSize contentWithKeyboard = self.loginScrollView.contentSize;
        contentWithKeyboard.height +=30;
        self.loginScrollView.contentSize = contentWithKeyboard;
        CGPoint contentOffset = CGPointMake(0,30);
        [self.loginScrollView setContentOffset:contentOffset animated:YES];
        isKeyboardShow = YES;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if([textField isEqual:self.loginTextField]) {
        [self.passwordTextField becomeFirstResponder];
    } else {
        if(isKeyboardShow) {
            CGSize contentWithKeyboard = self.loginScrollView.contentSize;
            contentWithKeyboard.height -=30;
            self.loginScrollView.contentSize = contentWithKeyboard;
            CGPoint contentOffset = CGPointMake(0,0);
            [self.loginScrollView setContentOffset:contentOffset animated:YES];
            isKeyboardShow = NO;
        }
        
        [textField resignFirstResponder];
    }
    return YES;
}


@end
