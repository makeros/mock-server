# Simple json mock server nginx with perl module

### Running

```bash
docker run -d -p 80:80 cnam/mock-server
```

### Usage

Write new mock

```bash
curl 127.0.0.1/write -XPOST -d '{"request":{"uri":"test", "method": "POST", "status_code": "418"}, "response": {"body": {"json":"test-data"}}}'
```

#### Mock payload

Field | Description
--- | ---
`request.uri` | The name of the endpoint
`request.method` | Method for which the response mock should be delivered
`request.status_code` | The response status code for endpoint
`response.body` | JSON which will be delivered from the endpoint


Read mock from application

Request

```bash
curl 127.0.0.1/test
```

Response

```json
{
    "json": "test-data"
}
```
