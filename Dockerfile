FROM curlimages/curl as downloader
WORKDIR /tmp
RUN curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-amd64
RUN curl -LO https://dl.k8s.io/release/v1.29.0/bin/linux/amd64/kubectl
RUN chmod 755 kind kubectl

FROM docker:24-dind
RUN apk update
RUN apk add \
	bash \
	curl \
	vim
COPY --from=downloader /tmp/kind /usr/local/bin/
COPY --from=downloader /tmp/kubectl /usr/local/bin/
