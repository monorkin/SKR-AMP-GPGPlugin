//
//  SKRAMPGPG.m
//  SKR-AMP-GPGPlugin
//
//  Created by Stanko Krtalic Rusendic on 09/07/16.
//  Copyright © 2016 Monorkin. All rights reserved.
//
//  -----------------------------------------------
//
//  This is the main entry class for the plugin.
//  It implements all the hook and callback methods.
//  It basically defines the plugin.
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
    self.signedMessages = [[NSMutableDictionary alloc] init];
    self.encryptedMessages = [[NSMutableDictionary alloc] init];
}

#pragma mark - Plugin loading

// Called by AMP to signal the Plugin to load it's resources
//
- (BOOL) Load
{
    if(![super Load]) {
        return false;
    }
    
    [self loadAssets];
    
    return true;
}

// Resource loading logic
//
- (void)loadAssets
{
    self.icon = [self loadImage: @"icon.psd"];
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

// Returns the view used in the plugin window.
//
- (AMPView *)pluginview
{
    if (!self.view) {
        self.view = [[SKRAMPGpgView alloc] initWithFrame: NSZeroRect
                                                  plugin: self];
    }
    
    return self.view;
}

// Returns the plugin's name
//
- (NSString *)nametext
{
    return NSLocalizedString(@"plugin_name", nil);;
}

// Returns the plugin's short description
//
- (NSString *)description
{
    return NSLocalizedString(@"plugin_description", nil);
}

// Returns the plugin's description
//
- (NSString *)descriptiontext
{
    return NSLocalizedString(@"plugin_description", nil);;
}

// Returns the plugin's authors
//
- (NSString *)authortext
{
    return NSLocalizedString(@"plugin_author", nil);;
}


// Returns the plugin's homepage
//
- (NSString *)supportlink
{
    return NSLocalizedString(@"plugin_support_link", nil);;
}

// Returns the plugin's icon
//
- (NSImage *)icon
{
    return _icon;
}

#pragma mark - Airmail plugin hooks

// Views that should be added to the recipients input
//
// Add the encrypt and sign buttons to the message composer
//
- (NSArray *)ampPileComposerView: (AMPComposerInfo *)info
{
    SKRAMPGpgButtonManager *buttonManager = [self buildButtonManagerWithInfo: info];
    return buttonManager.buildComposerButtons;
}

// Called each time a recipient has been added or removed
//
// Change the state of the buttons depending if the selected sender
// has a valid key to sign the outgoing message. And wether or not
// public keys for all recepiants are present in the local keychain.
//
- (NSNumber *)ampPileChangedRecipients: (AMPComposerInfo *)info
{
    SKRAMPGpgEncryptionCapabilityChecker *encryptionCapabilityChecker = [[SKRAMPGpgEncryptionCapabilityChecker alloc] init];
    encryptionCapabilityChecker.info = info;
    
    BOOL canEncrypt = encryptionCapabilityChecker.canEncrypt;
    BOOL canSign = encryptionCapabilityChecker.canSign;
    
    SKRAMPGpgButtonManager *buttonManager = [self buildButtonManagerWithInfo: info];
    
    [buttonManager setButtonStatesFromCanEncrypt: canEncrypt
                                      andCanSign: canSign];
    
    return @1;
}

// Called to check if the message is encrypted
//
- (NSNumber *)ampPileIsEncrypted: (AMPMCOMessageParser *)parser
{
    SKRAMPGpgEncryptionChecker *encryptionChecker = [[SKRAMPGpgEncryptionChecker alloc] init];
    encryptionChecker.parser = parser;
    
    return @(encryptionChecker.encryptionStatus);
}

// Called to check if the message is signed
//
// Check if the message is signed. If it's signed store
// it in the signed messages dictionary so that we can perform
// other checks in the future.
//
- (AMPSignatureVerify *)ampPileVerifySignature: (AMPMessage *)message
{
    SKRAMPGpgSignatureVerifyer *signatureVerifyer = [[SKRAMPGpgSignatureVerifyer alloc] init];
    signatureVerifyer.message = message;
    
    AMPSignatureVerify *signatureVerification = nil;
    
    @try
    {
        signatureVerification = signatureVerifyer.verify;
        
        if (signatureVerifyer) {
            [self.signedMessages setObject: @(signatureVerification.signatureVerify)
                                    forKey: message.idx];
        }
    }
    @catch (NSException *exception)
    {
        [self LogError:exception.reason];
    }
    
    return signatureVerification;
}

// Called to decrypt the message before rendering
//
- (NSData *)ampStackDecrypt:(AMPMessage*)message
{
    NSData *data = nil;
    
    SKRAMPGpgMessageDecrypter *messageDecrypter = [[SKRAMPGpgMessageDecrypter alloc] init];
    messageDecrypter.message = message;
    
    @try
    {
        data = messageDecrypter.decrypt;
        
        if(data)
        {
            [self.encryptedMessages setObject: @(YES)
                                       forKey: message.idx];
        }
    }
    @catch (NSException *exception)
    {
        [self LogError:exception.reason];
        [self.encryptedMessages setObject: @(NO)
                                   forKey: message.idx];
    }
    
    return data;
}

// Called befor the message gets sent
//
// The outgoing message gets processed by this method before it
// gets sent. Here we check if we should sign an/or encrypt the
// message, perform the desired actions, and return a new message
// body (rfc). This method also sets the success status. If for
// any reason the cryptography actions fail we want the send
// process to fail also.
//
- (AMPSendResult *)ampStackSendRfc: (NSString *)rfc composer: (AMPComposerInfo *)info
{
    AMPSendResult *sendResult = [AMPSendResult new];
    sendResult.result = AMP_SEND_RESULT_NONE;
    
    SKRAMPGpgButtonManager *buttonManager = [self buildButtonManagerWithInfo: info];
    
    BOOL shouldEncrypt = buttonManager.shouldEncrypt;
    BOOL shouldSign = buttonManager.shouldSign;
    
    if(!shouldEncrypt && !shouldSign)
    {
        return sendResult;
    }
    
    SKRAMPGpgMessageEncrypter *messageEncrypter = [[SKRAMPGpgMessageEncrypter alloc] init];
    messageEncrypter.rfc = rfc;
    messageEncrypter.info = info;
    messageEncrypter.shouldEncrypt = shouldEncrypt;
    messageEncrypter.shouldSign = shouldSign;
    
    @try
    {
        sendResult.rfc = messageEncrypter.process;
        sendResult.result = AMP_SEND_RESULT_SUCCESS;
    }
    @catch (NSException *exception) {
        [self LogError:exception.reason];
        sendResult.err = exception.reason;
        sendResult.result = AMP_SEND_RESULT_FAIL;
    }
    
    return sendResult;
}

// Called to render the message body
//
// Add signed and/or encrypted badges
//
- (NSArray *)ampPileMessageView: (AMPMessage *)message
{
    SKRAMPGpgMessageBadgeManager *messageBadgeManager = [[SKRAMPGpgMessageBadgeManager alloc] init];
    messageBadgeManager.message = message;
    
    messageBadgeManager.encryptionStatus = [self.encryptedMessages objectForKey: message.idx];
    messageBadgeManager.signatureStatus = [self.signedMessages objectForKey: message.idx];
    
    if(messageBadgeManager.encryptionStatus.integerValue > 0)
    {
        [self.encryptedMessages removeObjectForKey: message.idx];
    }
    
    if(messageBadgeManager.signatureStatus.integerValue > 0)
    {
        [self.signedMessages removeObjectForKey: message.idx];
    }
    
    return messageBadgeManager.generateBadges;
}

#pragma mark - Service builders

// Builds a button manager and forwards all needed resources
//
- (SKRAMPGpgButtonManager *)buildButtonManagerWithInfo: (AMPComposerInfo *)info
{
    SKRAMPGpgButtonManager *buttonManager = [[SKRAMPGpgButtonManager alloc] init];
    
    buttonManager.info = info;
    buttonManager.plugin = self;
    buttonManager.activeEncryptImage = self.activeEncryptImage;
    buttonManager.inactiveEncryptImage = self.inactiveEncryptImage;
    buttonManager.activeSignImage = self.activeSignImage;
    buttonManager.inactiveSignImage = self.inactiveSignImage;
    
    return buttonManager;
}

@end
