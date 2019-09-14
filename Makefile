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

gradleb-entregador-AM:
	cd ./entregador-AM/ && ./gradlew clean build -Dorg.gradle.java.home=/usr/lib/jvm/java-12-openjdk-amd64/;

gradleb-loja:
	cd ./loja/ && ./gradlew clean build -Dorg.gradle.java.home=/usr/lib/jvm/java-12-openjdk-amd64/;

gradleb-transportadora:
	cd ./transportadora/ && ./gradlew clean build -Dorg.gradle.java.home=/usr/lib/jvm/java-12-openjdk-amd64/;

gradleb-transportadora-dispatcher:
	cd ./transportadora-dispatcher/ && ./gradlew clean build -Dorg.gradle.java.home=/usr/lib/jvm/java-12-openjdk-amd64/;

gradleb-all: gradleb-loja gradleb-entregador gradleb-entregador-AM gradleb-transportadora gradleb-transportadora-dispatcher

dockerb-rabbitmq:
	docker build --force-rm -t rabbitmq:1.0.0 ./queue/;

dockerb-entregador: gradleb-entregador
	docker build --force-rm -t entregador:1.0.0 ./entregador/;

dockerb-entregador-AM: gradleb-entregador-AM
	docker build --force-rm -t entregador-am:1.0.0 ./entregador-AM/;

dockerb-loja: gradleb-loja
	docker build --force-rm -t loja:1.0.0 ./loja/;

dockerb-transportadora: gradleb-transportadora
	docker build --force-rm -t transportadora:1.0.0 ./transportadora/;

dockerb-transportadora-dispatcher: gradleb-transportadora-dispatcher
	docker build --force-rm -t transportadora-dispatcher:1.0.0 ./transportadora-dispatcher/;

dockerb-all: dockerb-rabbitmq gradleb-loja dockerb-entregador dockerb-entregador-AM dockerb-transportadora dockerb-transportadora-dispatcher

compose-build: compose-down gradleb-all
	docker-compose build;

compose-up: compose-down dockerb-all
	docker-compose up;

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
	echo -e "HealthCheck TRANSPORTADORA-DISPATCHER:\n"; \
	curl -k http://localhost:8083/actuator/health; \
	echo -e "\n"; \
	echo -e "HealthCheck ENTREGADOR:\n"; \
	curl -k http://localhost:8082/actuator/health; \
	echo -e "\n"\
	echo -e "HealthCheck ENTREGADOR-AM:\n"; \
	curl -k http://localhost:8084/actuator/health; \
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
	--link rabbitmq:rabbitmq \
	-p 8081:8080 transportadora:1.0.0;

transportadora-dispatcherrun:
	docker run -d --network minha-rede --name transportadora-dispatcher \
	-e ENV_RABBITMQ_HOST=rabbitmq \
	-e ENV_RABBITMQ_PORT=5672 \
	-e ENV_RABBITMQ_USER=guest \
	-e ENV_RABBITMQ_PASS=guest \
	-e ENV_QUEUE_NAME=raptorslog.queue \
	-e ENV_ENTREGADOR=http://entregador:8070 \
	--link rabbitmq:rabbitmq \
	--link entregador:entregador \
	-p 8083:8080 transportadora-dispatcher:1.0.0;

entregadorrun:
	docker run -d --network minha-rede --name entregador \
	-p 8082:8070 entregador:1.0.0;

entregador-AMrun:
	docker run -d --network minha-rede --name entregador-AM \
	-p 8084:8071 entregador-am:1.0.0;

rabbitmq-delete:
	docker container rm -f rabbitmq;

loja-delete:
	docker container rm -f loja;

transportadora-delete:
	docker container rm -f transportadora;

transportadora-dispatcher-delete:
	docker container rm -f transportadora-dispatcher;

entregador-delete:
	docker container rm -f entregador;

entregador-AM-delete:
	docker container rm -f entregador-AM;

dockerrmall: rabbitmq-delete loja-delete transportadora-delete transportadora-dispatcher-delete entregador-delete entregador-AM-delete

# export ISTIO_HOME=`pwd`/istio-1.2.5
# export PATH=$ISTIO_HOME/bin:$PATH

k-setup:
	minikube -p minikube start --cpus 2 --memory=8192; \
	minikube -p minikube addons enable ingress; \
	minikube -p minikube addons enable metrics-server; \
	kubectl create namespace raptorslog; \
	kubectl config set-context $(kubectl config current-context) --namespace=raptorslog;

k-istio-setup:
	for i in istio-1.2.5/install/kubernetes/helm/istio-init/files/crd*yaml; do kubectl apply -f $i; done; \
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
	minikube start; \
	kubectl config set-context $(kubectl config current-context) --namespace=raptorslog;

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
	sleep 30; \
#	kubectl apply -f kubernetes/queue/;

k-delete-queue:
	kubectl delete -f kubernetes/queue/;

k-foward-queue:
	kubectl port-forward -n=raptorslog rabbitmq-97c6d77bb-q8m7p 15672:15672;

k-build-entregador: gradleb-entregador
	eval $$(minikube -p minikube docker-env) && docker build --force-rm -t entregador:1.0.0 ./entregador/;

k-deploy-entregador: k-build-entregador
	kubectl apply -f <(istioctl kube-inject -f kubernetes/entregador/deployment.yaml)
	kubectl apply -f kubernetes/entregador/service.yaml
#	kubectl apply -f kubernetes/entregador/gateway.yaml
#	kubectl apply -f kubernetes/entregador/ingress.yaml
#	kubectl apply -f kubernetes/entregador/;

k-delete-entregador:
	kubectl delete -f kubernetes/entregador/;

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

k-build-transportadora: gradleb-transportadora
	eval $$(minikube -p minikube docker-env) && docker build --force-rm -t transportadora:1.0.0 ./transportadora/;

k-deploy-transportadora: k-build-transportadora
	kubectl apply -f <(istioctl kube-inject -f kubernetes/transportadora/deployment.yaml)
	kubectl apply -f kubernetes/transportadora/service.yaml
#	kubectl apply -f kubernetes/transportadora/gateway.yaml
#	kubectl apply -f kubernetes/transportadora/ingress.yaml
#	kubectl apply -f kubernetes/transportadora/;

k-delete-transportadora:
	kubectl delete -f kubernetes/transportadora/;

k-build-transportadora-dispatcher: gradleb-transportadora-dispatcher
	eval $$(minikube -p minikube docker-env) && docker build --force-rm -t transportadora-dispatcher:1.0.0 ./transportadora-dispatcher/;

k-deploy-transportadora-dispatcher: k-build-transportadora-dispatcher
	kubectl apply -f <(istioctl kube-inject -f kubernetes/transportadora-dispatcher/deployment.yaml)
#	kubectl apply -f kubernetes/transportadora-dispatcher/service.yaml
#	kubectl apply -f kubernetes/transportadora-dispatcher/gateway.yaml
#	kubectl apply -f kubernetes/transportadora-dispatcher/ingress.yaml
#	kubectl apply -f kubernetes/transportadora-dispatcher/;

k-delete-transportadora-dispatcher:
	kubectl delete -f kubernetes/transportadora-dispatcher/;

k-build-loja: gradleb-loja
	eval $$(minikube -p minikube docker-env) && docker build --force-rm -t loja:1.0.0 ./loja/;

k-deploy-loja: k-build-loja
	kubectl apply -f <(istioctl kube-inject -f kubernetes/loja/deployment.yaml)
	kubectl apply -f kubernetes/loja/service-lb.yaml
#	kubectl apply -f kubernetes/loja/service.yaml
#	kubectl apply -f kubernetes/loja/gateway.yaml
#	kubectl apply -f kubernetes/loja/ingress.yaml
#	kubectl apply -f kubernetes/loja/;

k-expose-loja:
	minikube service loja-svc --namespace=raptorslog;

k-delete-loja:
	kubectl delete -f kubernetes/loja/;

k-deployall: k-deploy-queue k-deploy-entregador k-deploy-entregador-AM k-deploy-loja k-deploy-transportadora k-deploy-transportadora-dispatcher

k-test-raptorslog:
	while true; do sleep 1; curl -X POST http://$$(minikube -p minikube ip):31930/v1/pedido; echo -e '\n';done
#	while true; do sleep 1; curl -X POST http://raptorslog.loja.local/v1/pedido; echo -e '\n';done

k-deleteall: k-delete-loja k-delete-transportadora k-delete-entregador k-delete-entregador-AM k-delete-queue

k-show-istio:
	kubectl get deploy,svc,pod -n istio-system; \
