//
//  PAMCustomDatePiker.m
//  PartyMaker
//
//  Created by Petrov Anton on 09.02.16.
//  Copyright © 2016 Softheme. All rights reserved.
//

#import "PAMCustomDatePiker.h"

@implementation PAMCustomDatePiker


- (IBAction)actionCancelDatePiker:(id)sender {
    if(self.delegate && [self.delegate respondsToSelector:@selector(actionCancelDatePiker:)]) {
        [self.delegate performSelector:@selector(actionCancelDatePiker:) withObject:self];
    }
}

- (IBAction)actionDoneDatePiker:(id)sender {
    if(self.delegate && [self.delegate respondsToSelector:@selector(actionDoneDatePiker:)]) {
        [self.delegate performSelector:@selector(actionDoneDatePiker:) withObject:self];
    }
}
@end
