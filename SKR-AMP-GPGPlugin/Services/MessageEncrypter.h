//
//  MessageEncrypter.h
//  SKR-AMP-GPGPlugin
//
//  Created by Stanko Krtalic Rusendic on 11/07/16.
//  Copyright © 2016 Monorkin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AMPluginFramework/AMPluginFramework.h>

@interface MessageEncrypter : NSObject

@property (nonatomic) AMPComposerInfo *info;
@property (nonatomic) NSString *rfc;
@property (nonatomic) BOOL shouldEncrypt;
@property (nonatomic) BOOL shouldSign;

- (NSString *)encrypt;
- (NSString *)sign;
- (NSString *)encryptAndSign;
- (NSString *)process;

@end
