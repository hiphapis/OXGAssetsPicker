/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2012 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "ComOxgcpAssetspickerAlbumView.h"

@implementation ComOxgcpAssetspickerAlbumView

-(void)dealloc {
    RELEASE_TO_NIL(groups);
    RELEASE_TO_NIL(tableView);
    [super dealloc];
}

-(UITableView *)tableView {
    //    NSLog(@"Asset[Album]: TableView: init");
    
    if (tableView==nil)
    {
        groups = [[NSMutableArray alloc] init];
        tableView = [[UITableView alloc] initWithFrame:[self frame]];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = 57.0f;
        tableView.scrollsToTop = YES;
        tableView.backgroundColor = [UIColor colorWithRed:0.9f
                                                    green:0.9f
                                                     blue:0.9f
                                                    alpha:1.0f];
        [self addSubview:tableView];
        
        //        NSLog(@"Asset[Album]: TableView: created");
        
        [self loadGroups];
    }
    return tableView;
}

-(void)frameSizeChanged:(CGRect)frame bounds:(CGRect)bounds {
    if ([self tableView]!=nil) {
        [TiUtils setView:tableView positionRect:bounds];
    }
}

-(void)loadGroups {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        
        ALAssetsLibraryGroupsEnumerationResultsBlock assetGroupEnumerator = ^(ALAssetsGroup *group, BOOL *stop) {
            if (group != nil) {
                if ([group numberOfAssets]) {
                    [groups addObject:group];
                    [[self tableView] reloadData];
                }
            }
        };
        
        ALAssetsLibraryAccessFailureBlock assetGroupEnumberatorFailure = ^(NSError *error) {
            NSString *resultMsg = [NSString stringWithFormat:@"Failed: code=%d", [error code]];
            NSLog(@"Asset[Album]: Failed: %@", resultMsg);
        };
        
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library enumerateGroupsWithTypes:ALAssetsGroupAll
                               usingBlock:assetGroupEnumerator
                             failureBlock:assetGroupEnumberatorFailure];
        
        
        [pool release];
    });
}


///////////////////////////////////////////////////////////////////////////////////
// table delegate
#pragma mark -
#pragma mark Table view data source

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"AssetPickerAlbumRow";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    ALAssetsGroup *group = [groups objectAtIndex:indexPath.row];
    
    
    NSInteger count = [group numberOfAssets];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%d)", [group valueForProperty:ALAssetsGroupPropertyName], count];
    
    [cell.imageView setImage:[UIImage imageWithCGImage:[group posterImage]]];
	[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
	
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return groups.count;
}

#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ALAssetsGroup *group = [groups objectAtIndex:indexPath.row];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[group valueForProperty:ALAssetsGroupPropertyName], @"groupName", [NSNumber numberWithInteger:[group numberOfAssets]], @"numberOfAssets", nil];
    [self.proxy fireEvent:@"album:selected" withObject:dic];
}


@end
