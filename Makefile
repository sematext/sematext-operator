IMAGE = sematext/sematext-operator
VERSION = 1.0.8

.PHONY: build create-bundle

build:
	helm fetch stable/sematext-agent --version $(VERSION) --untar --untardir helm-charts/
	operator-sdk build $(IMAGE):$(VERSION)
	rm -rf helm-charts/sematext-agent

create-bundle:
	cat deploy/crds/sematext_v1alpha1_sematext_crd.yaml > bundle.yaml
	echo '---' >> bundle.yaml
	cat deploy/serviceaccount.yaml >> bundle.yaml
	echo '---' >> bundle.yaml
	cat deploy/rolebinding.yaml >> bundle.yaml
	echo '---' >> bundle.yaml
	cat deploy/operator.yaml >> bundle.yaml
	gsed -i 's|REPLACE_IMAGE|docker.io/$(IMAGE):$(VERSION)|g' bundle.yaml

push:
	docker push $(IMAGE):$(VERSION)
