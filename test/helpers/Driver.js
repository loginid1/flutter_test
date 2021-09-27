const wdio = require("webdriverio");

class Driver {
  static async fromCapabilites(options) {
    const driver = await wdio.remote(options);
    return new Driver(driver);
  }

  constructor(driver) {
    this.driver = driver;
  }
}

module.exports = Driver;
