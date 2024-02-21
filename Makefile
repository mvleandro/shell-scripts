# Makefile for shell-scripts-main

# Default context if none provided
CONTEXT ?= "default-context"

# Style codes
BOLD=\033[1m
SOFT=\033[0;36m # Cyan for a softer appearance
NC=\033[0m # No Color

.PHONY: help check_kube

help:
	@echo "${BOLD}Usage:${NC}"
	@echo "  This Makefile helps in running various shell scripts available in this repository."
	@echo "  Specify the script and any required arguments as needed."
	@echo ""
	@echo "${BOLD}Examples:${NC}"
	@echo "  ${SOFT}make check_kube CONTEXT=\"my-kube-context production-kube-context\"${NC}"
	@echo "    - Runs the check_kube_state.sh script with the specified Kubernetes contexts."
	@echo ""
	@echo "  You can pass ${BOLD}CONTEXT${NC} argument to scripts that require Kubernetes context."
	@echo "  Replace 'my-kube-context production-kube-context' with your actual Kubernetes contexts."

all: help

check_kube:
	@echo "${BOLD}Running check_kube_state.sh with context $(CONTEXT)...${NC}"
	@./check_kube_state.sh $(CONTEXT)
