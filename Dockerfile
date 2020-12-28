FROM debian:bullseye-slim
WORKDIR /app
ADD target/x86_64-unknown-linux-musl/release/actix-todo .
CMD ["/app/actix-todo"]
