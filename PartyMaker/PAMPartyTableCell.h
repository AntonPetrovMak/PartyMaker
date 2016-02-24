//
//  PAMPartyTableCell.h
//  PartyMaker
//
//  Created by Petrov Anton on 11.02.16.
//  Copyright © 2016 Softheme. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PAMPartyTableCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *patryTypeImage;
@property (strong, nonatomic) IBOutlet UILabel *partyNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *partyDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *partyAddressLabel;

+ (NSString *) reuseIdentifire;

- (void) configureWithPartyName:(NSString *) partyName partyDate:(NSString *) partyDate partyType:(UIImage *) partyType partyAddress:(NSString *) address;

@end
