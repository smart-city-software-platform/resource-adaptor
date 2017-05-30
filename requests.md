# Requests with CURL

## Basic City Resource management

* Create resource
> curl -H "Content-Type: application/json" -X POST -d '{"data":{"lat":-23.559616,"lon":-46.731386,"description":"A simple resource in São Paulo","capabilities":["temperature"], "status":"active"}}' http://localhost:3002/components | json_pp

* Update resource
> curl -H "Content-Type: application/json" -X PUT -d '{"data":{"lat":-23.5521216,"lon":-46.932386,"description":"More complex resource","capabilities":["temperature", "humidity", "uv", "pollution"], "status":"active"}}' http://localhost:3002/components/**:uuid**/ | json_pp

## Post context data from city resources

* Post data
> curl -H "Content-Type: application/json" -X POST -d '{"data":{"temperature":[{"value":"12.8","timestamp":"20/08/2016T10:27:40"}], "humidity":[{"value":"100", "timestamp":"02/12/2016T10:27:40"}]}}' http://localhost:3002/components/**:uuid**/data

## Subscribe to receive actuation commands

* Create a resource and Subscribe to receive its actuator commands:
> curl -H "Content-Type: application/json" -X POST -d '{"data":{"lat":-23.559616,"lon":-46.731386,"description":"A simple resource in São Paulo","capabilities":["semaphore"], "status":"active"}}' http://localhost:3002/components | json_pp
> curl -H "Content-Type: application/json" -X POST -d '{"subscription":{"uuid":"0dbdae10-4156-4433-9291-5d261eb0d8eb", "url":"http://myendpoint.com", "capabilities":["semaphore"]}}' http://localhost:3002/subscriptions | json_pp

* Update subscription
> curl -H "Content-Type: application/json" -X PUT -d '{"subscription":{"url":"http://newendpoint.com"}}' http://localhost:3002/subscriptions/**:id** | json_pp

* Get subscription
> curl -H "Content-Type: application/json" http://localhost:3002/subscriptions/**:id** | json_pp

* Get all subscriptions filtering by uuid
> curl http://localhost:3002/subscriptions?uuid=**:uuid** | json_pp

* Delete subscription
> curl -H "Content-Type: application/json" -X DELETE http://localhost:3002/subscriptions/**:id**
