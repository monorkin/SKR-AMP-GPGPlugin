//
//  MessageDecrypter.m
//  SKR-AMP-GPGPlugin
//
//  Created by Stanko Krtalic Rusendic on 11/07/16.
//  Copyright © 2016 Monorkin. All rights reserved.
//

#import "SKRAMPGpgMessageDecrypter.h"

@implementation SKRAMPGpgMessageDecrypter

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

- (NSData *)decrypt
{
    NSData *data = self.message.rfcData;
    
    AMPMCOMessageParser *parser = [AMPMCOMessageParser messageParserWithData: data];
    NSArray *encParts = [parser.mainPart PartsForMime:@"application/octet-stream"];
    
    if(encParts.count != 1)
    {
        return nil;
    }
    
    AMPMCOAbstractPart *part = encParts[0];
    
    if(![[part.filename pathExtension] isEqualToString: @"asc"])
    {
        return nil;
    }
    
    NSData *attachemntData = [part callSelector: @selector(data)];
    
    if(!attachemntData || attachemntData.length == 0)
    {
        return nil;
    }
    
    NSData *decryptedData = [self decryptData: attachemntData];
    return decryptedData;
}

- (NSData *)decryptData: (NSData *)data
{
    return [self.cryptography decryptData: data];
}

@end
