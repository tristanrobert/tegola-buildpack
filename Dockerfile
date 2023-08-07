FROM scalingo/scalingo-22

ADD . buildpack
ADD env/.env /env/.env
RUN buildpack/bin/env.sh /env/.env /env
ADD build/config.toml /build/config.toml
RUN buildpack/bin/detect /build
ADD cache /cache
RUN buildpack/bin/compile /build /cache /env  
WORKDIR /cache
WORKDIR /build
RUN rm -rf /app/*
RUN cp -a /build/. /app
WORKDIR /app

EXPOSE ${PORT}

ENTRYPOINT [ "/app/bin/startup.sh" ]