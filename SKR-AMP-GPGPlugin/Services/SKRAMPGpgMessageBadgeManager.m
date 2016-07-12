//
//  MessageBadgeManager.m
//  SKR-AMP-GPGPlugin
//
//  Created by Stanko Krtalic Rusendic on 11/07/16.
//  Copyright © 2016 Monorkin. All rights reserved.
//

#import "SKRAMPGpgMessageBadgeManager.h"

@implementation SKRAMPGpgMessageBadgeManager

#pragma mark - Getters

- (NSArray *)generateBadges
{
    return @[self.buildEncryptionBadge, self.buildSignedBadge];
}

- (NSImageView *)buildEncryptionBadge
{
    NSImageView *imageIvew = [self buildImageViewWithImage: self.encryptedBadgeImage
                                                   tooltip: self.encryptedBadgeTooltip];
    return imageIvew;
}

- (NSImageView *)buildSignedBadge
{
    NSImageView *imageIvew = [self buildImageViewWithImage: self.signedBadgeImage
                                                   tooltip: self.signedBadgeTooltip];
    return imageIvew;
}

- (NSImageView *)buildImageViewWithImage: (NSImage *)image
                                 tooltip: (NSString *)tooltip
{
    NSImageView *imageView = [[NSImageView alloc] initWithFrame: self.imageViewRect];
    
    imageView.image = image;
    imageView.toolTip = tooltip;
    imageView.imageAlignment = NSImageAlignTopLeft;
    imageView.imageScaling = NSImageScaleProportionallyUpOrDown;
    
    return imageView;
}

- (NSRect)imageViewRect
{
    return NSMakeRect(0, 0, 16, 16);
}

- (NSImage *)encryptedBadgeImage
{
    if (self.encryptionStatus.boolValue)
    {
        return self.encryptedIcon;
    }

    return self.unencryptedIcon;
}

- (NSImage *)signedBadgeImage
{
    if (self.signatureStatus.boolValue)
    {
        return self.signedIcon;
    }
    
    return self.unsignedIcon;
}

- (NSString *)encryptedBadgeTooltip
{
    if (self.encryptionStatus.boolValue)
    {
        return NSLocalizedString(@"decrypted", nil);
    }
    
    return NSLocalizedString(@"decryption_failed", nil);
}

- (NSString *)signedBadgeTooltip
{
    if (self.signatureStatus.boolValue)
    {
        return NSLocalizedString(@"signed", nil);
    }
    
    return NSLocalizedString(@"not_signed", nil);
}

@end
