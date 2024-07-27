FROM --platform=$BUILDPLATFORM rust:1.80.0 AS chef
RUN apt-get update && apt-get install -y clang curl llvm lld musl-tools gcc-multilib g++-multilib
RUN rustup target add aarch64-unknown-linux-musl
RUN rustup target add x86_64-unknown-linux-musl
RUN cargo install cargo-chef 
WORKDIR /app

FROM --platform=$BUILDPLATFORM chef AS planner
COPY . .
RUN cargo chef prepare --recipe-path recipe.json

FROM --platform=$BUILDPLATFORM chef AS builder
ARG TARGETARCH
ARG CARGO_PROFILE="release"
ENV CC_aarch64_unknown_linux_musl=clang
ENV AR_aarch64_unknown_linux_musl=llvm-ar
ENV CARGO_TARGET_AARCH64_UNKNOWN_LINUX_MUSL_RUSTFLAGS="-Clink-self-contained=yes -Clinker=rust-lld"
ENV CC_x86_64_unknown_linux_musl=clang
ENV AR_x86_64_unknown_linux_musl=llvm-ar
ENV CARGO_TARGET_X86_64_UNKNOWN_LINUX_MUSL_RUSTFLAGS="-Clink-self-contained=yes -Clinker=rust-lld"
COPY --from=planner /app/recipe.json recipe.json
RUN echo ${TARGETARCH} | sed s/arm64/aarch64/ | sed s/amd64/x86_64/ > /tmp/targetarch
RUN cargo chef cook --profile ${CARGO_PROFILE} --target=`cat /tmp/targetarch`-unknown-linux-musl --recipe-path recipe.json
COPY . .
RUN cargo build --bin easy-webfinger --profile ${CARGO_PROFILE} --target=`cat /tmp/targetarch`-unknown-linux-musl
RUN mkdir -p /${TARGETARCH}
RUN cp /app/target/`cat /tmp/targetarch`-unknown-linux-musl/${CARGO_PROFILE}/easy-webfinger /${TARGETARCH}/easy-webfinger

FROM scratch AS runtime
LABEL org.opencontainers.image.source = "https://github.com/hef/easy-webfinger"
ARG TARGETARCH
EXPOSE 3000
COPY --from=builder /${TARGETARCH}/easy-webfinger /easy-webfinger
CMD ["/easy-webfinger"]