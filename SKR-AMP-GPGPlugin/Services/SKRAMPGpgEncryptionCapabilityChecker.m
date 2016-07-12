//
//  EncryptionCapabilityChecker.m
//  SKR-AMP-GPGPlugin
//
//  Created by Stanko Krtalic Rusendic on 11/07/16.
//  Copyright © 2016 Monorkin. All rights reserved.
//

#import "SKRAMPGpgEncryptionCapabilityChecker.h"

@implementation SKRAMPGpgEncryptionCapabilityChecker

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

#pragma mark - Getters

- (BOOL)canEncrypt
{
    NSArray *mails   = [self.info.localMessage GetMails];
    
    if(!mails || mails.count == 0)
    {
        return false;
    }
        
    for (NSString *email in mails) {
        if (![self.cryptography canEncryptForMail: email]) {
            return false;
        }
    }
    
    return true;
}

- (BOOL)canSign
{
    return [self.cryptography canSignWithMail: self.info.localMessage.from.mail];
}

@end
