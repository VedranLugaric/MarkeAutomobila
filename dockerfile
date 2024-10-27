FROM mongo:latest

ENV MONGO_INITDB_ROOT_USERNAME=testuser
ENV MONGO_INITDB_ROOT_PASSWORD=password
ENV MONGO_INITDB_DATABASE=podaci

COPY ./dump /dump

COPY init_mongo.sh /docker-entrypoint-initdb.d/

RUN chmod +x /docker-entrypoint-initdb.d/init_mongo.sh
#RUN ./docker-entrypoint-initdb.d/init_mongo.sh
