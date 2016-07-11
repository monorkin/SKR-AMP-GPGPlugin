//
//  SKRAMPGpgView.m
//  SKR-AMP-GPGPlugin
//
//  Created by Stanko Krtalic Rusendic on 09/07/16.
//  Copyright © 2016 Monorkin. All rights reserved.
//
//  -----------------------------------------------
//
//  This class builds a view that will be rendered
//  when the user selects the plugin in the plugin
//  view. It's used to display configuration
//  options.
//

#import "SKRAMPGpgView.h"

@implementation SKRAMPGpgView

#pragma mark - Initialization

- (id)initWithFrame:(NSRect)frame plugin:(AMPlugin *)pluginIn
{
    self = [super initWithFrame:frame plugin:pluginIn];
    if (self) {
        [self defineDefaultValues];
    }
    return self;
}

- (void)defineDefaultValues
{
    
}

@end
