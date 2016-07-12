//
//  MessageEncrypter.m
//  SKR-AMP-GPGPlugin
//
//  Created by Stanko Krtalic Rusendic on 11/07/16.
//  Copyright © 2016 Monorkin. All rights reserved.
//

#import "SKRAMPGpgMessageEncrypter.h"

@implementation SKRAMPGpgMessageEncrypter

- (id)init
{
    self = [super init];
    
    if (!self)
    {
        return nil;
    }
    
    self.cryptography = [[SKRAMPGpgCryptography alloc] init];
    
    return self;
}

- (NSString *)process
{
    if (self.shouldEncrypt && self.shouldSign)
    {
        return self.encryptAndSign;
    }
    else if (self.shouldEncrypt)
    {
        return self.encrypt;
    }
    else if (self.shouldSign)
    {
        return self.sign;
    }
    
    return nil;
}

- (NSString *)encryptAndSign
{
    NSString *message = self.rfc;
    
    message = [self signMessage: message];
    message = [self encryptMessage: message];
    
    return message;
}

- (NSString *)encrypt
{
    return [self encryptMessage: self.rfc];
}

- (NSString *)sign
{
    return [self signMessage: self.rfc];
}

- (NSString *)encryptMessage: (NSString *)message
{
    NSString *sender = self.info.localMessage.from.mail;
    
    NSDictionary *maps = [self.info.localMessage GetMailsMaps];
    
    NSMutableArray *recipients = [NSMutableArray array];
    [recipients addObjectsFromArray: maps[@"to"]];
    [recipients addObjectsFromArray: maps[@"cc"]];
    [recipients addObject: sender];
    
    NSArray *hiddenRecipients = maps[@"bcc"];
    
    return [self.cryptography encryptMessage: message
                                   withEmail: sender
                               forRecipients: recipients
                        withHiddenRecipients: hiddenRecipients];
}

- (NSString *)signMessage: (NSString *)message
{
    NSString *sender = self.info.localMessage.from.mail;
    
    return [self.cryptography signMessage: message
                                withEmail: sender];
}

@end
