OXGAssetsPicker
==============
It's ALAssets Picker For Titanium.  

Features
--------
- Album View
- Photo View
- Support EXIF
- Click Event Base

Screenshots
-----------
![Albums](https://github.com/hiphapis/OXGAssetsPicker/blob/master/screenshots/albums.png?raw=true)
![Photos](https://github.com/hiphapis/OXGAssetsPicker/blob/master/screenshots/photos.png?raw=true)

Demo
----
You can show Album View & Photo View.  
Follow this code (from example/app.js)

	var win = Ti.UI.createWindow({});

	var albumWin = Ti.UI.createWindow({ title: "Albums" });
	var nav = Titanium.UI.iPhone.createNavigationGroup({ window: albumWin });
	win.add(nav);

	var OXGAssetsPicker = require('com.oxgcp.assetpicker');
	Ti.API.info("module is => " + OXGAssetsPicker);

	var album = OXGAssetsPicker.createAlbumView({
			top:0,
			left:0,
			width:Ti.UI.FILL,
			height:Ti.UI.FILL,
			backgroundColor:'#000fff',
	});
	albumWin.add(album);
	album.addEventListener('album:selected', function(ae) {
			console.log(ae);

			var photoWin = Titanium.UI.createWindow({ title: ae.groupName });
			var photo = OXGAssetsPicker.createPhotoView({
					groupName: ae.groupName, // load all photos If you remove property of groupName
					filter: "photo", // or "video", "all"
					backgroundColor:'#fff000', // set clearColor If you remove property of backgroundColor
					top:0,
					left:0,
					width:320,
					height:460,
					multiple: true,
					limit: 2,
			});
			photoWin.add(photo);
			photo.addEventListener('photo:selected', function(pe) {
				console.log(pe);
			});
		
			nav.open(photoWin, { animated:true });
	});

	win.open();

Run Simulator  
`$ titanium run`  
Help: [Step 0: Setting Up your Module Environment](http://docs.appcelerator.com/titanium/latest/#!/guide/iOS_Module_Development_Guide-section-29004946_iOSModuleDevelopmentGuide-Step0%3ASettingUpyourModuleEnvironment)


If you want Packagin and Distribution Then read it.  
[Step 3: Packaging your Module for Distribution](http://docs.appcelerator.com/titanium/latest/#!/guide/iOS_Module_Development_Guide-section-29004946_iOSModuleDevelopmentGuide-Step3%3APackagingyourModuleforDistribution)


ALBUM
-----
	var win = Ti.UI.createWindow({});
	var album = OXGAssetsPicker.createAlbumView({
			top:0,
			left:0,
			width:Ti.UI.FILL,
			height:Ti.UI.FILL,
			backgroundColor:'#000fff',
	});
	album.addEventListener('album:selected', function(ae) {
		console.log("groupName: " + ae.groupName);
		console.log("numberOfAssets: " + ae.numberOfAssets);
	});
	win.add(album);

### Return
- groupName: return selected group name.
- numberOfAssets : return assets count of selected group.

PHOTO
-----
	var win = Ti.UI.createWindow({});
	var photo = OXGAssetsPicker.createPhotoView({
			top:0,
			left:0,
			width:Ti.UI.FILL,
			height:Ti.UI.FILL,
			backgroundColor:'#fff000',
	});
	photo.addEventListener('photo:selected', function(pe) {
		console.log(pe);
	});
	win.add(photo);

### Property
- groupName: (optional)
- filter: (optional) *all, photo, video
- multiple: (optional) *false, true
- sort: (optional) *nil, recent => nil is created_at asc
- limit: (optional) *nil, 
- selectedPhotos: (optional) *nil => array of selected photo index [1,2,3]

### Return
- image
- index
- meta
 - exif
- selected
- url
