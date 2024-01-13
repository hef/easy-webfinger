# easy-webfinger

A simple to configure webfinger server returning a oidc issuer. 

Only 1 feature is supported: returing the same oidc issuer for any queried "acct" (email address).

Set the issuer with the `EASYWEBFINGER_ISSUER` environment variable.

## Example

Running the server:

```
docker run -p 3000:3000 -E EASYWEBFINGER_ISSUER=https://auth.example.com ghcr.io/hef/easy-webfinger:latest
```

Checking the response

```
curl -v https://localhost:3000/.well-known/webfinger?resource=acct:my-ser-name@example.com
```