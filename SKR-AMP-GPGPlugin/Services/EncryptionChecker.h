//
//  EncryptionChecker.h
//  SKR-AMP-GPGPlugin
//
//  Created by Stanko Krtalic Rusendic on 11/07/16.
//  Copyright © 2016 Monorkin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AMPluginFramework/AMPluginFramework.h>

@interface EncryptionChecker : NSObject

@property (nonatomic) AMPMCOMessageParser *parser;

- (BOOL)isEncrypted;

@end
