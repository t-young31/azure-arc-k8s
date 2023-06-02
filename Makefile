SHELL:=/bin/bash

login:
	aws configure sso

deploy: deploy-k8s deploy-aml

deploy-k8s:
	source load_env.sh && \
	cd terraform && \
	terraform init && \
	terraform validate && \
	terraform apply

destroy-k8s:
	source load_env.sh && \
	cd terraform && \
	terraform apply -destroy
