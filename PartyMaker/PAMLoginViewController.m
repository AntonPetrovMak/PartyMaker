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

#pragma mark - Helpers
- (void) userLogin {
    __weak PAMLoginViewController *weakSelf = self;
    PAMPartyMakerSDK *partyMakerSDK = [PAMPartyMakerSDK standartPartyMakerSDK];
    [partyMakerSDK loginWithUserName: weakSelf.loginTextField.text
                         andPassword: weakSelf.passwordTextField.text
                            callback:^(NSDictionary *response, NSError *error) {
        NSDictionary *answerServer = [response objectForKey:@"response"];
        if([[response objectForKey:@"statusCode"] isEqual:@200]) {
            if([[answerServer objectForKey:@"name"] isEqualToString:weakSelf.loginTextField.text]) {
                PAMUser *user = [[PAMUser alloc] initWithName:[answerServer objectForKey:@"name"]
                                                        email:[answerServer objectForKey:@"email"]
                                                       userId:[[answerServer objectForKey:@"id"] intValue]];
                NSData* userData = [NSKeyedArchiver archivedDataWithRootObject: user];
                [[NSUserDefaults standardUserDefaults] setObject:userData forKey:@"userId"];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    UITabBarController *tabBar = [weakSelf.storyboard instantiateViewControllerWithIdentifier:@"MainTabBarController"];
                    [weakSelf presentViewController:tabBar animated:YES completion:nil];
                });
            }else {
                NSLog(@"Karl, problem with server!");
            }
        } else {
            NSLog(@"%@",[answerServer objectForKey:@"msg"]);
        }
    }];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userId"];
}

#pragma mark - Action
- (IBAction)actionClickRegister:(UIButton *)sender {
    __weak PAMLoginViewController *weakSelf = self;
    PAMPartyMakerSDK *partyMakerSDK = [PAMPartyMakerSDK standartPartyMakerSDK];
    [partyMakerSDK registerWithUserName:weakSelf.loginTextField.text
                            andPassword:weakSelf.passwordTextField.text
                               andEmail:[NSString stringWithFormat:@"%@@gmail.com",weakSelf.loginTextField.text]
                               callback:^(NSDictionary *response, NSError *error) {
                                   NSDictionary *answerServer = [response objectForKey:@"response"];
                                   if([[response objectForKey:@"statusCode"] isEqual:@200]) {
                                       [weakSelf userLogin];
                                   } else {
                                       NSLog(@"%@",[answerServer objectForKey:@"msg"]);
                                   }
                               }];
}

- (IBAction)actionClickSingIn:(UIButton *)sender {
    [self userLogin];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
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
