# cordova-plugin-volume-buttons

Cordova plugin that allows to control Volume Buttons on iOS for different actions.

## Installation

```
cordova plugin add https://github.com/spoonconsulting/cordova-plugin-volume-buttons.git
ionic cordova plugin add https://github.com/spoonconsulting/cordova-plugin-volume-buttons.git
```

## Usage

```
document.addEventListener("volumebuttonslistener", action, false);
// Can be used for different actions(Example: For capturing image)
function action() {
  console.log("Hello");
}
```
