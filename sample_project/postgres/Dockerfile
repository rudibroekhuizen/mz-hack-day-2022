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

# Install go
RUN set -x && \
    cd /opt && \
    wget -q "https://go.dev/dl/go1.18.linux-amd64.tar.gz" && \
    tar -xvf go1.18.linux-amd64.tar.gz && \
    ln -s /opt/go/bin/go /usr/local/bin/go

# Install irodsfs
RUN set -x && \
    cd /opt && \
    git clone -b v0.7.9 https://github.com/cyverse/irodsfs && \
    cd irodsfs && \
    make build && \
    ln -s /opt/irodsfs/bin/irodsfs /usr/local/bin/irodsfs && \
    mkdir -p /mnt/irodsfs/tempZone && \
    chown -R postgres:postgres /mnt/irodsfs/tempZone

# Install fio extension 
RUN set -x && \
    cd /opt && \
    git clone https://github.com/csimsek/pgsql-fio && \
    cd pgsql-fio && \
    make install
