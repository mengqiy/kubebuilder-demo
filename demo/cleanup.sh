#!/usr/bin/env bash

kustomize build config/default | kubectl delete -f -
kubectl delete -f config/crds
