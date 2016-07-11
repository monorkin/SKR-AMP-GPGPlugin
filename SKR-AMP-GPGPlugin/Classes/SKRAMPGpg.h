//
//  SKRAMPGPG.h
//  SKR-AMP-GPGPlugin
//
//  Created by Stanko Krtalic Rusendic on 09/07/16.
//  Copyright © 2016 Monorkin. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AMPluginFramework/AMPluginFramework.h>
#import "SKRAMpGpgView.h"

extern NSString * const AMPGpgRemeberChoice;

@interface SKRAMPGpg : AMPlugin

@property (nonatomic, strong) SKRAMPGpgView *view;
@property (nonatomic, strong) NSImage *icon;

@end
