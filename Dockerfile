FROM graphiteapp/graphite-statsd:1.1.10-4@sha256:362b5ed97e77af938d7fab80fd25350baafe105f48fd9dcae849ada6a15929a5

ARG VSN=1.0.4

# renovate datasource: repology, depName: alpine_3_17/npm
ENV NPM_VERSION="8.1.3-r0"
# renovate datasource: repology, depName: alpine_3_17/git
ENV GIT_VERSION="2.39.5-r0"

WORKDIR /etc/service/dogstatsd-2-statsd

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN set -ex \
 && V=$(grep "PRETTY_NAME" /etc/os-release | cut -d'=' -f2) \
 && if [ "$V" != "\"Alpine Linux v3.15\"" ]; then echo Unexpected Alpine Linux version; exit 1; fi \
 # Read /entrypoint to understand why we use run and /etc/service
 && sed -i 's/8125/8135/g' /opt/statsd/config/udp.js \
 && apk add --no-cache \
        npm=${NPM_VERSION} \
        git=${GIT_VERSION} \
 && git clone --depth 1 --branch $VSN https://github.com/paulo-ferraz-oliveira/dogstatsd-2-statsd.git . \
 && npm install --omit=dev \
 && printf "#!/bin/bash\n\nexec node index.js" > run \
 && chmod +x run
 
ENTRYPOINT ["/entrypoint"]
