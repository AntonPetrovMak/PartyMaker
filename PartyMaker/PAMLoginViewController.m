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
    
    //[[PAMDataStore standartDataStore] clearCoreData];
    [[PAMDataStore standartDataStore] addAllUsersWithPartiesFromServer];
    
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

- (void) createInfoViewWithMessage:(NSString *) message {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *viewWithMessage = [[UIView alloc] initWithFrame:CGRectMake(6, -60, CGRectGetMaxX(self.view.bounds)-12, 60)];
        [viewWithMessage setBackgroundColor:[UIColor colorWithRed:46/255.f green:49/255.f blue:56/255.f alpha:1]];
        [viewWithMessage.layer setBorderWidth:2.f];
        [viewWithMessage.layer setBorderColor:[UIColor colorWithRed:236/255.f green:71/255.f blue:19/255.f alpha:1].CGColor];
        UILabel *messageLable = [[UILabel alloc] initWithFrame:CGRectMake(6, 0, CGRectGetMaxX(self.view.bounds)-24, 60)];
        [messageLable setText:message];
        [messageLable setTextColor:[UIColor whiteColor]];
        [messageLable setFont:[UIFont fontWithName:@"MariadPro-Regular" size:16]];
        [viewWithMessage addSubview:messageLable];
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        [self.view addSubview:viewWithMessage];
        [UIView animateWithDuration:0.2 animations:^{
            CGRect rect = viewWithMessage.frame;
            rect.origin.y = -2;
            viewWithMessage.frame = rect;
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            [UIView animateWithDuration:0.2
                                  delay:0
                                options: UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 CGRect rect = viewWithMessage.frame;
                                 rect.origin.y = -60;
                                 viewWithMessage.frame = rect;
                             }
                             completion:^(BOOL finished) {
                                 [viewWithMessage removeFromSuperview];
                             }];
        });
        
    });
   
}

- (void) userLogin {
    if(self.loginTextField.text.length && self.passwordTextField.text.length) {
        __weak PAMLoginViewController *weakSelf = self;
        PAMPartyMakerAPI *partyMakerAPI = [PAMPartyMakerAPI standartPartyMakerAPI];
        [partyMakerAPI loginWithUserName: self.loginTextField.text
                             andPassword: self.passwordTextField.text
                                callback:^(NSDictionary *response, NSError *error) {
                                    
                                    NSDictionary *answerServer = [response objectForKey:@"response"];
                                    if([[response objectForKey:@"statusCode"] isEqual:@200]) {
                                        if([[answerServer objectForKey:@"name"] isEqualToString:weakSelf.loginTextField.text]) {
                                            NSLog(@"Login user id: %ld", [[answerServer objectForKey:@"id"] integerValue]);
                                            [[NSUserDefaults standardUserDefaults] setObject:@([[answerServer objectForKey:@"id"] integerValue]) forKey:@"userId"];
                                            
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                UITabBarController *tabBar = [weakSelf.storyboard instantiateViewControllerWithIdentifier:@"MainTabBarController"];
                                                [weakSelf presentViewController:tabBar animated:YES completion:nil];
                                            });
                                        }else {
                                            [weakSelf createInfoViewWithMessage:@"Sorry, problem with server!"];
                                        }
                                    } else if([[response objectForKey:@"statusCode"] isEqual:@505]) {
                                        [weakSelf createInfoViewWithMessage:@"No internet"];
                                        NSLog(@"No internet");
                                    } else {
                                        [weakSelf createInfoViewWithMessage:[answerServer objectForKey:@"msg"]];
                                        NSLog(@"%@",[answerServer objectForKey:@"msg"]);
                                    }
                                }];
    }
}

#pragma mark - Action
- (IBAction)actionClickRegister:(UIButton *)sender {
    if(self.loginTextField.text.length && self.passwordTextField.text.length) {
        __weak PAMLoginViewController *weakSelf = self;
        PAMPartyMakerAPI *partyMakerAPI = [PAMPartyMakerAPI standartPartyMakerAPI];
        
        [partyMakerAPI registerWithUserName:self.loginTextField.text
                                andPassword:self.passwordTextField.text
                                   andEmail:[NSString stringWithFormat:@"%@@gmail.com",weakSelf.loginTextField.text]
                                   callback:^(NSDictionary *response, NSError *error) {
                                       NSDictionary *answerServer = [response objectForKey:@"response"];
                                       if([[response objectForKey:@"statusCode"] isEqual:@200]) {
                                           [self userLogin];
                                           NSLog(@"Register OK");
                                       } else if([[response objectForKey:@"statusCode"] isEqual:@505]) {
                                           [weakSelf createInfoViewWithMessage:@"No internet"];
                                           NSLog(@"No internet");
                                       } else {
                                           [weakSelf createInfoViewWithMessage:[answerServer objectForKey:@"msg"]];
                                           NSLog(@"%@",[answerServer objectForKey:@"msg"]);
                                       }
                                   }];

    }
}

- (void) loginAndWriteToCoreData {
    __weak PAMLoginViewController *weakSelf = self;
    PAMPartyMakerAPI *partyMakerAPI = [PAMPartyMakerAPI standartPartyMakerAPI];
    [partyMakerAPI loginWithUserName: self.loginTextField.text
                         andPassword: self.passwordTextField.text
                            callback:^(NSDictionary *response, NSError *error) {
                                NSDictionary *answerServer = [response objectForKey:@"response"];
                                if([[response objectForKey:@"statusCode"] isEqual:@200]) {
                                    if([[answerServer objectForKey:@"name"] isEqualToString:weakSelf.loginTextField.text]) {
                                        //write to core data
                                        [[PAMDataStore standartDataStore] writeUserToCoreDataInBackroundThread:^(NSManagedObjectContext *backroundContext) {
                                            PAMUserCore *userCore = [NSEntityDescription insertNewObjectForEntityForName:@"PAMUserCore" inManagedObjectContext:backroundContext];
                                            userCore.name = [answerServer objectForKey:@"name"];
                                            userCore.userId = [[answerServer objectForKey:@"userId"] integerValue];
                                        } completion:^{
                                            NSLog(@"completion save user to CoreData");
                                        }];
                                        
                                        [[NSUserDefaults standardUserDefaults] setObject:@([[answerServer objectForKey:@"id"] intValue]) forKey:@"userId"];
                                    }else {
                                        [weakSelf createInfoViewWithMessage:@"Sorry, problem with server!"];
                                    }
                                } else {
                                    [weakSelf createInfoViewWithMessage:[answerServer objectForKey:@"msg"]];
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
