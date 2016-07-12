//
//  SKRAMPGpgButton.m
//  SKR-AMP-GPGPlugin
//
//  Created by Stanko Krtalic Rusendic on 12/07/16.
//  Copyright © 2016 Monorkin. All rights reserved.
//

#import "SKRAMPGpgButton.h"

@implementation SKRAMPGpgButton

#pragma mark - Initialization

- (id)initWithFrame: (NSRect)frameRect
        activeImage: (NSImage *)activeImage
      inactiveImage: (NSImage *)inactiveImage
                tag: (NSInteger)tag
{
    self = [super initWithFrame: frameRect];
    
    if (!self)
    {
        return nil;
    }
    
    [self setButtonType: NSToggleButton];
    [self setTag: tag];
    [self setTitle: @""];
    [self setState: self.readState];
    
    [self setTarget: self];
    [self setAction: @selector(storeState)];
    
    return self;
}

#pragma mark - State management

- (NSInteger)storeState
{
    [[NSUserDefaults standardUserDefaults] setInteger: self.state
                                               forKey: self.defaultsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return self.readState;
}

- (NSInteger)readState
{
    return [[NSUserDefaults standardUserDefaults] integerForKey: self.defaultsKey];
}

- (NSString *)defaultsKey
{
    return  [NSString stringWithFormat: @"SKRAMPGPGPlugin_%ld_button_state", self.tag];
}

- (BOOL)isActive
{
    return (BOOL)self.state;
}

- (void)setState: (NSInteger)state
{
    if (state == NSOnState)
    {
        [self setEnabled: true];
    }
    else
    {
       [self setEnabled: false];
    }
    
    [super setState: state];
}

@end
