//
//  SignatureVerifyer.m
//  SKR-AMP-GPGPlugin
//
//  Created by Stanko Krtalic Rusendic on 11/07/16.
//  Copyright © 2016 Monorkin. All rights reserved.
//

#import "SKRAMPGpgSignatureVerifyer.h"

@implementation SKRAMPGpgSignatureVerifyer

- (AMPSignatureVerify *)verify
{
    AMPSignatureVerify *verification = [AMPSignatureVerify new];
    verification.signatureVerify = AMP_SIGNED_NONE;
    verification.mimetoRemove = @[@"application/pgp-signature"];
    
    NSData *messageData = self.message.rfcData;
    NSData *signatureData = nil;
    
    AMPMCOMessageParser *parser = [AMPMCOMessageParser messageParserWithData: messageData];
    
    if(parser.mainPart.partType == AMPMCOPartTypeMultipartSigned)
    {
        NSString *rfc = [[NSString alloc] initWithData: messageData encoding: NSUTF8StringEncoding];
        signatureData = [self getSignedPart: rfc];
    }
    
    if (!signatureData)
    {
        return verification;
    }
    
    NSArray *encParts = [parser.mainPart PartsForMime: @"application/pgp-signature"];
    
    if(encParts.count != 1)
    {
        return verification;
    }
    
    verification.signatureVerify = AMP_SIGNED_FAILS;
    AMPMCOAbstractPart *part = encParts[0];
    
    if(![part.filename isEqualToString:@"signature.asc"])
    {
        return verification;
    }
    
    NSData *attachmentData = [part callSelector: @selector(data)];
    
    if (!attachmentData)
    {
        return verification;
    }
    
    BOOL signatureValid = [self.cryptography verifySignature: signatureData
                                                     forData: attachmentData
                                                     byEmail: self.message.from.mail];
    
    if (signatureValid)
    {
        verification.signatureVerify = AMP_SIGNED_SUCCESS;
    }
    
    return verification;
}

- (NSData *)getSignedPart: (NSString *)rfc
{
    NSScanner *scanner = [NSScanner scannerWithString:rfc];
    [scanner setCharactersToBeSkipped: nil];
    
    if(![scanner scanUpAndScan:@"Content-Type:" intoString:nil])
    {
        return nil;
    }
    
    NSString *boundary = [self parseBoundary: scanner];
    
    if(!boundary)
    {
        return nil;
    }
    
    NSArray *boundaries = [self parsePartsWithScanner: scanner withinBoundary: boundary];
    
    if(boundaries && boundaries.count > 0)
    {
        NSString *detachedString = boundaries[0];
        if(detachedString)
        {
            return [detachedString dataUsingEncoding: NSASCIIStringEncoding];
        }
        
    }
    
    return nil;
}

- (NSString *)parseBoundary: (NSScanner *)scanner
{
    if(![scanner scanUpToString:@"boundary" intoString:nil])
    {
        return nil;
    }
    
    if(![scanner scanUpToString:@"=" intoString:nil])
    {
        return nil;
    }
    
    if(![scanner scanUpToString:@"\"" intoString:nil])
    {
        return nil;
    }
    
    if(![scanner scanString:@"\"" intoString:nil])
    {
        return nil;
    }
    
    NSString *boundary = nil;
    
    if(![scanner scanUpToString:@"\"" intoString: &boundary])
    {
        return nil;
    }
    
    return boundary;
}

- (NSArray *)parsePartsWithScanner: (NSScanner *)scanner
                     withinBoundary: (NSString *)boundary
{
    NSMutableArray *parts = [NSMutableArray array];
    NSString *preBoundary = [NSString stringWithFormat:@"--%@", boundary];
    
    while(YES)
    {
        if(![scanner scanUpAndScan: preBoundary intoString: nil])
        {
            break;
        }
        
        if([scanner scanString: @"--" intoString: nil])
        {
            break;
        }
        
        if(![scanner scanUpAndScan: @"\n" intoString: nil])
        {
            break;
        }
        
        NSString *detachedString = nil;
        NSString *followingBoundry = [NSString stringWithFormat: @"\n%@", preBoundary];
        
        if(![scanner scanUpToString: followingBoundry intoString: &detachedString])
        {
            break;
        }
        
        [parts addObject: detachedString];
    }
    
    return parts;
}

@end
