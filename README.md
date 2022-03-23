# flutter_test

This app is used for testing the flutter SDK and is not intended for production use. The following changes will need to be made if aiming for a production based application:

1. Service token generation should be obtained from a server.
2. JWT verification should be done when obtained from a API call. This should also be done at the server.
3. No hardcoded password.

## .env Example

This test app needs a `.env` file at the root of the directory.

```
PRIVATE_BASE_URL=https://bb3066a0-aa5b-12ab-8163-ffadde12ade1.usw1.loginid.io
PRIVATE_CLIENT_ID=AltgcRa_ISed7g3ztz2YdHqdqNkFJm2GfXhYQvf8KdAm5e0u8xGxEXSmjKQTdkmOfZLx_xZ9Qu89aZKKfHrDtA
PUBLIC_BASE_URL=https://2e3c7a60-1f21-11ec-b42a-bb8e0fc28366.usw1.loginid.io
PUBLIC_CLIENT_ID=TAfLalifSCT2Wvs_Nhnxidvf2jrNXNl__Vnt4fgNB-X_6RTrRvKTSWxaIqCn-aLsS2-LUsB6Y_TJTZ7jV536DA==
PRIVATE_KEY="-----BEGIN PRIVATE KEY-----\nMIGH...............83qbPsk7dR+T70V2lV2n8\n-----END PRIVATE KEY-----"
```

- `PRIVATE_CLIENT_ID` should have an attached credential and assumes that it is associated with `PRIVATE_KEY`

## How It Works

Toggle the `Credential` switch once and when active it will use the private based variables. Toggle it again and it will use the public ones instead.

_NOTE_: Toggling the switch will have to be done at least once to configure the SDK.

You can also copy and paste the `base_url` and `client_id`(`api_key`) directly into the UI instead and press `Configure` to set up the sdk.
