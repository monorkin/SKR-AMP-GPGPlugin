//
//  SKRAMPGPG.h
//  SKR-AMP-GPGPlugin
//
//  Created by Stanko Krtalic Rusendic on 09/07/16.
//  Copyright © 2016 Monorkin. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AMPluginFramework/AMPluginFramework.h>
// Views
#import "SKRAMpGpgView.h"
// Services
#import "ButtonManager.h"
#import "MessageEncrypter.h"
#import "MessageDecrypter.h"
#import "EncryptionCapabilityChecker.h"
#import "EncryptionChecker.h"
#import "SignatureVerifyer.h"
#import "MessageBadgeManager.h"

extern NSString * const AMPGpgRemeberChoice;

@interface SKRAMPGpg : AMPlugin

@property (nonatomic, strong) NSMutableDictionary *signedMessages;
@property (nonatomic, strong) NSMutableDictionary *encryptedMessages;
@property (nonatomic, strong) SKRAMPGpgView *view;
@property (nonatomic, strong) NSImage *icon;

@end
