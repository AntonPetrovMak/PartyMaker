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

+ (NSString *) reuseIdentifire;

- (void) configureWithPartyName:(NSString *) partyName partyDate:(NSString *) partyDate partyType:(UIImage *) partyType;
- (void)prepareForReuse;

@end
