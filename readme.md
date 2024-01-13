# easy-webfinger

A simple to configure webfinger server returning a oidc issuer. 

easy-webfinger assumes that all users have the same issuer, so you only need to set the `EASYWEBFINGER_ISSUER` environment variable to the issuer of your oidc provider.  This is usually the url of your oidc proivder.  easy-webfinger does not check that the user exists, and instead just assumes that any queried user exists and returns the configured issuer.

## Usage

```
docker run -p 3000:3000 -E EASYWEBFINGER_ISSUER=https://auth.example.com ghcr.io/hef/easy-webfinger:latest
curl -v https://localhost:3000/.well-known/webfinger?resource=acct:myUserName@example.com
```
