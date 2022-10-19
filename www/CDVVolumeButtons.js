var cordova = require("cordova");
var exec = require("cordova/exec");

getInfo = function (successCallback, errorCallback) {
  var volumeEventHandler = cordova.addDocumentEventHandler(
    "volumebuttonslistener"
  );
  volumeEventHandler.onHasSubscribersChange = function () {
    if (volumeEventHandler.numHandlers === 1) {
      exec(successCallback, errorCallback, "CDVVolumeButtons", "start", []);
    } else if (volumeEventHandler.numHandlers === 0) {
      exec(null, null, "CDVVolumeButtons", "stop", []);
    }
  };
};

getInfo(
  function (info) {
    cordova.fireDocumentEvent("volumebuttonslistener", info);
  },
  function (e) {
    console.log("CDVVolumeButtons error: " + e);
  }
);
