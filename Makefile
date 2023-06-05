SHELL:=/bin/bash

login:
	aws configure sso
	az login

deploy: deploy-k8s deploy-aml

deploy-k8s:
	source load_env.sh && \
	cd k8s/terraform && \
	terraform init -upgrade && \
	terraform validate && \
	terraform apply && \
	echo -n "rancher password = "; terraform output -raw admin_server_password; echo "" 

destroy-k8s:
	source load_env.sh && \
	cd k8s/terraform && \
	terraform apply -destroy

# TODO: reduce this awful duplication 
deploy-aml:
	source load_env.sh && \
	cd aml/terraform && \
	terraform init -upgrade && \
	terraform validate && \
	terraform apply

destroy-aml:
	source load_env.sh && \
	cd aml/terraform && \
	terraform apply -destroy

fmt:
	terraform fmt --recursive
