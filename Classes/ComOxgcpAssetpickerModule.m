/**
 * Your Copyright Here
 *
 * Appcelerator Titanium is Copyright (c) 2009-2010 by Appcelerator, Inc.
 * and licensed under the Apache Public License (version 2)
 */
#import "ComOxgcpAssetpickerModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"

#import "ComOxgcpAssetpickerAlbumView.h"
#import "ComOxgcpAssetpickerPhotoView.h"

@implementation ComOxgcpAssetpickerModule

#pragma mark Internal

// this is generated for your module, please do not change it
-(id)moduleGUID
{
	return @"005b2817-0a3b-4aee-ad34-dd8ac32e5cf7";
}

// this is generated for your module, please do not change it
-(NSString*)moduleId
{
	return @"com.oxgcp.assetpicker";
}

#pragma mark Lifecycle

-(void)startup
{
	// this method is called when the module is first loaded
	// you *must* call the superclass
	[super startup];
	
	NSLog(@"[INFO] %@ loaded",self);
}

-(void)shutdown:(id)sender
{
	// this method is called when the module is being unloaded
	// typically this is during shutdown. make sure you don't do too
	// much processing here or the app will be quit forceably
	
	// you *must* call the superclass
	[super shutdown:sender];
}

#pragma mark Cleanup 

-(void)dealloc
{
	// release any resources that have been retained by the module
	[super dealloc];
}

#pragma mark Internal Memory Management

-(void)didReceiveMemoryWarning:(NSNotification*)notification
{
	// optionally release any resources that can be dynamically
	// reloaded once memory is available - such as caches
	[super didReceiveMemoryWarning:notification];
}

- (UIView *)singlePicker:(id)args {
    
    
	NSLog(@"=============");
    ENSURE_UI_THREAD_1_ARG(args);
    ENSURE_SINGLE_ARG(args,NSDictionary);
	NSLog(@"%@", args);
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
//    (UIView *)[[ComOxgcpAssetpickerAlbumView alloc] singlePicker:args];
    
    return view;
}


@end
