var cordova = require('cordova');
var exec = require('cordova/exec');
var channel = require('cordova/channel');

var VolumeButtons = function() {}

VolumeButtons.prototype.getInfo = function (successCallback, errorCallback) {
    var volumeEventHandler = cordova.addDocumentEventHandler('volumebuttonslistener');
    volumeEventHandler.onHasSubscribersChange = function() {
        if (volumeEventHandler.numHandlers === 1) {
            exec(successCallback, errorCallback, 'CDVVolumeButtons', 'start', []);
        } else if (volumeEventHandler.numHandlers === 0) {
            exec(null, null, 'CDVVolumeButtons', 'stop', []);
        }
    }
};

var volumeButtons = new VolumeButtons();

channel.createSticky('onCordovaConnectionReady');
channel.waitForInitialization('onCordovaConnectionReady');

channel.onCordovaReady.subscribe(function () {
	volumeButtons.getInfo(function(info) {
        cordova.fireDocumentEvent("volumebuttonslistener", info)
	}, function(e) {
		console.log("CDVVolumeButtons error: " + e);
	});
	if (channel.onCordovaConnectionReady.state !== 2) {
		channel.onCordovaConnectionReady.fire();
	}
});

module.exports = volumeButtons;
