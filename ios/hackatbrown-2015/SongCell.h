//
//  SongCell.h
//  hackatbrown-2015
//
//  Created by Matt Cooper on 2/8/15.
//  Copyright (c) 2015 Matthew Cooper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Song.h"

@interface SongCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *albumCoverImageView;
@property (weak, nonatomic) IBOutlet UILabel *songTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;

- (void)setupWithSong:(Song *)song;

@end
