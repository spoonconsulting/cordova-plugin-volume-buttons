var cordova = require('cordova');
var exec = require('cordova/exec');

var volumeEventHandler = cordova.addWindowEventHandler('volumebuttonslistener');
volumeEventHandler.onHasSubscribersChange = function() {
	if (volumeEventHandler.numHandlers === 1) {
		exec(function() {
			cordova.fireWindowEvent('volumebuttonslistener', null);
		}, function(e) {
			console.log("CDVVolumeButtons error", e);
		}, 'CDVVolumeButtons', 'start', []);
	} else if (volumeEventHandler.numHandlers === 0) {
		exec(null, null, 'CDVVolumeButtons', 'stop', []);
	}
}
