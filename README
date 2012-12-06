OXGAssetPicker
==============
It's ALAsset Picker For Titanium.  
OXGAssetPicker Support EXIF

![Albums](https://github.com/hiphapis/OXGAssetsPicker/blob/master/screenshots/albums.png?raw=true)
![Photos](https://github.com/hiphapis/OXGAssetsPicker/blob/master/screenshots/photos.png?raw=true)

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
			backgroundColor:'white',
	});
	albumWin.add(album);
	album.addEventListener('album:selected', function(ae) {
			console.log(ae);

			var photoWin = Titanium.UI.createWindow({ title: ae.groupName });
			var photo = OXGAssetsPicker.createPhotoView({
					groupName: ae.groupName, // load all photos If you remove property of groupName
					filter: "photo", // or "video", "all"
					top:0,
					left:0,
					width:320,
					height:460,
					backgroundColor:'white',
					multiple: true,
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
			backgroundColor:'white',
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
			backgroundColor:'white',
	});
	photo.addEventListener('photo:selected', function(pe) {
		console.log(pe);
	});
	win.add(photo);

### Property
- groupName: (optional)
- filter: (optional) photo, video, all

### Return
- image
- index
- meta
 - exif
- selected
- url
