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

gradleb-entregador-RS:
	cd ./entregador-RS/ && ./gradlew clean build -Dorg.gradle.java.home=/usr/lib/jvm/java-12-openjdk-amd64/;

gradleb-entregador-AM:
	cd ./entregador-AM/ && ./gradlew clean build -Dorg.gradle.java.home=/usr/lib/jvm/java-12-openjdk-amd64/;

gradleb-entregador-MG:
	cd ./entregador-MG/ && ./gradlew clean build -Dorg.gradle.java.home=/usr/lib/jvm/java-12-openjdk-amd64/;

gradleb-loja:
	cd ./loja/ && ./gradlew clean build -Dorg.gradle.java.home=/usr/lib/jvm/java-12-openjdk-amd64/;

gradleb-transportadora:
	cd ./transportadora/ && ./gradlew clean build -Dorg.gradle.java.home=/usr/lib/jvm/java-12-openjdk-amd64/;

gradleb-transportadora-v2:
	cd ./transportadora-v2/ && ./gradlew clean build -Dorg.gradle.java.home=/usr/lib/jvm/java-12-openjdk-amd64/;

gradleb-all: gradleb-entregador-RS gradleb-entregador-AM gradleb-entregador-MG gradleb-loja gradleb-transportadora gradleb-transportadora-v2

dockerb-rabbitmq:
	docker build --force-rm -t rabbitmq:1.0.0 ./queue/;

dockerb-entregador-RS: gradleb-entregador-RS
	docker build --force-rm -t entregador-rs:1.0.0 ./entregador-RS/;

dockerb-entregador-AM: gradleb-entregador-AM
	docker build --force-rm -t entregador-am:1.0.0 ./entregador-AM/;

dockerb-entregador-MG: gradleb-entregador-MG
	docker build --force-rm -t entregador-am:1.0.0 ./entregador-MG/;

dockerb-loja: gradleb-loja
	docker build --force-rm -t loja:1.0.0 ./loja/;

dockerb-transportadora: gradleb-transportadora
	docker build --force-rm -t transportadora:1.0.0 ./transportadora/;

dockerb-transportadora-v2: gradleb-transportadora-v2
	docker build --force-rm -t transportadora-v2:1.0.0 ./transportadora-v2/;

dockerb-all: dockerb-rabbitmq dockerb-entregador-RS dockerb-entregador-AM dockerb-entregador-MG gradleb-loja gradleb-transportadora gradleb-transportadora-v2

compose-build: compose-down gradleb-all
	docker-compose build;

compose-up: compose-down dockerb-all
	docker-compose up;
#	docker-compose up -d rabbitmq; \
#	sleep 40; \
#	docker-compose up -d loja; \
#	sleep 20; \
#	docker-compose up -d transportadora entregador;

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
	echo -e "\n";

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
	-p 8080:8090 loja:1.0.0;

transportadorarun:
	docker run -d --network minha-rede --name transportadora \
	-e ENV_RABBITMQ_HOST=rabbitmq \
	-e ENV_RABBITMQ_PORT=5672 \
	-e ENV_RABBITMQ_USER=guest \
	-e ENV_RABBITMQ_PASS=guest \
	-e ENV_QUEUE_NAME=raptorslog.queue \
	-e ENV_ENTREGADOR_RS=http://entregador:8070 \
	-e ENV_ENTREGADOR_AM=http://entregador:8071 \
	-e ENV_ENTREGADOR_MG=http://entregador:8072 \
	--link rabbitmq:rabbitmq \
	--link entregador-rs:entregador-rs \
	--link entregador-am:entregador-am \
	--link entregador-mg:entregador-mg \
	-p 8081:8080 transportadora:1.0.0;

transportadora-v2run:
	docker run -d --network minha-rede --name transportadora-v2 \
	-e ENV_RABBITMQ_HOST=rabbitmq \
	-e ENV_RABBITMQ_PORT=5672 \
	-e ENV_RABBITMQ_USER=guest \
	-e ENV_RABBITMQ_PASS=guest \
	-e ENV_QUEUE_NAME=raptorslog.queue \
	-e ENV_ENTREGADOR_RS=http://entregador:8070 \
	-e ENV_ENTREGADOR_AM=http://entregador:8071 \
	-e ENV_ENTREGADOR_MG=http://entregador:8072 \
	--link rabbitmq:rabbitmq \
	--link entregador-rs:entregador-rs \
	--link entregador-am:entregador-am \
	--link entregador-mg:entregador-mg \
	-p 8081:8080 transportadora-v2:1.0.0;

entregador-RSrun: dockerb-entregador-RS
	docker run -d --network minha-rede --name entregador-rs \
	-p 8082:8070 entregador-rs:1.0.0;

entregador-AMrun: dockerb-entregador-AM
	docker run -d --network minha-rede --name entregador-am \
	-p 8084:8071 entregador-am:1.0.0;

entregador-MGrun: dockerb-entregador-MG
	docker run -d --network minha-rede --name entregador-mg \
	-p 8085:8072 entregador-mg:1.0.0;

rabbitmq-delete:
	docker container rm -f rabbitmq;

loja-delete:
	docker container rm -f loja;

transportadora-delete:
	docker container rm -f transportadora;

transportadora-v2-delete:
	docker container rm -f transportadora-v2;

entregador-RS-delete:
	docker container rm -f entregador-rs;

entregador-AM-delete:
	docker container rm -f entregador-am;

entregador-MG-delete:
	docker container rm -f entregador-mg;

dockerrmall: rabbitmq-delete loja-delete entregador-RS-delete entregador-AM-delete entregador-MG-delete transportadora-delete transportadora-v2-delete

# export ISTIO_HOME=`pwd`/istio-1.2.5
# export PATH=$ISTIO_HOME/bin:$PATH
# istioctl version

k-setup:
	minikube -p minikube start --cpus 2 --memory=8192; \
	minikube -p minikube addons enable ingress; \
	minikube -p minikube addons enable metrics-server; \
	kubectl create namespace raptorslog; \
	kubectl config set-context $$(kubectl config current-context) --namespace=raptorslog;

k-create-namespace:
	kubectl create namespace raptorslog;

k-delete-namespace:
	kubectl delete namespace raptorslog;

k-istio-setup:
	for i in istio-1.2.5/install/kubernetes/helm/istio-init/files/crd*yaml; do kubectl apply -f $$i; done; \
	kubectl apply -f istio-1.2.5/install/kubernetes/istio-demo.yaml;

k-expose-telemetry:
	kubectl apply -f istio-1.2.5/install/kubernetes/grafana-ingress.yaml; \
	kubectl apply -f istio-1.2.5/install/kubernetes/kiali-ingress.yaml; \
	kubectl apply -f istio-1.2.5/install/kubernetes/prometheus-ingress.yaml; \
	kubectl apply -f istio-1.2.5/install/kubernetes/jaeger-ingress.yaml;

#k-inject-istio:
#	kubectl label namespace raptorslog istio-injection=enabled;

k-dashboard:
	minikube -p minikube dashboard;

k-start:
	minikube -p minikube start; \
	kubectl config set-context $$(kubectl config current-context) --namespace=raptorslog;

k-ip:
	minikube -p minikube ip

k-stop:
	minikube stop;

k-getall:
	kubectl -n raptorslog get deploy,rc,rs,pod,svc,ing;

k-build-queue:
	eval $$(minikube -p minikube docker-env) && docker build --force-rm -t rabbitmq:1.0.0 ./queue/;

k-deploy-queue: k-build-queue
	kubectl apply -f kubernetes/queue/policy-istio.yaml
	kubectl apply -f <(istioctl kube-inject -f kubernetes/queue/rabbitmq-deployment.yaml)
	kubectl apply -f kubernetes/queue/rabbitmq-service.yaml
	kubectl apply -f kubernetes/queue/rabbitmq-ingress.yaml
	sleep 30; \
#	kubectl apply -f kubernetes/queue/;

k-delete-queue:
	kubectl delete -f kubernetes/queue/;

k-foward-queue:
	kubectl port-forward -n=raptorslog rabbitmq-97c6d77bb-q8m7p 15672:15672;

k-build-entregador-RS: gradleb-entregador-RS
	eval $$(minikube -p minikube docker-env) && docker build --force-rm -t entregador-rs:1.0.0 ./entregador-RS/;

k-deploy-entregador-RS: k-build-entregador-RS
	kubectl apply -f <(istioctl kube-inject -f kubernetes/entregador-RS/deployment.yaml)
	kubectl apply -f kubernetes/entregador-RS/service.yaml
#	kubectl apply -f kubernetes/entregador-RS/gateway.yaml
#	kubectl apply -f kubernetes/entregador-RS/ingress.yaml
#	kubectl apply -f kubernetes/entregador-RS/;

k-delete-entregador-RS:
	kubectl delete -f kubernetes/entregador-RS/;

k-build-entregador-AM: gradleb-entregador-AM
	eval $$(minikube -p minikube docker-env) && docker build --force-rm -t entregador-am:1.0.0 ./entregador-AM/;

k-deploy-entregador-AM: k-build-entregador-AM
	kubectl apply -f <(istioctl kube-inject -f kubernetes/entregador-AM/deployment.yaml)
	kubectl apply -f kubernetes/entregador-AM/service.yaml
#	kubectl apply -f kubernetes/entregador-AM/gateway.yaml
#	kubectl apply -f kubernetes/entregador-AM/ingress.yaml
#	kubectl apply -f kubernetes/entregador-AM/;

k-delete-entregador-AM:
	kubectl delete -f kubernetes/entregador-AM/;

k-build-entregador-MG: gradleb-entregador-MG
	eval $$(minikube -p minikube docker-env) && docker build --force-rm -t entregador-mg:1.0.0 ./entregador-MG/;

k-deploy-entregador-MG: k-build-entregador-MG
	kubectl apply -f <(istioctl kube-inject -f kubernetes/entregador-MG/deployment.yaml)
	kubectl apply -f kubernetes/entregador-MG/service.yaml
#	kubectl apply -f kubernetes/entregador-MG/gateway.yaml
#	kubectl apply -f kubernetes/entregador-MG/ingress.yaml
#	kubectl apply -f kubernetes/entregador-MG/;

k-delete-entregador-MG:
	kubectl delete -f kubernetes/entregador-MG/;

k-build-transportadora: gradleb-transportadora
	eval $$(minikube -p minikube docker-env) && docker build --force-rm -t transportadora:1.0.0 ./transportadora/;

k-deploy-transportadora: k-build-transportadora
	kubectl apply -f <(istioctl kube-inject -f kubernetes/transportadora/deployment.yaml)
	kubectl apply -f kubernetes/transportadora/service.yaml
#	kubectl apply -f kubernetes/transportadora/gateway.yaml
#	kubectl apply -f kubernetes/transportadora/ingress.yaml
#	kubectl apply -f kubernetes/transportadora/;

k-update-transportadora: k-build-transportadora
	kubectl delete -f kubernetes/transportadora/deployment.yaml; \
	sleep 1; \
	kubectl apply -f <(istioctl kube-inject -f kubernetes/transportadora/deployment.yaml)

k-delete-transportadora:
	kubectl delete -f kubernetes/transportadora/;

k-build-transportadora-v2: gradleb-transportadora-v2
	eval $$(minikube -p minikube docker-env) && docker build --force-rm -t transportadora-v2:1.0.0 ./transportadora-v2/;

k-deploy-transportadora-v2: k-build-transportadora-v2
	kubectl apply -f <(istioctl kube-inject -f kubernetes/transportadora-v2/deployment.yaml)
#	kubectl apply -f kubernetes/transportadora-v2/service.yaml
#	kubectl apply -f kubernetes/transportadora-v2/gateway.yaml
#	kubectl apply -f kubernetes/transportadora-v2/ingress.yaml
#	kubectl apply -f kubernetes/transportadora-v2/;

k-update-transportadora-v2: k-build-transportadora-v2
	kubectl delete -f kubernetes/transportadora-v2/deployment.yaml; \
	sleep 1; \
	kubectl apply -f <(istioctl kube-inject -f kubernetes/transportadora-v2/deployment.yaml)

k-delete-transportadora-v2:
	kubectl delete -f kubernetes/transportadora-v2/;

k-build-loja: gradleb-loja
	eval $$(minikube -p minikube docker-env) && docker build --force-rm -t loja:1.0.0 ./loja/;

k-deploy-loja: k-build-loja
	kubectl apply -f <(istioctl kube-inject -f kubernetes/loja/deployment.yaml)
	kubectl apply -f kubernetes/loja/service.yaml
	kubectl apply -f kubernetes/loja/gateway.yaml
	kubectl apply -f kubernetes/loja/ingress.yaml
#	kubectl apply -f kubernetes/loja/;

k-update-loja: k-build-loja
	kubectl delete -f kubernetes/loja/deployment.yaml; \
	sleep 1; \
	kubectl apply -f <(istioctl kube-inject -f kubernetes/loja/deployment.yaml)

k-delete-loja:
	kubectl delete -f kubernetes/loja/;

k-deployall: k-deploy-loja k-deploy-transportadora k-deploy-transportadora-v2 k-deploy-entregador-RS k-deploy-entregador-AM k-deploy-entregador-MG

k-test-raptorslog:
	while true; do sleep 0.3; curl -X POST http://raptorslog.loja.local/v1/pedido; echo -e '';done

k-deleteall: k-delete-entregador-RS k-delete-entregador-AM k-delete-entregador-MG k-delete-transportadora k-delete-transportadora-v2 k-delete-loja

k-show-istio:
	kubectl get deploy,svc,pod -n istio-system; \

k-routing-transportadora:
	kubectl apply -f kubernetes/route/simple/destination-rule-transportadora-v1-v2.yml;

k-routing-transportadora-v1: k-routing-transportadora
	kubectl apply -f kubernetes/route/simple/virtual-service-transportadora-v1.yml;

k-routing-transportadora-v1-v2-90-10: k-routing-transportadora
	kubectl apply -f kubernetes/route/simple/virtual-service-transportadora-v1-v2-90-10.yml;

k-routing-transportadora-v1-v2-75-25: k-routing-transportadora
	kubectl apply -f kubernetes/route/simple/virtual-service-transportadora-v1-v2-75-25.yml;

k-routing-transportadora-v1-v2-25-75: k-routing-transportadora
	kubectl apply -f kubernetes/route/simple/virtual-service-transportadora-v1-v2-25-75.yml;

k-routing-transportadora-v2:
	kubectl apply -f kubernetes/route/simple/virtual-service-transportadora-v2.yml;
	kubectl apply -f kubernetes/route/simple/destination-rule-transportadora-v2.yml;

k-delete-transportadora-deploy:
	kubectl delete -f <(istioctl kube-inject -f kubernetes/transportadora/deployment.yaml);

k-delete-transportadora-v2-deploy:
	kubectl delete -f <(istioctl kube-inject -f kubernetes/transportadora-v2/deployment.yaml);

k-clean-routing:
	kubectl delete -f kubernetes/route/simple/virtual-service-transportadora-v2.yml; \
	kubectl delete -f kubernetes/route/simple/destination-rule-transportadora-v1-v2.yml;

k-routing-transportadora-v2-safari: k-routing-transportadora
	kubectl replace -f kubernetes/route/advanced/virtual-service-safari-transportadora-v2.yml;

k-delete-routing-safari:
	kubectl delete -f kubernetes/route/advanced/virtual-service-safari-transportadora-v2.yml;

k-routing-transportadora-v1-mirror-v2: k-routing-transportadora
	kubectl apply -f kubernetes/route/advanced/virtual-service-transportadora-v1-mirror-v2.yml;

k-delete-routing-mirror:
	kubectl delete -f kubernetes/route/advanced/virtual-service-transportadora-v1-mirror-v2.yml;

k-test-raptorslog-safari:
	while true; do sleep 0.8; curl -X POST -A Safari http://raptorslog.loja.local/v1/pedido; echo -e '';done
