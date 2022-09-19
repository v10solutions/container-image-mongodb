#
# Container Image MongoDB
#

.PHONY: container-run-linux
container-run-linux:
	$(BIN_DOCKER) container create \
		--platform "$(PROJ_PLATFORM_OS)/$(PROJ_PLATFORM_ARCH)" \
		--name "mongod" \
		-h "mongod" \
		-u "480" \
		--entrypoint "mongod" \
		--net "$(NET_NAME)" \
		-p "27017":"27017" \
		--health-interval "10s" \
		--health-timeout "8s" \
		--health-retries "3" \
		--health-cmd "mongod-healthcheck \"27017\" \"8000\"" \
		-v "mongod":"/usr/local/var/lib/mongodb" \
		"$(IMG_REG_URL)/$(IMG_REPO):$(IMG_TAG_PFX)-$(PROJ_PLATFORM_OS)-$(PROJ_PLATFORM_ARCH)" \
		-f "/usr/local/etc/mongodb/mongod.yml"
	$(BIN_FIND) "bin" -mindepth "1" -type "f" -iname "*" -print0 \
	| $(BIN_TAR) -c --numeric-owner --owner "0" --group "0" -f "-" --null -T "-" \
	| $(BIN_DOCKER) container cp "-" "mongod":"/usr/local"
	$(BIN_FIND) "etc/mongodb" -mindepth "1" -type "f" -iname "*" ! -iname "ssl.pem" -print0 \
	| $(BIN_TAR) -c --numeric-owner --owner "0" --group "0" -f "-" --null -T "-" \
	| $(BIN_DOCKER) container cp "-" "mongod":"/usr/local"
	$(BIN_FIND) "etc/mongodb" -mindepth "1" -type "f" -iname "ssl.pem" -print0 \
	| $(BIN_TAR) -c --numeric-owner --owner "480" --group "480" --mode "600" -f "-" --null -T "-" \
	| $(BIN_DOCKER) container cp "-" "mongod":"/usr/local"
	$(BIN_DOCKER) container start -a "mongod"

.PHONY: container-run
container-run:
	$(MAKE) "container-run-$(PROJ_PLATFORM_OS)"

.PHONY: container-rm
container-rm:
	$(BIN_DOCKER) container rm -f "mongod"
