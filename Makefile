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
	echo "dockerr-rabbitmq       - This will start a RabbitMQ container listening on the default port of 5672. web-browser port 15672 and pluguins: rabbitmq_management rabbitmq_web_dispatch rabbitmq_management_agent"
	echo ""
	echo "k-start		         - start minikube machine"
	echo "k-stop		         - stop minikube machine"

gradleb-entregador:
	cd ./entregador/ && ./gradlew clean build -Dorg.gradle.java.home=/usr/lib/jvm/java-12-openjdk-amd64/;

gradleb-loja:
	cd ./loja/ && ./gradlew clean build -Dorg.gradle.java.home=/usr/lib/jvm/java-12-openjdk-amd64/;

gradleb-transportadora:
	cd ./transportadora/ && ./gradlew clean build -Dorg.gradle.java.home=/usr/lib/jvm/java-12-openjdk-amd64/;

gradleb-all: gradleb-loja gradleb-transportadora gradleb-entregador

dockerb-rabbitmq:
	docker build --force-rm -t rabbitmq:1.0.0 ./queue/;

dockerb-entregador: gradleb-entregador
	docker build --force-rm -t entregador:1.0.0 ./entregador/;

dockerb-loja: gradleb-loja
	docker build --force-rm -t loja:1.0.0 ./loja/;

dockerb-transportadora: gradleb-transportadora
	docker build --force-rm -t transportadora:1.0.0 ./transportadora/;

dockerb-all: dockerb-rabbitmq gradleb-loja gradleb-transportadora gradleb-entregador

compose-build: compose-down gradleb-all
	docker-compose build;

compose-up: compose-down dockerb-all
	docker-compose up;
#	docker-compose up -d rabbitmq; \
#	sleep 40; \
#	docker-compose up -d loja; \
#	sleep 20; \
#	docker-compose up -d transportadora entregador; \

compose-down:
	docker-compose down;

compose-logs:
	docker-compose logs -f -t;

health:
	echo -e "HealthCheck LOJA:\n"; \
	curl -k http://localhost:8080/actuator/health; \
	echo -e "\n"; \
	echo -e "HealthCheck TRANSPORTADORA:\n"; \
	curl -k http://localhost:8081/actuator/health; \
	echo -e "\n"; \
	echo -e "HealthCheck ENTREGADOR:\n"; \
	curl -k http://localhost:8082/actuator/health; \
	echo -e "\n"; \

test-raptorslog:
	while true; do sleep 1; curl -X POST http://localhost:8080/v1/pedido; echo -e '\n';done

rabbitmqrun:
	docker run -d --network minha-rede --hostname rabbitmq --name rabbitmq -p 15672:15672 -p 5671-5672:5671-5672 rabbitmq:1.0.0

lojarun:
	docker run -d --network minha-rede --name loja \
	-e ENV_RABBITMQ_HOST=rabbitmq \
	-e ENV_RABBITMQ_PORT=5672 \
	-e ENV_RABBITMQ_USER=guest \
	-e ENV_RABBITMQ_PASS=guest \
	-e ENV_QUEUE_NAME=raptorslog.queue \
	-e ENV_QUEUE_EXCHANGE=raptorslog.exchange \
	-e ENV_QUEUE_ROUTE_KEY=raptorslog.routingkey \
	--link rabbitmq:rabbitmq \
	-p 8080:8090 loja:1.0.0; \

transportadorarun:
	docker run -d --network minha-rede --name transportadora \
	-e ENV_RABBITMQ_HOST=rabbitmq \
	-e ENV_RABBITMQ_PORT=5672 \
	-e ENV_RABBITMQ_USER=guest \
	-e ENV_RABBITMQ_PASS=guest \
	-e ENV_QUEUE_NAME=raptorslog.queue \
	-e ENV_ENTREGADOR=http://entregador:8070 \
	--link rabbitmq:rabbitmq \
	--link entregador:entregador \
	-p 8081:8080 transportadora:1.0.0; \

entregadorrun:
	docker run -d --network minha-rede --name entregador \
	-p 8082:8070 entregador:1.0.0; \

rabbitmq-delete:
	docker container rm -f rabbitmq;

loja-delete:
	docker container rm -f loja;

transportadora-delete:
	docker container rm -f transportadora;

entregador-delete:
	docker container rm -f entregador;

dockerrmall: rabbitmq-delete loja-delete transportadora-delete entregador-delete

k-setup:
	minikube -p minikube start --cpus 2 --memory=4098; \
	minikube -p minikube addons enable ingress; \
	minikube -p minikube addons enable metrics-server; \
	kubectl create namespace raptorslog; \

k-dashboard:
	minikube -p minikube dashboard;

k-start:
	minikube start;

k-ip:
	minikube -p minikube ip

k-stop:
	minikube stop;

k-getall:
	kubectl -n raptorslog get deploy,pod,rc,svc,ing;

k-build-queue:
	eval $$(minikube -p minikube docker-env) && docker build --force-rm -t rabbitmq:1.0.0 ./queue/;

k-deploy-queue: k-build-queue
	kubectl apply -f kubernetes/queue/;

k-foward-queue:
	kubectl port-forward -n=raptorslog rabbitmq-97c6d77bb-q8m7p 15672:15672;

k-build-entregador: gradleb-entregador
	eval $$(minikube -p minikube docker-env) && docker build --force-rm -t entregador:1.0.0 ./entregador/;

k-deploy-entregador: k-build-entregador
	kubectl apply -f kubernetes/entregador/;

k-build-transportadora: gradleb-transportadora
	eval $$(minikube -p minikube docker-env) && docker build --force-rm -t transportadora:1.0.0 ./transportadora/;

k-deploy-transportadora: k-build-transportadora
	kubectl apply -f kubernetes/transportadora/;