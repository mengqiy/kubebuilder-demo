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

eval $(minikube docker-env)

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

INFO "====> [ Scaffold the project structure ]" "${YELLOW}"
pe "kubebuilder init --domain=cncf.io --dep=false" "${GREEN}"

INFO "====> [ Scaffold the CRD API and controller]" "${YELLOW}"
pe "kubebuilder create api --group=example --version=v1alpha1 --kind=BoundedDeployment --resource --controller --make=false" "${GREEN}"

INFO "====> [ Scaffold the webhook]" "${YELLOW}"
pe "kubebuilder alpha webhook --group=example --version=v1alpha1 --kind=BoundedDeployment --type=mutating --operations=create,update --make=false" "${GREEN}"

INFO "====> [ Run make ]" "${YELLOW}"
pe "make" "${GREEN}"

INFO "====> [ commit generated code ]" "${YELLOW}"
pe "git add -A" "${GREEN}"
pe "git commit -m 'kubebuilder scaffolded content'" "${GREEN}"

INFO "====> [ add business logic ]" "${YELLOW}"
pe "git apply demo/business_logic.patch" "${GREEN}"

INFO "====> [ Show what user needs to implement ]" "${YELLOW}"
pe "git diff" "${GREEN}"
pe "git commit -am 'add business logic'" "${GREEN}"

INFO "====> [ Run make again to update generated code ]" "${YELLOW}"
pe "make" "${GREEN}"

INFO "====> [ Show generated code has been updated ]" "${YELLOW}"
pe "git diff" "${GREEN}"

# changes the yaml of a CR instance and create yaml for another instance.
INFO "====> [ Update CR instances ]" "${YELLOW}"
pe "git apply demo/CR.patch" "${GREEN}"
# use the image built locally for minikube
pe "git apply demo/image_pull.patch" "${GREEN}"

INFO "====> [ Build docker image ]" "${YELLOW}"
pe "make docker-build" "${GREEN}"

INFO "====> [ Deploy the controller and webhook to cluster ]" "${YELLOW}"
pe "make deploy" "${GREEN}"

INFO "====> [ Verify the controller and webhooks work ]" "${YELLOW}"
pe "cat config/samples/example_v1alpha1_boundeddeployment.yaml" "${GREEN}"
pe "kubectl apply -f config/samples/example_v1alpha1_boundeddeployment.yaml" "${GREEN}"
pe "kubectl get deployments boundeddeployment-sample-deployment -o yaml | grep replicas" "${GREEN}"

pe "cat config/samples/example_v1alpha1_boundeddeployment-2.yaml" "${GREEN}"
pe "kubectl apply -f config/samples/example_v1alpha1_boundeddeployment-2.yaml" "${GREEN}"
pe "kubectl get deployments boundeddeployment-sample-2-deployment -o yaml | grep replicas" "${GREEN}"
