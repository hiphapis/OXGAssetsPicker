/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2012 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "ComOxgcpAssetspickerPhotoView.h"

@implementation ComOxgcpAssetspickerPhotoView

-(void)dealloc {
    RELEASE_TO_NIL(assets);
    RELEASE_TO_NIL(tableView);
    // RELEASE_TO_NIL(groupName);
    // RELEASE_TO_NIL(filter);
    // RELEASE_TO_NIL(backgroundColor);
    [super dealloc];
}

- (id)setMultiple_:(id)_multiple {
    multiple = [_multiple boolValue];
}

- (id)setGroupName_:(id)_groupName {
    groupName = _groupName;
}

- (id)setFilter_:(id)_filter {
    filter = _filter;
}

- (id)setSort_:(id)_sort {
    sort = _sort;
}

- (id)setLimit_:(id)_limit {
    limit = [_limit intValue];
}

- (id)setSelectedPhotos_:(id)_selectedPhotos {
    selectedPhotos = [NSArray arrayWithArray:_selectedPhotos];
    
    for (unsigned i = 0; i < assets.count; i++) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[assets objectAtIndex:i]];
        [dic setValue:@"false" forKey:@"selected"];
        [assets replaceObjectAtIndex:i withObject:dic];

    }
    
    for (unsigned i = 0; i < selectedPhotos.count; i++) {
        int key = [[selectedPhotos objectAtIndex:i] intValue];
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[assets objectAtIndex:key]];
        [dic setValue:@"true" forKey:@"selected"];
        [assets replaceObjectAtIndex:key withObject:dic];
    }
    
    [[self tableView] reloadData];
}

- (id)setBackgroundColor_:(id)_backgroundColor {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:_backgroundColor];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    backgroundColor = [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

-(UITableView *)tableView {
    //    NSLog(@"Asset[Photo]: TableView - init");
    
    if (tableView==nil)
    {
        assets = [[NSMutableArray alloc] init];
        tableView = [[UITableView alloc] initWithFrame:[self frame]];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.scrollsToTop = YES;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        tableView.backgroundColor = (backgroundColor)? backgroundColor : [UIColor clearColor];
        [self addSubview:tableView];
        
        //        NSLog(@"Asset[Photo]: TableView - created");
        
        [self loadAssets];
    }
    return tableView;
}


-(void)frameSizeChanged:(CGRect)frame bounds:(CGRect)bounds {
    if ([self tableView]!=nil) {
        [TiUtils setView:tableView positionRect:bounds];
    }
}


-(void)loadAssets {
    //    NSLog(@"Asset[Photo]: loadAssets #1");
    void (^assetGroupEnumerator) (ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop){
        if(group != nil) {
            //            NSLog(@"Asset[Photo]: loadAssets #1-1");
            if (groupName == nil || [[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:groupName]) {
                //                NSLog(@"Asset[Photo]: loadAssets #1-2");
                if ([filter isEqualToString:@"photo"]) {
                    [group setAssetsFilter:[ALAssetsFilter allPhotos]];
                }
                else if ([filter isEqualToString:@"video"]) {
                    [group setAssetsFilter:[ALAssetsFilter allVideos]];
                }
                
                [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                    if( result != nil ) {
                        //                        NSLog(@"Asset[Photo]: loadAssets #1-3: %@ = %@", [group valueForProperty:ALAssetsGroupPropertyName], groupName);
                        
                        ALAssetRepresentation *rep = [result defaultRepresentation];
                        NSURL *url = rep.url;
                        UIImage *thumbnail = [UIImage imageWithCGImage:[result thumbnail]];
                        NSDictionary *dic = [NSDictionary
                                             dictionaryWithObjectsAndKeys:
                                             thumbnail,
                                             @"thumbnail",
                                             url,
                                             @"url",
                                             @"false",
                                             @"selected",
                                             nil];
                        
                        if ([sort isEqualToString:@"recent"]) {
                            [assets insertObject:dic atIndex:0];
                        }
                        else {
                            [assets addObject:dic];
                        }                    
                    }
                }];
                
//                NSLog(@"Asset[Photo]: loadAssets #1-4");
                [[self tableView] reloadData];
            }
        }
    };
    
    //    NSLog(@"Asset[Photo]: loadAssets #2");
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    [library enumerateGroupsWithTypes:ALAssetsGroupAll
                           usingBlock:assetGroupEnumerator
                         failureBlock:^(NSError *error) {
                             NSString *resultMsg = [NSString stringWithFormat:@"Failed: code=%d", [error code]];
                             NSLog(@"Failed: %@", resultMsg);
                         }];
    
    [library release];
    //    NSLog(@"Asset[Photo]: loadAssets #3");
}

-(void)selectPhoto:(UIButton *)button {
    NSLog(@"limit: %d", limit);
    
    NSLog(@"selectedPhotoCount Before: %d", selectedPhotoCount);
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[assets objectAtIndex:button.tag]];
    
    if (![[dic objectForKey:@"selected"] isEqualToString:@"true"]) {
        NSLog(@"Asset[Photo]: CLICK - Selected");
        
        if (limit != 0 && selectedPhotoCount >= limit) {
            [self.proxy fireEvent:@"photo:limit"];
            return;
        }
        else {
            selectedPhotoCount += 1;
        }
        
        NSLog(@"selectedPhotoCount After+: %d", selectedPhotoCount);

        [dic setValue:@"true" forKey:@"selected"];
        [assets replaceObjectAtIndex:button.tag withObject:dic];
        
        
        if (multiple) {
            [button setSelected:YES];
        }
        
        void (^assetForURLResultBlock)(ALAsset *) = ^(ALAsset *result)
        {
            if( result != nil )
            {
                ALAssetRepresentation *rep = [result defaultRepresentation];
                NSURL *url = [[result defaultRepresentation] url];
                UIImage *image = [UIImage imageWithCGImage:[rep fullScreenImage]];
                
                
                //EXIF
                NSMutableDictionary *dictMeta = [[NSMutableDictionary alloc] init];
                
                NSDictionary *metadata = [[result defaultRepresentation] metadata];
                NSDictionary *exif = [metadata objectForKey:@"{Exif}"];
                CLLocation *location = [result valueForProperty:ALAssetPropertyLocation];
                CLLocationCoordinate2D coordinate = [location coordinate];
                NSDictionary *gps = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [NSNumber numberWithDouble:coordinate.latitude],@"latitude",
                                     [NSNumber numberWithDouble:coordinate.longitude],@"longitude",
                                     nil];
                if (gps != nil) {
                    [dictMeta setObject:gps forKey:@"location"];
                }
                
                if (exif != nil) {
                    [dictMeta setObject:exif forKey:@"exif"];
                }
                
                
                NSDictionary *event = [NSDictionary
                                       dictionaryWithObjectsAndKeys:
                                       dictMeta,
                                       @"meta",
                                       [[[TiBlob alloc] initWithImage:image] autorelease],
                                       @"image",
                                       url,
                                       @"url",
                                       NUMBOOL(YES),
                                       @"selected",
                                       NUMINT(button.tag),
                                       @"index",
                                       nil];
                
                if (!multiple) {
                    [dic setValue:@"false" forKey:@"selected"];
                    [assets replaceObjectAtIndex:button.tag withObject:dic];
                }
                
                [self.proxy fireEvent:@"photo:selected" withObject:event];
            }
        };
        
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        
        [library assetForURL:[dic objectForKey:@"url"]
                 resultBlock:assetForURLResultBlock
                failureBlock:^(NSError *error){
                    NSString *resultMsg = [NSString stringWithFormat:@"Failed: code=%d", [error code]];
                    NSLog(@"%@", resultMsg);
                    [self.proxy fireEvent:@"photo:failed" withObject:NUMINT(error.code)];
                }];
        
        [library release];
    }
    else {
        NSLog(@"Asset[Photo]: CLICK - DeSelected");

        selectedPhotoCount -= 1;
        NSLog(@"selectedPhotoCount After-: %d", selectedPhotoCount);
        
        [dic setValue:@"false" forKey:@"selected"];
        [assets replaceObjectAtIndex:button.tag withObject:dic];
        
        
        [button setSelected:NO];
        
        NSDictionary *event = [NSDictionary
                               dictionaryWithObjectsAndKeys:
                               NUMBOOL(NO),
                               @"selected",
                               NUMINT(button.tag),
                               @"index",
                               nil];
        [self.proxy fireEvent:@"photo:selected" withObject:event];
    }
}




///////////////////////////////////////////////////////////////////////////////////
// table delegate
#pragma mark -
#pragma mark Table view data source

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"AssetsPickerPhotoRow";
    
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // Configure the cell...
    NSUInteger firstPhotoInCell = indexPath.row * 3;
    NSUInteger lastPhotoInCell  = firstPhotoInCell + 3;
    
    if (assets.count <= firstPhotoInCell) {
        NSLog(@"We are out of range, asking to start with photo %d but we only have %d", firstPhotoInCell, assets.count);
        return nil;
    }
    
    NSUInteger currentPhotoIndex = 0;
    NSUInteger lastPhotoIndex = MIN(lastPhotoInCell, assets.count);

    for ( ; firstPhotoInCell + currentPhotoIndex < lastPhotoIndex ; currentPhotoIndex++) {
          // NSLog(@"%d[%d]=>%d:%d", indexPath.row, firstPhotoInCell + currentPhotoIndex, lastPhotoIndex, currentPhotoIndex);


          NSDictionary *dic = [assets objectAtIndex:firstPhotoInCell + currentPhotoIndex];
        
          //        NSLog(@"current: %d %@", firstPhotoInCell + currentPhotoIndex, dic);
        
          // Thumbnail
          UIImage *thumbnail = [dic objectForKey:@"thumbnail"];
          UIImageView *thumbView = [[UIImageView alloc] initWithImage:thumbnail];
        
        
          // Button
          UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
          button.tag = firstPhotoInCell + currentPhotoIndex;
        
          NSString *resourceurl = [[NSBundle mainBundle] resourcePath];
          NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/modules/%@/%@", resourceurl, @"com.oxgcp.assetspicker", @"photo_select.png"]];
          UIImage *overlayImage = [UIImage imageWithContentsOfFile:[url path]];
          [button setImage:overlayImage forState:UIControlStateSelected];
          [button setSelected:[[dic objectForKey:@"selected"] isEqualToString:@"true"]];
        
          [button addTarget:self action:@selector(selectPhoto:) forControlEvents:UIControlEventTouchUpInside];
        
        
          // Frame
          CGRect frame = button.frame;
          frame.size = CGSizeMake(100, 100);
          frame.origin.y = 5;
          frame.origin.x = (currentPhotoIndex * (100 + 5)) + 5;
          button.frame = frame;
          thumbView.frame = frame;
        
        
        
          [cell addSubview:thumbView];
          [cell addSubview:button];
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ceil((float)assets.count / 3);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == ceil((float)assets.count / 3) - 1) {
        return 110.0f;
    }
    return 105.0f;
}

@end
