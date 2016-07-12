//
//  ButtonBuilder.m
//  SKR-AMP-GPGPlugin
//
//  Created by Stanko Krtalic Rusendic on 11/07/16.
//  Copyright © 2016 Monorkin. All rights reserved.
//

#import "SKRAMPGpgButtonManager.h"

@implementation SKRAMPGpgButtonManager

#pragma mark - Builders

- (NSArray *)buildComposerButtons
{
    return @[self.buildEncryptButton, self.buildSignButton];
}

- (SKRAMPGpgButton *)buildEncryptButton
{
    NSString *tooltip = NSLocalizedString(@"encrypt_button_tooltip", nil);
    
    SKRAMPGpgButton *button = [self buildButtonWithTag: SKRAMPGpgPluginEncryptButtonTag
                                               tooltip: tooltip
                                               xOffset: 0
                                           activeImage: self.activeEncryptImage
                                         inactiveImage: self.inactiveEncryptImage];
    return button;
}

- (SKRAMPGpgButton *)buildSignButton
{
    NSString *tooltip = NSLocalizedString(@"sign_button_tooltip", nil);
    
    SKRAMPGpgButton *button = [self buildButtonWithTag: SKRAMPGpgPluginSignButtonTag
                                               tooltip: tooltip
                                               xOffset: self.buttonRect.size.width
                                           activeImage: self.activeSignImage
                                         inactiveImage: self.inactiveSignImage];
    return button;
}

- (SKRAMPGpgButton *)buildButtonWithTag: (NSInteger)tag
                                tooltip: (NSString *)tooltip
                                xOffset: (float)xOffset
                            activeImage: (NSImage *)activeImage
                          inactiveImage: (NSImage *)inactiveImage

{
    NSRect frame = self.buttonRect;
    frame.origin.x += xOffset;
    
    SKRAMPGpgButton *button = [[SKRAMPGpgButton alloc] initWithFrame: frame
                                                         activeImage: activeImage
                                                       inactiveImage: inactiveImage
                                                                 tag: tag];
    [button setToolTip: tooltip];
    return button;
}

- (NSRect)buttonRect
{
    return NSMakeRect(0, 0, 22, 20);
}

#pragma mark - Getters

- (BOOL)shouldEncrypt
{
    SKRAMPGpgButton *button = self.encryptButton;
    BOOL shouldEncrypt = (button.state == NSOnState);
    return shouldEncrypt;
}

- (BOOL)shouldSign
{
    SKRAMPGpgButton *button = self.signButton;
    BOOL shouldEncrypt = (button.state == NSOnState);
    return shouldEncrypt;
}

- (NSArray *)composerButtons
{
    return @[self.encryptButton, self.signButton];
}

- (SKRAMPGpgButton *)encryptButton
{
    SKRAMPGpgButton *button = (SKRAMPGpgButton *)[self buttonWithTag: SKRAMPGpgPluginEncryptButtonTag];
    return button;
}

- (SKRAMPGpgButton *)signButton
{
    SKRAMPGpgButton *button = (SKRAMPGpgButton *)[self buttonWithTag: SKRAMPGpgPluginSignButtonTag];
    return button;
}

- (NSButton *)buttonWithTag: (NSInteger)tag
{
    NSArray *buttonViews = [self.info composerBtn: self.plugin];
    
    if(!buttonViews || buttonViews.count == 0)
    {
        return nil;
    }
    
    NSView *composer = buttonViews[0];
    
    for (NSView *testView in composer.subviews) {
        if (![testView isKindOfClass: [SKRAMPGpgButton class]])
        {
            continue;
        }
        
        SKRAMPGpgButton *button = (SKRAMPGpgButton *)testView;
        
        if (button.tag == tag)
        {
            return button;
        }
    }
    
    return nil;
}

#pragma mark - Setters

- (void)setButtonStatesFromCanEncrypt: (BOOL)canEncrypt
                           andCanSign: (BOOL)canSign
{
    [self setState: canEncrypt
         forButton: self.encryptButton];
    [self setState: canSign
         forButton: self.signButton];
}

- (void)setState: (bool)state
       forButton: (NSButton *)button
{
    NSInteger buttonState = state ? NSOnState : NSOffState;
    [button setState: buttonState];
}

@end
