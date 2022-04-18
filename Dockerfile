FROM mysql:5.7

WORKDIR /tmp

RUN apt update \
    && apt install -y git python3 wget

# clone db dump converter from git, db dump and decompress it 
RUN git clone https://github.com/p2vvel/myisam_to_innodb.git . \
    && wget http://ergast.com/downloads/f1db.sql.gz \
    && gzip -d f1db.sql.gz 

# convert MyISAM db dump to InnoDB and copy to /docker-entrypoint-initdb.d/ to initialize at startup
RUN python3 -m db_converter f1db.sql \
    && mv f1db_innodb.sql /docker-entrypoint-initdb.d/

ENV MYSQL_DATABASE=f1db

EXPOSE 3306
EXPOSE 33060