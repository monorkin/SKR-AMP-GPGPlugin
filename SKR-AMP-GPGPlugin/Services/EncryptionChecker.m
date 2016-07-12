//
//  EncryptionChecker.m
//  SKR-AMP-GPGPlugin
//
//  Created by Stanko Krtalic Rusendic on 11/07/16.
//  Copyright © 2016 Monorkin. All rights reserved.
//

#import "EncryptionChecker.h"

@implementation EncryptionChecker

- (NSInteger)encryptionStatus
{
    NSInteger status = AMP_ENCRYPTED_NONE;
    
    for(AMPMCOAbstractPart *part in  [self.parser.mainPart AllParts])
    {
        if(!part.mimeType)
        {
            continue;
        }
        
        if([part.mimeType isEqualToString:@"application/pgp-signature"])
        {
            status |= AMP_ENCRYPTED_SIGNED;
        }
            
        if([part.mimeType isEqualToString:@"application/pgp-encrypted"])
        {
            status |= AMP_ENCRYPTED;
        }
    }
    
    return status;
}

- (BOOL)isEncrypted
{
    return (self.encryptionStatus & AMP_ENCRYPTED) != 0;
}

- (BOOL)isSigned
{
    return (self.encryptionStatus & AMP_ENCRYPTED_SIGNED) != 0;
}

@end
