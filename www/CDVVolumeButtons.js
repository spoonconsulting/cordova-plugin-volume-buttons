var cordova = require('cordova');
var exec = require('cordova/exec');
var channel = require('cordova/channel');

var VolumeButtons = function() {
	this.type = "unknown";
}

VolumeButtons.prototype.getInfo = function (successCallback, errorCallback) {
	exec(successCallback, errorCallback, 'CDVVolumeButtons', 'start', []);
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
