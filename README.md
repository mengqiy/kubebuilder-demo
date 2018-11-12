# Kubebuilder Demo

This repo is a demo project, which is scaffoled by `kubebuilder` for showing how `Bounded Deployment` works. CRD will be created and installed to cluster as a Kubernetes resource. Requests of creating a CR object from `kubectl` is received by Kubernetes API server, which will invoke `Webhook` for handling. API server patches the response from Webhook for creating this object eventually. `Controller` is consistently watching and reconciling this object.

![Demo diagram](./doc/kubebuilder-demo.png?raw=true)

## Prerequisites

- go 1.10 or newer
- dep v0.5.0 or newer
- [kubebuilder](https://github.com/kubernetes-sigs/kubebuilder#installalation) v1.0.5 or newer
- a minikube cluster with version v0.30.0 or newer
  - [Install minikube](https://kubernetes.io/docs/tasks/tools/install-minikube/)
  - [Reusing the Docker daemon](https://kubernetes.io/docs/setup/minikube/#reusing-the-docker-daemon)

## How to Start

`git clone` the repo under your `GOPATH`.

Run `eval $(minikube docker-env)` after minikube starts.
We will reuse the docker daemon in minikube.

Run `./start_demo.sh`.

## Under the hood of demo

### Build and Deploy

1) Scaffold a project
1) Scaffold a CRD API
1) Scaffold a controller
1) Scaffold a mutating webhook
1) Fill the business logic by applying a patch
1) Run `make`
1) Modify instances of CR by applying a patch.
1) Build image by `make docker-build`
1) (Skipped) Push image by `make docker-push`
1) Deploy by `make deploy`

Note: `make docker-push` pushes images to your registry.
This step is skipped in the demo because we reuse the docker daemon in minikube.

### Controller

Controller creates deployment with the same replicas specified in the CR.

### Webhook

The mutating webhook modifies the CR.
If the `replicas` field is not set, default it to 2.
If the `replicas > 2`, it change it to 2.

### Verify Controller and Webhook Work

1) Create a instance of CR with replicas=10
1) Verify a deployment with replicas=2 has been created.
