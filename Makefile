# defaul shell
SHELL = /bin/bash

# Rule "help"
.PHONY: help
.SILENT: help
help:
	echo "Use make [rule]"
	echo "Rules:"
	echo ""
	echo "gradleb-entregador     - build application using gradlew wrapper with openjdk version 12 local machine"
	echo ""
	echo "dockerb-entregador     - build application and generate docker image"
	echo ""
	echo "k-start		         - start minikube machine"
	echo "k-stop		         - stop minikube machine"

gradleb-entregador:
	cd ./entregador/ && ./gradlew clean build -Dorg.gradle.java.home=/usr/lib/jvm/java-12-openjdk-amd64/;

dockerb-entregador:
    docker build --force-rm -t entregador:1.0.0 ./entregador/; \

k-setup:
	minikube -p dev-to start --cpus 2 --memory=4098; \
	minikube -p dev-to addons enable ingress; \
	minikube -p dev-to addons enable metrics-server; \
	kubectl create namespace dev-to; \

k-start:
	minikube -p dev-to start;

k-stop:
	minikube -p dev-to stop;
