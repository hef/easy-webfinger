#![warn(clippy::unwrap_used)]
#![warn(clippy::expect_used)]
#![warn(clippy::todo)]
#![warn(clippy::panic)]
use std::env;

use axum::{Router, routing::get, Json, extract::Query};
use serde::{Serialize, Deserialize};

#[derive(Serialize)]
struct Link {
    rel: String,
    href: String,
}

#[derive(Serialize)]
struct WebFinger {
    subject: String,
    links: Vec<Link>,
}

#[derive(Deserialize)]
struct Params {
    resource: String,
    //rel: Option<String>,
}

async fn webfinger(params: Query<Params>, issuer: String) -> Json<WebFinger> {

    let  resource = params.0.resource;
    let result = WebFinger {
        subject: resource,
        links: vec![
            Link {
                rel: "http://openid.net/specs/connect/1.0/issuer".to_string(),
                href: issuer,
            },
        ],
    };
    Json(result)
}


#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>>{

    let issuer = env::var("EASYWEBFINGER_ISSUER")?;
    let app = Router::new().route("/.well-known/webfinger", get(move |params: Query<Params>| async move {
        webfinger(params, issuer).await
    }));

    let listener = tokio::net::TcpListener::bind("0.0.0.0:3000").await?;
    axum::serve(listener, app).await?;
    Ok(())
}
