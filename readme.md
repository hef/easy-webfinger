# easy-webfinger

A simple to configure webfinger server returning a single oidc issuer. 

Set the issuer with the `EASYWEBFINGER_ISSUER` environment variable.

## Example

Running the server:

```
docker run -e EASYWEBFINGER_ISSUER=https://auth.example.com -p 3000:3000 ghcr.io/hef/easy-webfinger:latest
```

Checking the response

```
curl http://localhost:3000/.well-known/webfinger?resource=acct:my-user-name@example.com
```