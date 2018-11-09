#!/usr/bin/env bash

eval $(minikube docker-env)

minikube ssh -- docker pull golang:1.10.3
minikube ssh -- docker pull ubuntu:latest
