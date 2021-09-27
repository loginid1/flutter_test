const path = require("path");

module.exports = {
  android: {
    path: "/wd/hub",
    port: 4723,
    capabilities: {
      platformName: "Android",
      //deviceName: 'Android',
      app: path.join(
        __dirname,
        "../build/app/outputs/flutter-apk/app-debug.apk"
      ),
      //appPackage: 'io.appium.android.apis',
      //appActivity: '.view.TextFields',
      automationName: "UiAutomator2",
    },
  },
  ios: {
    path: "/wd/hub",
    port: 4723,
    capabilities: {
      platformName: "iOS",
      autoGrantPermissions: "true",
      deviceName: "iPhone 11",
      platformVersion: "14.4",
      udid: "auto",
      app: path.resolve(
        __dirname,
        "../Library/Developer/Xcode/DerivedData/rnlogin-elrztkttwiipsjgzhgpfjgtsetqc/Build/Products/Debug-iphoneos/rnlogin.app"
      ),
      automationName: "XCUITest",
    },
  },
};
