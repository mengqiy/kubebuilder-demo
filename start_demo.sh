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

export PS1="$ "

# This is your image name
# TODO: setup local image registry for minikube. Push and pull from that registry.
#IMG=gcr.io/mengqiy-dev/manager-demo

#
# custom prompt
#
# see http://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/bash-prompt-escape-sequences.html for escape sequences
#
#DEMO_PROMPT="${GREEN}➜ ${CYAN}\W "
DEMO_PROMPT="$ "

#clear

p "====> [ Scaffold the project structure ]"
pe "kubebuilder init --domain=cncf.io --dep=false"
p ""

p "====> [ Scaffold the CRD API and controller]"
pe "kubebuilder create api --group=example --version=v1alpha1 --kind=BoundedDeployment --resource --controller --make=false"
p ""

p "====> [ Scaffold the webhook]"
pe "kubebuilder alpha webhook --group=example --version=v1alpha1 --kind=BoundedDeployment --type=mutating --operations=create,update --make=false"
p ""

p "====> [ Run make ]"
pe "make"
p ""

p "====> [ commit generated code ]"
pe "git add -A"
pe "git commit -m 'init commit'"
p ""

p "====> [ add business logic ]"
pe "git apply demo/business_logic.patch"
p ""

p "====> [ Show what user needs to implement ]"
pe "git diff"
pe "git commit -am 'add business logic'"
p ""

p "====> [ Run make again to update generated code ]"
pe "make"
p ""

p "====> [ Show generated code has been updated ]"
pe "git diff"
p ""

# changes the yaml of a CR instance and create yaml for another instance.
p "====> [ Update CR instances ]"
pe "git apply demo/CR.patch"
# use the image built locally for minikube
pe "git apply demo/image_pull.patch"
p ""

p "====> [ Build docker image ]"
pe "make docker-build"
p ""

p "====> [ Deploy the controller and webhook to cluster ]"
pe "make deploy"
p ""

p "====> [ Verify the controller and webhooks work ]"
pe "cat config/samples/example_v1alpha1_boundeddeployment.yaml | grep replicas"
pe "kubectl apply -f config/samples/example_v1alpha1_boundeddeployment.yaml"
pe "kubectl get deployments boundeddeployment-sample-deployment -o yaml | grep replicas"

pe "cat config/samples/example_v1alpha1_boundeddeployment-2.yaml | grep replicas"
pe "kubectl apply -f config/samples/example_v1alpha1_boundeddeployment-2.yaml"
pe "kubectl get deployments boundeddeployment-sample-2-deployment -o yaml | grep replicas"
