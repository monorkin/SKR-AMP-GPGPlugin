//
//  SKRAMPGPG.m
//  SKR-AMP-GPGPlugin
//
//  Created by Stanko Krtalic Rusendic on 09/07/16.
//  Copyright © 2016 Monorkin. All rights reserved.
//

#import "SKRAMPGpg.h"

@implementation SKRAMPGpg

#pragma mark - Initialization

- (id)init
{
    self = [super init];
    if (self)
    {
        [self defineDefaultValues];
    }
    return self;
}

- (void)defineDefaultValues
{
    
}

#pragma mark - Plugin loading

- (BOOL) Load
{
    if(![super Load]) {
        return false;
    }
    
    [self loadAssets];
    
    return true;
}

- (void)loadAssets
{
    self.icon = [self loadImage: @"icon.png"];
}

#pragma mark - Plugin methods

- (void) Enable
{
}

- (void) Disable
{
}

- (void) Invalid
{
}

- (void) Reload
{
}

#pragma mark - Plugin definition

- (AMPView *)pluginview
{
    if (!self.view) {
        self.view = [[SKRAMPGpgView alloc] initWithFrame: NSZeroRect
                                                  plugin: self];
    }
    
    return self.view;
}

- (NSString *)nametext
{
    return NSLocalizedString(@"plugin_name", nil);;
}

- (NSString *)description
{
    return NSLocalizedString(@"plugin_description", nil);
}

- (NSString *)descriptiontext
{
    return NSLocalizedString(@"plugin_description", nil);;
}

- (NSString *)authortext
{
    return NSLocalizedString(@"plugin_author", nil);;
}

- (NSString *)supportlink
{
    return NSLocalizedString(@"plugin_support_link", nil);;
}

- (NSImage *)icon
{
    return _icon;
}

@end
