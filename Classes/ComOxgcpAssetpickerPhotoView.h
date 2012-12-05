/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2012 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */
#import "TiUIView.h"
#import "TiButtonUtil.h"
#import "TiUIButton.h"
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <QuartzCore/QuartzCore.h>
#import <ImageIO/ImageIO.h>
#import <CoreLocation/CoreLocation.h>

@interface ComOxgcpAssetpickerPhotoView : TiUIView <UITableViewDataSource, UITableViewDelegate> {
    UITableView *tableView;
    NSMutableArray *assets;
    
    BOOL multiple;
    NSString *groupName;
}

@end
