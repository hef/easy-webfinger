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

Example Response (formatted):

```
{
  "subject": "acct:my-user-name@example.com",
  "links": [
    {
      "rel": "http://openid.net/specs/connect/1.0/issuer",
      "href": "https://auth.example.com"
    }
  ]
}
```

# Purpose

[Tailscale](https://tailscale.com/) needs a webfinger service to [sign up](https://login.tailscale.com/start/oidc) with [OIDC](https://tailscale.com/kb/1240/sso-custom-oidc). This project satisfies that requirement for very little effort.