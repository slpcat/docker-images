#upstream https://github.com/PGBI/kong-dashboard/blob/v3.5.0/Dockerfile
FROM node:10.9-alpine
MAINTAINER 若虚 <slpcat@qq.com>

RUN apk add wget unzip

RUN \
    wget https://github.com/PGBI/kong-dashboard/archive/v3.5.0.zip \
    && unzip v3.5.0.zip \
    && mv kong-dashboard-3.5.0 /app
#COPY . /app

WORKDIR /app

RUN npm install && \
    npm run build && \
    npm prune --production

EXPOSE 8080

CMD ["./docker/entrypoint.sh"]
