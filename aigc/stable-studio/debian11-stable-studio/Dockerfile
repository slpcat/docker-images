FROM node:18.16.0

# 设置环境变量
ENV NODE_ENV=production
#ENV APP_PATH=/node/app

# 设置工作目录
#WORKDIR $APP_PATH

# 把当前目录下的所有文件拷贝到镜像的工作目录下 .dockerignore 指定的文件不会拷贝
#COPY . $APP_PATH
RUN \
    mkdir /app && \
    cd /app && \
    git clone https://github.com/Stability-AI/StableStudio.git && \
    cd StableStudio && \
    rm yarn.lock && \
    yarn install && \
    yarn

# 安装依赖
#RUN yarn

# 暴露端口
EXPOSE 3000

WORKDIR /app/StableStudio

#CMD yarn start

CMD yarn dev --host
