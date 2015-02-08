//
//  SongCell.m
//  hackatbrown-2015
//
//  Created by Matt Cooper on 2/8/15.
//  Copyright (c) 2015 Matthew Cooper. All rights reserved.
//

#import "SongCell.h"

@implementation SongCell

- (void)setupWithSong:(Song *)song{
    [self.albumCoverImageView setImage:song.albumCover];
    [self.songTitleLabel setText:song.title];
    [self.artistLabel setText:song.artist];
}

@end
