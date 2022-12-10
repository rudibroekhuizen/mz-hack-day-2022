FROM postgis/postgis:14-master

RUN apt-get update && \
    apt-get install -y sudo vim curl wget jq git build-essential unzip \
    fuse make moreutils \
    gcc postgresql-server-dev-14

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

RUN curl -s https://packagecloud.io/install/repositories/timescale/timescaledb/script.deb.sh | sudo bash
RUN apt install -y timescaledb-2-postgresql-14
#RUN timescaledb-tune --quiet --yes
