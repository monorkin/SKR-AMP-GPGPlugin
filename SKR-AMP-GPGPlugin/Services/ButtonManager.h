//
//  ButtonBuilder.h
//  SKR-AMP-GPGPlugin
//
//  Created by Stanko Krtalic Rusendic on 11/07/16.
//  Copyright © 2016 Monorkin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AMPluginFramework/AMPluginFramework.h>

enum skr_amp_gpg_plugin_button_tags {
    SKRAMPGpgPluginEncryptButtonTag = 313778001,
    SKRAMPGpgPluginSignButtonTag = 313778002,
};

@interface ButtonManager : NSObject

@property (nonatomic) AMPComposerInfo *info;

- (NSArray *)buildComposerButtons;
- (NSArray *)composerButtons;
- (void)setButtonStatesFromCanEncrypt: (BOOL)canEncrypt andCanSign: (BOOL)canSign;
- (BOOL)shouldEncrypt;
- (BOOL)shouldSign;

@end
