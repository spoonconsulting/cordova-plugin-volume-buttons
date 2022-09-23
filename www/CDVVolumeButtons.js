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
var timerId = null;
var timeout = 500;

channel.createSticky('onCordovaConnectionReady');
channel.waitForInitialization('onCordovaConnectionReady');

channel.onCordovaReady.subscribe(function () {
	volumeButtons.getInfo(function() {
		timerId = setTimeout(function () {
			cordova.fireDocumentEvent("volumebuttonslistener");
		}, timeout);
	}, function(e) {
		if (timerId !== null) {
			clearTimeout(timerId);
			timerId = null;
		}
		console.log("CDVVolumeButtons error: " + e);
	});
	if (channel.onCordovaConnectionReady.state !== 2) {
		channel.onCordovaConnectionReady.fire();
	}
});

module.exports = volumeButtons;
