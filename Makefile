SHELL:=/bin/bash

login:
	aws configure sso
	az login

deploy:
	source load_env.sh && \
	cd terraform && \
	terraform init -upgrade && \
	terraform validate && \
	terraform apply && \
	(echo -n "rancher password = "; terraform output -raw rancher_server_password; echo "")

destroy:
	source load_env.sh && \
	cd terraform && \
	terraform apply -destroy

fmt:
	terraform fmt --recursive
