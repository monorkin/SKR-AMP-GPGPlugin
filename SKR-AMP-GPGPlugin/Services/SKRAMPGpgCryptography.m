//
//  Cryptography.m
//  SKR-AMP-GPGPlugin
//
//  Created by Stanko Krtalic Rusendic on 11/07/16.
//  Copyright © 2016 Monorkin. All rights reserved.
//

#import "SKRAMPGpgCryptography.h"

@implementation SKRAMPGpgCryptography

- (BOOL)canEncryptForMail: (NSString *)email
{
    GPGKey *key = [self keyWithEmail: email];
    
    if (key)
    {
        return true;
    }
    
    return false;
}

- (BOOL)canSignWithMail: (NSString *)email
{
    return [self canEncryptForMail: email];
}

- (NSString *) encryptMessage: (NSString *)message
                    withEmail: (NSString *)sender
                forRecipients: (NSArray *)recipients
         withHiddenRecipients: (NSArray *)hiddenRecipients
{
    
}

- (NSString *) signMessage: (NSString *)message
                 withEmail: (NSString *)sender
{
    NSData *messageData = [message dataUsingEncoding:NSUTF8StringEncoding];
    
    if(!messageData)
    {
        return nil;
    }
    
    GPGController *gpgController = [GPGController gpgController];
    gpgController.useArmor = true;
    gpgController.useTextMode = true;
    
    GPGKey *key = [self keyWithEmail: sender];
    
    if(!key)
    {
        return nil;
    }
    
    [gpgController setSignerKey:key];
    
    NSData *signedMessageData = [gpgController processData: messageData
                                       withEncryptSignMode: GPGDetachedSign
                                                recipients: nil
                                          hiddenRecipients: nil];
    
    NSString *signedMessage = [[NSString alloc] initWithData: signedMessageData
                                                    encoding: NSUTF8StringEncoding];
    
    return signedMessage;
}

- (NSData *) decryptData: (NSData *)data
{
    
}

- (BOOL) verifySignature: (NSData *)signature
                 forData: (NSData *)data
                 byEmail: (NSString *)email
{
    
}

#pragma mark - Key lookup

- (GPGKey *)keyWithEmail: (NSString *)email
{
    NSSet *keys = [[GPGKeyManager sharedInstance] allKeys];
    
    for (GPGKey *key in keys)
    {
        if ([self isKey: key forEmail: email] && [self checkValidityOfKey: key])
        {
            return key;
        }
    }
    
    return nil;
}

- (BOOL)isKey: (GPGKey *)key
     forEmail: (NSString *)email
{
    for (GPGUserID *uid in key.userIDs)
    {
        if([uid.email isEqualToString: email])
        {

            return true;
        }
    }
    
    return false;
}

#pragma mark - Key validation

- (BOOL)checkValidityOfKey: (GPGKey *)key
{
    if(key.validity == GPGValidityFull || key.validity == GPGValidityUltimate)
    {
        return true;
    }
    
    return false;
}

@end
