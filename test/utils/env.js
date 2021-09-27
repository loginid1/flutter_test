require("dotenv").config({ path: "../.env" });

const variables = {
  device: process.env.DEVICE || "",
};

module.exports = variables;
