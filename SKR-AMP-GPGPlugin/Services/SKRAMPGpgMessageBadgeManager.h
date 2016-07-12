//
//  MessageBadgeManager.h
//  SKR-AMP-GPGPlugin
//
//  Created by Stanko Krtalic Rusendic on 11/07/16.
//  Copyright © 2016 Monorkin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AMPluginFramework/AMPluginFramework.h>

@interface SKRAMPGpgMessageBadgeManager : NSObject

@property (nonatomic) AMPMessage *message;
@property (nonatomic) NSNumber *encryptionStatus;
@property (nonatomic) NSNumber *signatureStatus;
@property (nonatomic) NSImage *encryptedIcon;
@property (nonatomic) NSImage *unencryptedIcon;
@property (nonatomic) NSImage *signedIcon;
@property (nonatomic) NSImage *unsignedIcon;

- (NSArray *)generateBadges;

@end
