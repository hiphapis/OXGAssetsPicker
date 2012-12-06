/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2012 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "ComOxgcpAssetpickerPhotoView.h"

@implementation ComOxgcpAssetpickerPhotoView

- (id)setMultiple_:(id)_multiple {
    multiple = [_multiple boolValue];
}

- (id)setGroupName_:(id)_groupName {
    groupName = _groupName;
}

- (id)setFilter:(id)_filter {
    filter = _filter;
}

-(void)dealloc {
    RELEASE_TO_NIL(assets);
    RELEASE_TO_NIL(tableView);
    [super dealloc];
}

-(UITableView *)tableView {
//    NSLog(@"Asset[Photo]: TableView - init");

    if (tableView==nil)
    {
        assets = [[NSMutableArray alloc] init];
        tableView = [[UITableView alloc] initWithFrame:[self frame]];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = 79.0f;
				tableView.scrollsToTop = YES;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        tableView.backgroundColor = [UIColor colorWithRed:0.9f
                                                    green:0.9f
                                                     blue:0.9f
                                                    alpha:1.0f];
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
                if (filter == @"photo") {
                    [group setAssetsFilter:[ALAssetsFilter allPhotos]];
                }
                else if (filter == @"video") {
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
                        
                        [assets addObject:dic];
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
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[assets objectAtIndex:button.tag]];

    if (![[dic objectForKey:@"selected"] isEqualToString:@"true"]) {
        NSLog(@"Asset[Photo]: CLICK - Selected");
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
    static NSString *CellIdentifier = @"AssetPickerPhotoRow";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    // Configure the cell...
    NSUInteger firstPhotoInCell = indexPath.row * 4;
    NSUInteger lastPhotoInCell  = firstPhotoInCell + 4;
    
    if (assets.count <= firstPhotoInCell) {
//        NSLog(@"We are out of range, asking to start with photo %d but we only have %d", firstPhotoInCell, assets.count);
        return nil;
    }
    
    NSUInteger currentPhotoIndex = 0;
    NSUInteger lastPhotoIndex = MIN(lastPhotoInCell, assets.count);
    for ( ; firstPhotoInCell + currentPhotoIndex < lastPhotoIndex ; currentPhotoIndex++) {
        NSDictionary *dic = [assets objectAtIndex:firstPhotoInCell + currentPhotoIndex];
        
//        NSLog(@"current: %d %@", firstPhotoInCell + currentPhotoIndex, dic);

        // Thumbnail
        UIImage *thumbnail = [dic objectForKey:@"thumbnail"];
        UIImageView *thumbView = [[UIImageView alloc] initWithImage:thumbnail];

        
        // Button
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = firstPhotoInCell + currentPhotoIndex;

        NSString *resourceurl = [[NSBundle mainBundle] resourcePath];
        NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/modules/%@/%@", resourceurl, @"com.oxgcp.assetpicker", @"Overlay.png"]];
        UIImage *overlayImage = [UIImage imageWithContentsOfFile:[url path]];
        [button setImage:overlayImage forState:UIControlStateSelected];
        [button setSelected:[[dic objectForKey:@"selected"] isEqualToString:@"true"]];

        [button addTarget:self action:@selector(selectPhoto:) forControlEvents:UIControlEventTouchUpInside];

        
        // Frame
        CGRect frame = button.frame;
        frame.size = CGSizeMake(75, 75);
        frame.origin.y = 4;
        frame.origin.x = (currentPhotoIndex * (75 + 4)) + 4;
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
    return ceil((float)assets.count / 4); // there are four photos per row.
}


@end
