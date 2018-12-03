

###################
# PARAMETRIZACOES #
###################

SHELL := /bin/bash
CURRENT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
ROOT_DIR := $(HOME)
CONTEXTO = "Cursos e Treinamentos - geral | Versão: "$(shell cat .version)



NO_COLOR=\x1b[0m
GREEN_COLOR=\x1b[32;01m
RED_COLOR=\x1b[31;01m
ORANGE_COLOR=\x1b[33;01m

OK_STRING=$(GREEN_COLOR)[OK]$(NO_COLOR)
ERROR_STRING=$(RED_COLOR)[ERRORS]$(NO_COLOR)
WARN_STRING=$(ORANGE_COLOR)[WARNINGS]$(NO_COLOR)


#############
# FUNCTIONS #
#############




define pergunta_critical
    echo -e "\t$(RED_COLOR)$(1)$(NO_COLOR) "
		while true; do \
	    read -p '          Informe: (y/n)' yn ; \
	    case $$yn in  \
	        y|Y ) echo -e "              $(GREEN_COLOR)Continuando...$(NO_COLOR)"; break ;; \
	        n|N ) echo -e "              Ok... $(RED_COLOR)saindo, cancelando, desistindo....$(NO_COLOR)"; sleep 2; exit 255 ;; \
	        * ) echo "              Por favor, escolha y ou n." ;; \
	     esac ; \
	  done
endef
define msg_critical
    echo -e "$(RED_COLOR)-->[$(1)]$(NO_COLOR)\n"
endef

define msg_warn
    echo -e "$(ORANGE_COLOR)-->[$(1)]$(NO_COLOR)\n"
endef

define msg_ok
    echo -e "$(GREEN_COLOR)-->[$(1)]$(NO_COLOR)\n"
endef

define menu
    echo -e "$(GREEN_COLOR)[$(1)]$(NO_COLOR)"
endef





########################
# BINARIOS E PROGRAMAS #
########################
FIND_MAKE=find $(ROOT_DIR) -name Makefile


###########################
# INTERNO PARA O MAKE.... #
###########################
.PHONY: ajuda
ajuda: help

.PHONY: limpa_tela
limpa_tela:
	@clear

.PHONY: sair
sair:
	@clear

.PHONY: versiona
versiona: ## Incremente uma versão (minima)
	@$(shell tools/versiona.sh)
	@$(call msg_ok,"Nova versão")
	@echo $(shell cat .version)


#####################
# GIT e REPOSITORIO #
#####################
.PHONY: git_trazer
git_trazer: ## Atualiza o repositorio local
	@clear
	@$(call msg_ok,"Verificando se existem coisas novas!!")
	git pull

.PHONY: git_enviar
git_enviar: ## Enviar para o git
	@clear
	@$(call msg_warn,"Enviando para git...")
	make git_trazer
	@$(call msg_warn,"Adcionando nova versao e dando o commit...")
	@$(shell tools/versiona.sh)
	@$(call msg_ok,"Nova versão")
	@echo $(shell cat .version)
	git add :/ --all && git commit -m "$(shell cat .version) - $(shell cat .version_comentario)" --all || echo
	@$(call msg_warn,"Empurrando para o git agora...")
	git push

#######################
## tools - MENU MAKE ##
#######################
.PHONY: help
help: limpa_tela
	@$(call menu, "============== $(CONTEXTO) ==============")
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST)  | awk 'BEGIN {FS = ":.*?## "}; {printf "\t\033[36m%-30s\033[0m %s\n", $$1, $$2}'

