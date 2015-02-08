//
//  AppDelegate.h
//  hackatbrown-2015
//
//  Created by Matt Cooper on 2/7/15.
//  Copyright (c) 2015 Matthew Cooper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Spotify/Spotify.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@property (nonatomic, strong) SPTSession *session;
@property (nonatomic, strong) SPTAudioStreamingController *player;

@end

