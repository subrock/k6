#!/bin/sh
#
docker stop WORKER-1 WORKER-2 WORKER-3 CONTROLLER INFLUXDB GRAFANA PROMETHEUS
#docker rmi subrock/rocky-grafana subrock/rocky-influxdb subrock/rocky-prometheus subrock/rocky-jmeter:controller subrock/rocky-jmeter:worker -f
echo y | docker system prune

