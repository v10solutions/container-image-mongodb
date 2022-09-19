#
# Container Image MongoDB
#

.PHONY: setup-admin
setup-admin:
	$(BIN_DOCKER) exec -u "mongodb" -t -i "mongod" mongosh \
		--quiet \
		--eval "$$(cat "setup/admin.js")" \
		--tls \
		--tlsAllowInvalidCertificates \
		"mongodb://127.0.0.1:27017/?socketTimeoutMS=8000"

.PHONY: setup-wms
setup-wms:
	hostname=$(shell $(BIN_DOCKER) exec -u "mongodb" "mongod" hostname -f) \
	&& $(BIN_DOCKER) exec -u "mongodb" -t -i "mongod" mongosh \
		--quiet \
		--eval "$$(cat "setup/wms.js")" \
		--tls \
		--tlsCAFile "/usr/local/etc/mongodb/ca.pem" \
		--authenticationDatabase "admin" \
		-u "admin" \
		-p "" \
		"mongodb://$${hostname}:27017/?socketTimeoutMS=8000"
