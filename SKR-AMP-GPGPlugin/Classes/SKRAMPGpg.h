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
#import "SKRAMPGpgButtonManager.h"
#import "SKRAMPGpgMessageEncrypter.h"
#import "SKRAMPGpgMessageDecrypter.h"
#import "SKRAMPGpgEncryptionCapabilityChecker.h"
#import "SKRAMPGpgEncryptionChecker.h"
#import "SKRAMPGpgSignatureVerifyer.h"
#import "SKRAMPGpgMessageBadgeManager.h"

extern NSString * const AMPGpgRemeberChoice;

@interface SKRAMPGpg : AMPlugin

@property (nonatomic, strong) NSMutableDictionary *signedMessages;
@property (nonatomic, strong) NSMutableDictionary *encryptedMessages;
@property (nonatomic, strong) SKRAMPGpgView *view;
@property (nonatomic, strong) NSImage *icon;
@property (nonatomic, strong) NSImage *activeEncryptImage;
@property (nonatomic, strong) NSImage *inactiveEncryptImage;
@property (nonatomic, strong) NSImage *activeSignImage;
@property (nonatomic, strong) NSImage *inactiveSignImage;
@property (nonatomic, strong) NSImage *encryptedIcon;
@property (nonatomic, strong) NSImage *unencryptedIcon;
@property (nonatomic, strong) NSImage *signedIcon;
@property (nonatomic, strong) NSImage *unsignedIcon;

@end
