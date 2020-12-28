### Pre-work for Mac OS

```bash
brew tap SergioBenitez/osxct

brew install FiloSottile/musl-cross/musl-cross

rustup target add x86_64-unknown-linux-musl
```

### build  release

```bash
TARGET_CC=x86_64-linux-musl-gcc \
RUSTFLAGS="-C linker=x86_64-linux-musl-gcc" \
cargo build --release --target=x86_64-unknown-linux-musl
```

### run docker

```bash
docker-compose run
```

### Install diesel

```bash
cargo install diesel_cli --no-default-features --features postgres
```

### Run db migrations

```bash
DATABASE_URL=postgres://actix:actix@localhost:5432/actix diesel migration run
```

### enjoy

```
http://0.0.0.0:8080
```

### Routes

1. Status

```api
GET /
```

Response body:

```json
{
  "status": "Up"
}
```

2. get Todos

```bash
curl --request POST http://0.0.0.0:8080/todos
```

Response body:

```json
[
  {
    "id": 1,
    "title": "Grocery list"
  },
  ...
]
```

3. Get single todo list

```bash
curl --request POST http://0.0.0.0:8080/todos/1
```

Response body:

```json
{
  "id": 1,
  "title": "Grocery list"
}
```

4. Create todo list

```bash
curl --header "Content-Type: application/json" \
  --request POST --data '{"title":"New List"}' \
  http://0.0.0.0:8080/todos
```

Response body:

```json
{
  "id": 1,
  "title": "New List"
}
```

5. Get items of the todo list

```bash
curl --request POST http://0.0.0.0:8080/todos/1/items
```

Response body:

```json
[
  {
    "id": 1,
    "list_id": 1,
    "title": "Beer",
    "checked": true
  },
  {
    "id": 1,
    "list_id": 2,
    "title": "Water",
    "checked": false
  }
]
```

6. Get single item of the list

```bash
curl --request POST http://0.0.0.0:8080/todos/1/items/1
```

Response body:

```json
{
  "id": 1,
  "list_id": 1,
  "title": "Beer",
  "checked": false
}
```
7. Create todo list item
```bash
curl --header "Content-Type: application/json" \
  --request POST --data '{"title":"Socks"}' \
  http://0.0.0.0:8080/todos/1/items
```
Response body:

```json
{
  "title": "Socks"
}
```
8. Check todo item as done
```bash
curl --request PUT http://0.0.0.0:8080/todos/1/items/1
```
Response body:

```json
{
  "result": true
}
```