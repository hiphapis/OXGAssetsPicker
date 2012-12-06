// This is a test harness for your module
// You should do something interesting in this harness 
// to test out the module and to provide instructions 
// to users on how to use it by example.

var win = Ti.UI.createWindow({});

var albumWin = Ti.UI.createWindow({ title: "Albums" });
var nav = Titanium.UI.iPhone.createNavigationGroup({ window: albumWin });
win.add(nav);

// TODO: write your module tests here
var assetpicker = require('com.oxgcp.assetpicker');
Ti.API.info("module is => " + assetpicker);

var album = assetpicker.createAlbumView({
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
		var photo = assetpicker.createPhotoView({
				groupName: ae.groupName,
				filter: "photo",
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
