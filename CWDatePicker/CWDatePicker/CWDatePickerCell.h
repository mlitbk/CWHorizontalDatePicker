//
//  CWDatePickerCell.h
//  Analysa
//
//  Created by Michael Litvak on 5/27/14.
//  Copyright (c) 2014 codewhisper. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CWDatePickerCell : UICollectionViewCell

@property UILabel *label;

- (void)setupWithData:(NSString*)data;
- (void)setupBorder;
- (void)removeBorder;

@end
