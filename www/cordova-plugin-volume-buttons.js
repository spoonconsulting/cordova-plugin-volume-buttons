var cordova = require('cordova');
var exec = require('cordova/exec');

function handlers() {
	return volumeButtons.channels.buttonsListener.numHandlers;
}

var VolumeButtons = function() {
	this.channels = { buttonsListener:cordova.addWindowEventHandler('volumebuttonslistener') };
	for(var key in this.channels) {
		this.channels[key].onHasSubscribersChange= VolumeButtons.onHasSubscribersChange;
    }
};

VolumeButtons.onHasSubscribersChange = function() {
	if (this.numHandlers === 1 && handlers() === 1) {
		exec(VolumeButtons.volumeButtonsListener, VolumeButtons.errorListener, 'cordova-plugin-volume-buttons', 'start', []);
    } else if (handlers() === 0) {
		exec(null, null, 'cordova-plugin-volume-buttons', 'stop', []);
    }
};

/**
* 	Callback used when the user presses the volume button of the device
*
*	@param {Object} info	keys: signal ['volume-up' or 'volume-down'] 
*/
VolumeButtons.prototype.volumeButtonsListener = function(info) {
	if (info) {
		cordova.fireWindowEvent("volumebuttonslistener", info);
	}
};

VolumeButtons.prototype.errorListener = function(e) {
	console.log("Error initializing cordova-plugin-volume-buttons: " + e);
}

var volumeButtons = new VolumeButtons();
module.exports = volumeButtons;
