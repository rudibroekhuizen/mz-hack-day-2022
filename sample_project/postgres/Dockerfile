FROM postgis/postgis:15-master

RUN apt-get update && \
    apt-get install -y sudo vim curl wget jq git build-essential \
    fuse make moreutils \
    gcc postgresql-server-dev-15

# Add pg_config to path
ENV PATH="${PATH}:/usr/bin"

# Install pg_cron extension
RUN set -x && \
    cd /opt && \
    git clone https://github.com/citusdata/pg_cron.git && \
    cd pg_cron && \
    make && \
    make install

# Install topn extension
RUN set -x && \
    cd /opt && \
    git clone https://github.com/citusdata/postgresql-topn.git && \
    cd postgresql-topn && \
    make && \
    make install

# Install hll extension
RUN set -x && \
    cd /opt && \
    git clone https://github.com/citusdata/postgresql-hll.git && \
    cd postgresql-hll && \
    make && \
    make install
