var win = Ti.UI.createWindow({});

var albumWin = Ti.UI.createWindow({ title: "Albums" });
var nav = Titanium.UI.iPhone.createNavigationGroup({ window: albumWin });
win.add(nav);

var OXGAssetsPicker = require('com.oxgcp.assetspicker');
Ti.API.info("module is => " + OXGAssetsPicker);

var album = OXGAssetsPicker.createAlbumView({
		top:0,
		left:0,
		width:Ti.UI.FILL,
		height:Ti.UI.FILL,
		backgroundColor:'#ffffff',
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
       backgroundColor:'#ffffff',
       sort:"recent",
       multiple: true,
   });
   photoWin.add(photo);
   photo.addEventListener('photo:selected', function(pe) {
     photo.selectedPhotos = [1,2];
        
     // console.log(pe);
   });
   
   
   nav.open(photoWin, { animated:true });
});

win.open();