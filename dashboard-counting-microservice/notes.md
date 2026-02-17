docker run [OPTIONS] IMAGE [COMMAND] [ARG...]
Flag	Name	Function
-d	Detach	Runs the container in the background (so it doesn't lock up your terminal).
-it	Interactive + TTY	Allows you to interact with the container (essential for getting inside a shell).
-p	Publish Port	Maps a port on your computer to a port inside the container (-p host:container).
-v	Volume	Mounts a folder on your computer to a folder inside the container (-v host_path:container_path).
-e	Env Variable	Sets an environment variable inside the container.
--name	Name	Assigns a specific name to the container (otherwise Docker generates a random one like jolly_hopper).
--rm	Remove	Automatically deletes the container when it stops (great for temporary tasks).


docker network [COMMAND]
Command	Usage	Description
ls	docker network ls	List all networks currently available on your machine.
create	docker network create my-net	Create a new custom network (crucial for allowing containers to talk to each other).
inspect	docker network inspect my-net	View details about a network (IP ranges, connected containers).
connect	docker network connect my-net my-container	Attach a running container to a network.
rm	docker network rm my-net	Remove a network (must disconnect containers first).

docker network create --subnet=192.168.199.0/24 demo-network

docker run -d --rm \
  --name dashboard-api \
  --network demo-network \
  --ip 192.168.199.110 \
  -e COUNTING_SERVICE_URL="http://counting-api:9001" \
  -p 9002:9002 \
  dashboard

docker run -d --rm \
  --name counting-api \
  --network demo-network \
  --ip 192.168.199.111 \
  -p 9001:9001 \
  counting

docker run -d --rm \
  --name my-consul \
  --network demo-network \
  -p 8500:8500 \
  -p 8600:8600/tcp \
  -p 8600:8600/udp \
  -v ./consul-config:/consul-config \
  -config-dir ./consul-config
  hashicorp/consul:latest

docker run -d --rm \
  --name my-consul \
  --network demo-network \
  -p 8500:8500 \
  -p 8600:8600/tcp \
  -p 8600:8600/udp \
  -v "$(pwd)/consul-config:/consul/config" \
  hashicorp/consul:latest \
  agent -dev -client=0.0.0.0 -config-dir=/consul/config
 


  docker network rm demo-network

  docker exec -it <container_name> ip addr show

  docker network create app-network
docker run -d --rm --name counting-service --network demo-network -p 9001:9001 counting
docker run -d --rm --name dashboard-service --network demo-network -p 9002:9002 dashboard


### Register Dashboard service onto consul 
curl -X PUT http://localhost:8500/v1/agent/service/register \
  -H "Content-Type: application/json" \
  -d @dashboard-1.json

  ### Register counting service onto consul 
curl -X PUT http://localhost:8500/v1/agent/service/register \
  -H "Content-Type: application/json" \
  -d @counting-1.json

docker ps --filter name=my-consul --format "{{.Ports}}"

docker ps -a --format "{{.Names}} {{.Networks}}" | grep -E "consul|counting|dashboard"

docker exec my-consul dig @localhost -p 8600 dashboard.service.consul 2>/dev/null || docker exec my-consul nslookup -port=8600 dashboard.service.consul localhost 2>/dev/null || echo "No DNS tools in consul container, trying consul CLI"; docker exec my-consul consul catalog services 2>/dev/null

docker rm -f my-consul && docker run -d --rm --name my-consul --network demo-network -p 8500:8500 -p 8600:8600/udp -p 8600:8600/tcp hashicorp/consul agent -dev -client 0.0.0.0

docker stop $(docker ps -q)

🚀 Run the Consul DNS Setup

# 1. Stop existing containers
docker stop my-consul
docker rm my-consul

# 2. Navigate to your directory
cd "/home/test/Desktop/consul with docker"

# 3. Start everything with docker-compose
docker-compose -f docker-compose-consul-dns.yml up -d

# 4. Check status
docker-compose -f docker-compose-consul-dns.yml ps
That's it! The docker-compose file will:

✅ Create the network (192.168.199.0/24)
✅ Start Consul
✅ Start counting-service
✅ Start dashboard
✅ Automatically register services with Consul
✅ Configure DNS to go through Consul
🧪 After Starting, Test It

# View logs
docker-compose -f docker-compose-consul-dns.yml logs -f

# Or run the test script
./test-consul-dns.sh
🌐 Access Points
Dashboard UI: http://localhost:8080
Consul UI: http://localhost:8500
Counting Service: http://localhost:9001
Want me to run these commands for you?

