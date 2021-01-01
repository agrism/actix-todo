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

### Run db migrations

```bash
DATABASE_URL=postgres://actix:actix@localhost:5432/actix diesel migration run
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
Document Length:        34 bytes

Concurrency Level:      30
Time taken for tests:   40.559 seconds
Complete requests:      100000
Failed requests:        0
Keep-Alive requests:    100000
Total transferred:      16600000 bytes
HTML transferred:       3400000 bytes
Requests per second:    2465.57 [#/sec] (mean)
Time per request:       12.168 [ms] (mean)
Time per request:       0.406 [ms] (mean, across all concurrent requests)
Transfer rate:          399.69 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    0   0.0      0       2
Processing:     2   12  11.7     10    1025
Waiting:        2   12  11.7     10    1024
Total:          2   12  11.7     10    1025

Percentage of the requests served within a certain time (ms)
  50%     10
  66%     12
  75%     13
  80%     14
  90%     18
  95%     25
  98%     35
  99%     40
 100%   1025 (longest request)

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
Document Length:        39 bytes

Concurrency Level:      30
Time taken for tests:   56.163 seconds
Complete requests:      100000
Failed requests:        0
Keep-Alive requests:    100000
Total transferred:      17100000 bytes
Total body sent:        19500000
HTML transferred:       3900000 bytes
Requests per second:    1780.52 [#/sec] (mean)
Time per request:       16.849 [ms] (mean)
Time per request:       0.562 [ms] (mean, across all concurrent requests)
Transfer rate:          297.33 [Kbytes/sec] received
                        339.06 kb/s sent
                        636.40 kb/s total

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    0   0.0      0       2
Processing:     3   17  10.0     13      86
Waiting:        3   17  10.0     13      86
Total:          3   17  10.0     13      86

Percentage of the requests served within a certain time (ms)
  50%     13
  66%     16
  75%     18
  80%     20
  90%     33
  95%     41
  98%     47
  99%     51
 100%     86 (longest request)

```