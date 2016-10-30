# Requests with CURL

* Create resource
> curl -H "Content-Type: application/json" -X POST -d '{"data":{"lat":-23.559616,"lon":-46.731386,"description":"A simple resource in São Paulo","capabilities":["temperature"], "status":"active"}}' http://localhost:3002/components | json_pp

* Update resource
> curl -H "Content-Type: application/json" -X PUT -d '{"data":{"lat":-23.5521216,"lon":-46.932386,"description":"More complex resource","capabilities":["temperature", "humidity", "uv", "pollution"], "status":"active"}}' http://localhost:3002/components/1a89d1c5-81ed-46d0-89fa-dbae20fd4318/ | json_pp

* Post data
> curl -H "Content-Type: application/json" -X POST -d '{"data":{"temperature":[{"val":"12.8","timestamp":"20/08/2016T10:27:40"}], "humidity":[{"value":"100", "timestamp":"02/12/2016T10:27:40"}]}}' http://localhost:3002/components/8a98d61c-a60f-46ea-b8aa-36a33f018aa81/data
