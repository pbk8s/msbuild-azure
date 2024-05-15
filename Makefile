VERSION_FILE := version
VERSION := $(shell cat ${VERSION_FILE})
IMAGE_REPO := $(ACR_NAME).azurecr.io/githubactions-aks-demo

.PHONY: build
build:
	docker build -t $(IMAGE_REPO):$(VERSION) .

.PHONY: registry-login
registry-login:
	@az login \
		--service-principal \
		--username $(SERVICE_PRINCIPAL_APP_ID) \
		--password $(SERVICE_PRINCIPAL_SECRET) \
		--tenant $(SERVICE_PRINCIPAL_TENANT)
	@az acr login --name $(ACR_NAME)

.PHONY: push
push:
	docker push $(IMAGE_REPO):$(VERSION)

.PHONY: deploy
deploy:
	sed 's|IMAGE_REPO|$(IMAGE_REPO)|g; s/VERSION/$(VERSION)/g' ./k8s/deployment.yaml | \
		kubectl apply -f -
