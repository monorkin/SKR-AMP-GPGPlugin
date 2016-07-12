//
//  SKRAMPGpgButton.h
//  SKR-AMP-GPGPlugin
//
//  Created by Stanko Krtalic Rusendic on 12/07/16.
//  Copyright © 2016 Monorkin. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SKRAMPGpgButton : NSButton

@property (nonatomic) NSImage *activeImage;
@property (nonatomic) NSImage *inactiveImage;

- (id)initWithFrame: (NSRect)frameRect
        activeImage: (NSImage *)activeImage
      inactiveImage: (NSImage *)inactiveImage
                tag: (NSInteger)tag;

@end
