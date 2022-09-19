#
# Container Image MongoDB
#

.PHONY: vol-create
vol-create:
	$(BIN_DOCKER) volume create "mongod"

.PHONY: vol-rm
vol-rm:
	$(BIN_DOCKER) volume rm "mongod"
