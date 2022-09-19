#
# Container Image MongoDB
#

FROM ubuntu:xenial-20210804

ARG PROJ_NAME
ARG PROJ_VERSION
ARG PROJ_BUILD_NUM
ARG PROJ_BUILD_DATE
ARG PROJ_REPO
ARG MONGOSH_VERSION
ARG TARGETOS
ARG TARGETARCH

LABEL org.opencontainers.image.authors="V10 Solutions"
LABEL org.opencontainers.image.title="${PROJ_NAME}"
LABEL org.opencontainers.image.version="${PROJ_VERSION}"
LABEL org.opencontainers.image.revision="${PROJ_BUILD_NUM}"
LABEL org.opencontainers.image.created="${PROJ_BUILD_DATE}"
LABEL org.opencontainers.image.description="Container image for MongoDB"
LABEL org.opencontainers.image.source="${PROJ_REPO}"

ENV DEBIAN_FRONTEND "noninteractive"

RUN apt-get update \
	&& apt-get install -y -o "APT::Install-Recommends=false;" "bash" \
	&& usermod -s "$(command -v "bash")" "root"

SHELL [ \
	"bash", \
	"--noprofile", \
	"--norc", \
	"-o", "errexit", \
	"-o", "nounset", \
	"-o", "pipefail", \
	"-c" \
]

RUN apt-get install -y -o "APT::Install-Recommends=false;" "locales" \
	&& update-locale LANG="C.UTF-8" LC_ALL="C.UTF-8"

RUN apt-get install -y -o "APT::Install-Recommends=false;" \
	"ca-certificates" \
	"curl" \
	"libcurl4-openssl-dev"

RUN addgroup --system --gid "480" "mongodb" \
	&& adduser \
		--system \
		--disabled-login \
		--home "/home/mongodb" \
		--ingroup "mongodb" \
		--gecos "MongoDB" \
		--uid "480" \
		"mongodb"

WORKDIR "/tmp"

RUN curl -L -f -o "mongodb.tgz" "https://fastdl.mongodb.org/${TARGETOS}/mongodb-${TARGETOS}-${TARGETARCH//amd64/x86_64}-ubuntu1604-${PROJ_VERSION}.tgz" \
	&& mkdir "mongodb" \
	&& tar -x -f "mongodb.tgz" -C "mongodb" --strip-components "1" \
	&& pushd "mongodb" \
	&& chmod "755" "bin/mongo"* \
	&& mv "bin/mongo"* "/usr/local/bin/" \
	&& popd \
	&& rm -r -f "mongodb" \
	&& rm "mongodb.tgz"

RUN curl -L -f -o "mongosh.tgz" "https://downloads.mongodb.com/compass/mongosh-${MONGOSH_VERSION}-${TARGETOS}-${TARGETARCH//amd64/x64}.tgz" \
	&& tar \
		-x \
		-f "mongosh.tgz" \
		--strip-components "2" \
		"mongosh-${MONGOSH_VERSION}-${TARGETOS}-${TARGETARCH//amd64/x64}/bin/mongosh" \
	&& chmod "755" "mongosh" \
	&& mv "mongosh" "/usr/local/bin/" \
	&& rm "mongosh.tgz"

WORKDIR "/usr/local"

RUN mkdir -p "etc/mongodb" \
	&& folders=("var/lib/mongodb" "var/run/mongodb") \
	&& for folder in "${folders[@]}"; do \
		mkdir -p "${folder}" \
		&& chmod "700" "${folder}" \
		&& chown -R "480":"480" "${folder}"; \
	done

WORKDIR "/"

ENV DEBIAN_FRONTEND ""
