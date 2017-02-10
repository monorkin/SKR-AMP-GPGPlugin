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

// Processes the message
// Is signes and/or encrypts the message
//
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

// Encrypts and signs the message
//
- (NSString *)encryptAndSign
{
    NSString *message = self.rfc;
    
    message = [self signMessage: message];
    message = [self encryptMessage: message];
    
    return message;
}

// Encrypts the message
//
- (NSString *)encrypt
{
    return [self encryptMessage: self.rfc];
}

// Signs the message
//
- (NSString *)sign
{
    return [self signMessage: self.rfc];
}

// Encrypts the message so that only the sender and all recepiants
// can decrypt it
//
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

// Signs the message with the sender's key (determined by email)
//
- (NSString *)signMessage: (NSString *)message
{
    NSString *sender = self.info.localMessage.from.mail;
    NSString *signedMessage = [self.cryptography signMessage: message
                                                   withEmail: sender];
    
    
    return signedMessage;
}

// Wraps the message in a multipart file
// This converts the message to an attached file.
//
// This is standard parctice when sending encrypted messages, most
// mail clients expect a file called `encrypted.asc` with the cyphertext
//
- (NSString *)multipartEnvelopeMessage: (NSString *)message
                         multipartType: (NSString *)multipartType
                     multipartProtocol: (NSString *)multipartProtocol
                                micalg: (NSString *)micalg
                              filename: (NSString *)filename
                       fileContentType: (NSString *)fileContentType
                       fileDescription: (NSString *)fileDescription

{
    NSString *boundary = self.uuid;
    
    if (micalg)
    {
        micalg = [NSString stringWithFormat: @" %@", micalg];
    }
    else
    {
        micalg = @"";
    }
    
    // Multipart header
    NSMutableString *header = [[NSMutableString alloc] init];
    [header appendString: [NSString stringWithFormat: @"Content-Type: multipart/%@;\r\n", multipartType]];
    [header appendString: [NSString stringWithFormat: @"\tboundary=\"%@\";\r\n", boundary]];
    [header appendString: [NSString stringWithFormat: @"\tprotocol=\"%@\";\r\n", multipartProtocol]];
    [header appendString: micalg];
    [header appendString: @"\r\n"];
    
    // Multipart file definition
    NSMutableString *file = [[NSMutableString alloc] init];
    [file appendString: [NSString stringWithFormat:@"--%@\r\n", boundary]];
    [file appendString: @"Content-Transfer-Encoding: 7bit\r\n"];
    [file appendString: [NSString stringWithFormat:@"Content-Type: %@; name=%@\r\n", fileContentType, filename]];
    [file appendString: [NSString stringWithFormat:@"Content-Disposition: attachment; filename=%@\r\n", filename]];
    [file appendString: [NSString stringWithFormat:@"Content-Description: %@\r\n", fileDescription]];
    [file appendString: @"\r\n"];
    [file appendString: message];
    [file appendString: @"\r\n"];
    [file appendString: [NSString stringWithFormat:@"--%@--", boundary]];
    
    NSString *infusedHeaders = [self infuseHeaders: self.rfc withNewContentType: header];
    
    NSMutableString *envelope = [[NSMutableString alloc] init];
    [envelope appendString: infusedHeaders];
    [envelope appendString: file];
    
    return envelope;
}

// Generates the message's UUID
//
- (NSString *)uuid
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    
    NSString *boundary = (__bridge_transfer NSString *)string;
    
    if(!boundary)
    {
        // I'm not a 100% sure why this is here, but I ported it from
        // the original project. I don't see how the `CFUUIDRef` method
        // could not return an UUID, but I guess there is a reason for
        // this failsafe
        return @"------=_Part_68593_50468503.1397487740428";
    }
    
    return boundary;
}

// Combines the original RFC's headers with a given header
// overwriting the origina's contant type.
// Used for converting regular messages to messages sent as files
//
- (NSString *)infuseHeaders: (NSString *)rfc
             withNewContentType: (NSString *)contentType
{
    NSMutableString *rfcOut = [NSMutableString new];
    
    // This was a bit confusing to port over
    // Basically:
    //  0 - Do nothing (copy over the original header)
    //  1 - Copy the new header
    //  2 - Skip empty lines and othe param definitions until another
    //      attribute is reached
    __block NSInteger mode = 0;
    
    [rfc enumerateLinesUsingBlock:^(NSString *line, BOOL *stop) {
        // End of header - stop further merge by exiting the iterator
        if ([line isEqualToString:@""])
        {
            [rfcOut appendString:@"\r\n"];
            *stop = YES;
            return;
        }
        
        // Start the merge when the content type definition is reached
        if ([line hasPrefix:@"Content-Type"])
        {
            mode = 1;
        }
        
        switch (mode)
        {
            // Copy over previous header data line by line
            case 0:
            {
                [rfcOut appendFormat: @"%@\r\n", line];
            }
            break;
            
            // Copy over new header data all at once
            case 1:
            {
                [rfcOut appendFormat: @"%@\r\n", contentType];
                mode = 2;
            }
            break;
            
            // Skip garbage
            case 2:
            {
                // If a header attribute has been found return to mode 0
                if([line rangeOfString: @":"].location != NSNotFound)
                {
                    [rfcOut appendFormat: @"%@\r\n", line];
                    mode = 0;
                }
            }
            break;
        }
    }];
    
    return rfcOut;
}

@end
