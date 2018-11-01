#!/usr/bin/env bash

########################
# include the magic
########################
. demo/demo-lib.sh


########################
# Configure the options
########################

#
# speed at which to simulate typing. bigger num = faster
#
 TYPE_SPEED=50

# This is your image name
# TODO: setup local image registry for minikube. Push and pull from that registry.
#IMG=gcr.io/mengqiy-dev/manager-demo

#
# custom prompt
#
# see http://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/bash-prompt-escape-sequences.html for escape sequences
#
DEMO_PROMPT="${GREEN}➜ ${CYAN}\W "

#clear

pe "kubebuilder init --domain=cncf.io --dep=false"

pe "kubebuilder create api --group=example --version=v1alpha1 --kind=BoundedDeployment --resource --controller"

pe "kubebuilder alpha webhook --group=example --version=v1alpha1 --kind=BoundedDeployment --type=mutating --operations=create,update"

pe "git add -A"
pe "git commit -m 'init commit'"

pe "git apply demo/business_logic.patch"

pe "git diff"

pe "make"

# changes the yaml of a CR instance and create yaml for another instance.
pe "git apply demo/CR.patch"
# use the image built locally for minikube
pe "git apply demo/image_pull.patch"

pe "git diff"

pe "make docker-build"

pe "make deploy"

pe "cat config/samples/example_v1alpha1_boundeddeployment.yaml | grep replicas"
pe "kubectl apply -f config/samples/example_v1alpha1_boundeddeployment.yaml"
pe "kubectl get deployments boundeddeployment-sample-deployment -o yaml | grep replicas"

pe "cat config/samples/example_v1alpha1_boundeddeployment-2.yaml | grep replicas"
pe "kubectl apply -f config/samples/example_v1alpha1_boundeddeployment-2.yaml"
pe "kubectl get deployments boundeddeployment-sample-2-deployment -o yaml | grep replicas"

pe "cat config/samples/example_v1alpha1_boundeddeployment-3.yaml | grep replicas"
pe "kubectl apply -f config/samples/example_v1alpha1_boundeddeployment-3.yaml"
