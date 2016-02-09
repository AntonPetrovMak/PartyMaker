//
//  PAMCustomDatePiker.h
//  PartyMaker
//
//  Created by Petrov Anton on 09.02.16.
//  Copyright © 2016 Softheme. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PAMCustomDatePiker;

@protocol PAMDatePikerDelegate <NSObject>
- (void)actionCancelDatePiker:(PAMCustomDatePiker *)sender;
- (void)actionDoneDatePiker:(PAMCustomDatePiker *)sender;
@end

@interface PAMCustomDatePiker : UIView
@property (nonatomic, weak) id <PAMDatePikerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePiker;
@end
