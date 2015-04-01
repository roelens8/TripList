//
//  CustomCell.h
//  TripListP1
//
//  Created by Armand Roelens on 3/31/15.
//  Copyright (c) 2015 CSE 394. All rights reserved.
//

#import <UIKit/UIKit.h>

//The purpose of this class is to prevent the UITableViewCell subviews from disappearing for a second after selecting and deselecting the cell. Therefore, the setHighlighted and setSelected methods needed to be overriden.
@interface CustomCell : UITableViewCell

@property UIView* subView;

@end
