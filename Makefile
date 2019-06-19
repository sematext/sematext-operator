IMAGE = sematext/sematext-operator
VERSION = 1.0.9
PREVIOUS_VERSION = $(shell ls -td deploy/olm-catalog/sematext-operator/*/ | head -n1 | cut -d"/" -f4)

.PHONY: build create-bundle

build:
	helm fetch stable/sematext-agent --version $(VERSION) --untar --untardir helm-charts/
	operator-sdk build $(IMAGE):$(VERSION)
	rm -rf helm-charts/sematext-agent

create-bundle:
	cat deploy/crds/sematext_v1alpha1_sematextagent_crd.yaml > bundle.yaml
	echo '---' >> bundle.yaml
	cat deploy/serviceaccount.yaml >> bundle.yaml
	echo '---' >> bundle.yaml
	cat deploy/rolebinding.yaml >> bundle.yaml
	echo '---' >> bundle.yaml
	cat deploy/operator.yaml >> bundle.yaml
	gsed -i 's|REPLACE_IMAGE|docker.io/$(IMAGE):$(VERSION)|g' bundle.yaml

push:
	docker push $(IMAGE):$(VERSION)

operatorhub:
	mkdir -p deploy/olm-catalog/sematext-operator/$(VERSION)
	cp deploy/olm-catalog/sematext-operator/sematext-operator.template.clusterserviceversion.yaml deploy/olm-catalog/sematext-operator/$(VERSION)/sematext-operator.v$(VERSION).clusterserviceversion.yaml
	gsed -i "s/PREVIOUS_VERSION/$(PREVIOUS_VERSION)/" deploy/olm-catalog/sematext-operator/$(VERSION)/sematext-operator.v$(VERSION).clusterserviceversion.yaml
	gsed -i "s/VERSION/$(VERSION)/" deploy/olm-catalog/sematext-operator/$(VERSION)/sematext-operator.v$(VERSION).clusterserviceversion.yaml
	git add deploy/olm-catalog/sematext-operator/$(VERSION)/sematext-operator.v$(VERSION).clusterserviceversion.yaml

new-upstream: build create-bundle push operatorhub
	git add bundle.yaml
	git add Makefile
	git commit -m "New Sematext agent helm chart release $(VERSION)"
