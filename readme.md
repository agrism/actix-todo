### Pre-work for Mac OS

```bash
brew tap SergioBenitez/osxct

brew install FiloSottile/musl-cross/musl-cross

rustup target add x86_64-unknown-linux-musl
```

### Usage
```bash
# Copy example .env file
cp .env.example .env

# Install diesel
cargo install diesel_cli --no-default-features --features postgres
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

#### 1. Status

```bash
curl --request GET http://0.0.0.0:8080
```

#### 1.1 Response body:

```json
{
  "status": "Up"
}
```

#### 2. get Todos

```bash
curl --request POST http://0.0.0.0:8080/todos
```

#### 2.1. Response body:

```json
[
  {
    "id": 1,
    "title": "Grocery list"
  },
  ...
]
```

#### 3. Get single todo list

```bash
curl --request POST http://0.0.0.0:8080/todos/1
```

#### 3.1. Response body:

```json
{
  "id": 1,
  "title": "Grocery list"
}
```

#### 4. Create todo list

```bash
curl --header "Content-Type: application/json" \
  --request POST --data '{"title":"New List"}' \
  http://0.0.0.0:8080/todos
```

#### 4.1. Response body:

```json
{
  "id": 1,
  "title": "New List"
}
```

#### 5. Get items of the todo list

```bash
curl --request POST http://0.0.0.0:8080/todos/1/items
```

#### 5.1. Response body:

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

#### 6. Get single item of the list

```bash
curl --request POST http://0.0.0.0:8080/todos/1/items/1
```

#### 6.1. Response body:

```json
{
  "id": 1,
  "list_id": 1,
  "title": "Beer",
  "checked": false
}
```

#### 7. Create todo list item

```bash
curl --header "Content-Type: application/json" \
  --request POST --data '{"title":"Socks"}' \
  http://0.0.0.0:8080/todos/1/items
```

#### 7.1. Response body:

```json
{
  "title": "Socks"
}
```

#### 8. Check todo item as done

```bash
curl --request PUT http://0.0.0.0:8080/todos/1/items/1
```

#### 8.1. Response body:

```json
{
  "result": true
}
```

# Benchmarks

### 1. Read test

```bash
ab -n 100000 -k -c 30 -q http://0.0.0.0:8080/todos/1
```

### 1.1. Result:

```bash
This is ApacheBench, Version 2.3 <$Revision: 1879490 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking 0.0.0.0 (be patient).....done


Server Software:        
Server Hostname:        0.0.0.0
Server Port:            8080

Document Path:          /todos/1
Document Length:        25 bytes

Concurrency Level:      30
Time taken for tests:   37.379 seconds
Complete requests:      100000
Failed requests:        0
Keep-Alive requests:    100000
Total transferred:      15700000 bytes
HTML transferred:       2500000 bytes
Requests per second:    2675.30 [#/sec] (mean)
Time per request:       11.214 [ms] (mean)
Time per request:       0.374 [ms] (mean, across all concurrent requests)
Transfer rate:          410.18 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    0   0.0      0       1
Processing:     2   11   7.4      9      63
Waiting:        2   11   7.4      9      63
Total:          2   11   7.4      9      63

Percentage of the requests served within a certain time (ms)
  50%      9
  66%     11
  75%     13
  80%     14
  90%     20
  95%     29
  98%     35
  99%     39
 100%     63 (longest request)

```

### 2. Write test

```bash
ab -p benchmark-post.json -T application/json -n 100000 -k -c 30 -q http://0.0.0.0:8080/todos
```

### 2.1. Result:

```bash
This is ApacheBench, Version 2.3 <$Revision: 1879490 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking 0.0.0.0 (be patient).....done


Server Software:        
Server Hostname:        0.0.0.0
Server Port:            8080

Document Path:          /todos
Document Length:        36 bytes

Concurrency Level:      30
Time taken for tests:   46.717 seconds
Complete requests:      100000
Failed requests:        99104
   (Connect: 0, Receive: 0, Length: 99104, Exceptions: 0)
Keep-Alive requests:    100000
Total transferred:      16989312 bytes
Total body sent:        19500000
HTML transferred:       3789312 bytes
Requests per second:    2140.54 [#/sec] (mean)
Time per request:       14.015 [ms] (mean)
Time per request:       0.467 [ms] (mean, across all concurrent requests)
Transfer rate:          355.14 [Kbytes/sec] received
                        407.62 kb/s sent
                        762.76 kb/s total

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    0   0.0      0       2
Processing:     2   14  10.8     10      93
Waiting:        2   14  10.8     10      93
Total:          2   14  10.8     10      93

Percentage of the requests served within a certain time (ms)
  50%     10
  66%     12
  75%     14
  80%     16
  90%     35
  95%     41
  98%     46
  99%     49
 100%     93 (longest request)

```