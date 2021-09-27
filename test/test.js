const Driver = require("./helpers/Driver");
const Client = require("./helpers/Client");
const capabilities = require("./capabilities");
const env = require("./utils/env");
const { devices } = require("./helpers/enums");

const currentCapabilities = capabilities[env.device];

if (!currentCapabilities) {
  throw new Error("No device capability found in the enviorment variables");
}

let client = new Client(currentCapabilities);

beforeAll(async () => {
  client = Driver.fromCapabilites(currentCapabilities);
});

describe("Flutter Client SDK", () => {
  describe("Registration", () => {
    it("Should register with FIDO2", async () => {
      console.log(client);
      expect("wowow").toEqual("wowow");
    });
  });
});
