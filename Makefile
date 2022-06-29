IMAGE = sematext/sematext-operator
RH_CERTIFIED_IMAGE = registry.connect.redhat.com/sematext/sematext-operator
VERSION = 1.0.46
PREVIOUS_VERSION = $(shell ls -td deploy/olm-catalog/sematext-operator/*/ | head -n1 | cut -d"/" -f4)

.PHONY: build create-bundle

build:
	rm -rf helm-charts
	helm fetch sematext/sematext-agent --version $(VERSION) --untar --untardir helm-charts/
	make docker-build
	rm -rf helm-charts/sematext-agent

create-bundle:
	cat deploy/crds/sematext_v1_sematextagent_crd.yaml > bundle.yaml
	echo '---' >> bundle.yaml
	cat deploy/serviceaccount.yaml >> bundle.yaml
	echo '---' >> bundle.yaml
	cat deploy/rolebinding.yaml >> bundle.yaml
	echo '---' >> bundle.yaml
	cat deploy/operator.yaml >> bundle.yaml
	gsed -i "s|REPLACE_IMAGE|$(IMAGE):$(VERSION)|g" bundle.yaml

push:
	docker push $(IMAGE):$(VERSION)

operatorhub:
	mkdir -p deploy/olm-catalog/sematext-operator/$(VERSION)
	cp deploy/olm-catalog/sematext-operator/sematext-operator.template.clusterserviceversion.yaml deploy/olm-catalog/sematext-operator/$(VERSION)/sematext-operator.v$(VERSION).clusterserviceversion.yaml
	cp deploy/olm-catalog/sematext-operator/sematext.template.package.yaml deploy/olm-catalog/sematext-operator/$(VERSION)/sematext.package.yaml
	gsed -i "s/REPLACE_PREVIOUS_VERSION/$(PREVIOUS_VERSION)/" deploy/olm-catalog/sematext-operator/$(VERSION)/sematext-operator.v$(VERSION).clusterserviceversion.yaml
	gsed -i "s/REPLACE_VERSION/$(VERSION)/" deploy/olm-catalog/sematext-operator/$(VERSION)/sematext-operator.v$(VERSION).clusterserviceversion.yaml
	gsed -i "s|REPLACE_IMAGE|$(IMAGE)|g" deploy/olm-catalog/sematext-operator/$(VERSION)/sematext-operator.v$(VERSION).clusterserviceversion.yaml
	gsed -i "s/REPLACE_VERSION/$(VERSION)/" deploy/olm-catalog/sematext-operator/$(VERSION)/sematext.package.yaml
	git add deploy/olm-catalog/sematext-operator/$(VERSION)

new-upstream: build create-bundle push operatorhub
	git add bundle.yaml
	git add Makefile
	git commit -m "New Sematext agent helm chart release $(VERSION)"

redhat-package:
	cp deploy/crds/sematext_v1_sematextagent_crd.yaml redhat-certification/sematext.crd.yaml
	cp deploy/olm-catalog/sematext-operator/sematext-operator.template.clusterserviceversion.yaml redhat-certification/sematext-operator.v$(VERSION).clusterserviceversion.yaml
	cp deploy/olm-catalog/sematext-operator/sematext.template.package.yaml redhat-certification/sematext.package.yaml
	gsed -i "s/REPLACE_VERSION/$(VERSION)/" redhat-certification/sematext-operator.v$(VERSION).clusterserviceversion.yaml
	gsed -i "s/REPLACE_VERSION/$(VERSION)/" redhat-certification/sematext.package.yaml
	gsed -i "s|REPLACE_IMAGE|$(RH_CERTIFIED_IMAGE)|g" redhat-certification/sematext-operator.v$(VERSION).clusterserviceversion.yaml
	zip -j redhat-certification/redhat-certification-metadata-$(VERSION).zip \
		redhat-certification/sematext-operator.v$(VERSION).clusterserviceversion.yaml \
		redhat-certification/sematext.crd.yaml \
		redhat-certification/sematext.package.yaml
	rm redhat-certification/sematext*
	git add redhat-certification
	git commit -m "New Sematext Operator RH certified version $(VERSION)"

docker-build: ## Build docker image with the manager.
	docker build -t $(IMAGE):$(VERSION) -f build/Dockerfile .

