#!/bin/sh
#

docker network create --driver bridge performance-network
docker run -d --name PROMETHEUS --hostname PROMETHEUS -p 9090:9090 --network performance-network -t subrock/rocky-prometheus
docker run -d --name GRAFANA --hostname GRAFANA -p 9091:3000 --network performance-network -t subrock/rocky-grafana
docker run -d --name INFLUXDB --hostname INFLUXDB -p 8086:8086 -e DOCKER_INFLUXDB_INIT_MODE=setup -e DOCKER_INFLUXDB_INIT_USERNAME=admin -e DOCKER_INFLUXDB_INIT_PASSWORD=admin --network performance-network -t subrock/rocky-influxdb

docker run --name CONTROLLER --hostname CONTROLLER --network performance-network -d -t subrock/rocky-jmeter:controller
docker run --name WORKER-1 --hostname WORKER-1 --network performance-network -d -t subrock/rocky-jmeter:worker
docker run --name WORKER-2 --hostname WORKER-2 --network performance-network -d -t subrock/rocky-jmeter:worker
docker run --name WORKER-3 --hostname WORKER-3 --network performance-network -d -t subrock/rocky-jmeter:worker

docker exec -it CONTROLLER sed -i s/WORKER-1/WORKER-1,WORKER-2,WORKER-3/ jmeter.properties
#docker exec -it CONTROLLER vi jmeter.properties


#read -p "Press enter to continue." a
echo "Sleeping 90 seconds..."
sleep 90

#echo | x-www-browser https://github.com/subrock/rocky-performance 1> /dev/null
echo | x-www-browser http://localhost:9091 1> /dev/null
read -p "Press enter to continue." a

#echo | x-www-browser http://localhost:9091/d/a5b319df-d2c2-4b37-947a-b44896c720b4/apache-jmeter-dashboard?orgId=1&refresh=5s 1> /dev/null

sh -c 'sleep 45 && echo | x-www-browser http://localhost:9091/d/a5b319df-d2c2-4b37-947a-b44896c720b4/apache-jmeter-dashboard?orgId=1&refresh=5s' 1> /dev/null

docker exec -it CONTROLLER /usr/local/bin/rocky-jmeter-run install_test_script.jmx 
