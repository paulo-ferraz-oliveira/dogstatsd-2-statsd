FROM graphiteapp/graphite-statsd:1.1.10-4

ARG VSN=1.0.4

WORKDIR /etc/service/dogstatsd-2-statsd

# Read /entrypoint to understand why we use run and /etc/service
RUN set -ex \
 && sed -i 's/8125/8135/g' /opt/statsd/config/udp.js \
 && apk add --no-cache npm=8.1.3-r0 git=2.34.8-r0 \
 && git clone --depth 1 --branch $VSN https://github.com/paulo-ferraz-oliveira/dogstatsd-2-statsd.git . \
 && npm install --omit=dev \
 && printf "#!/bin/bash\n\nexec node index.js" > run \
 && chmod +x run
 
ENTRYPOINT ["/entrypoint"]
