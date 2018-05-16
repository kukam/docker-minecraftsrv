FROM alpine:latest

MAINTAINER kukam "kukam@freebox.cz"

# System variables for use with installation
ENV JAVA_OPTIONS "-XX:+UseG1GC -Djava.security.egd=file:/dev/urandom"
ENV PATH "${PATH}:/opt/jdk/bin"
ENV LANG "C.UTF-8"

# Minecraft server specific environment variables
ENV MINECRAFT_SERVER_VERSION "1.12.2"
ENV MINECRAFT_SERVER_AGREE_EULA "true"

# Install dependencies
RUN apk --no-cache add \
    openjdk8-jre \
    ca-certificates \
    wget \
    bash \
    && rm -rf /var/cache/apk/*

COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 25565

VOLUME /app
WORKDIR /app

ENTRYPOINT ["/entrypoint.sh"]

CMD [ "java", "-Xmx4096M", "-Xms1024M", "-Xmn512M", "-XX:+AggressiveOpts", "-XX:+UseFastAccessorMethods", "-XX:+OptimizeStringConcat", "-XX:+UseBiasedLocking", "-XX:MaxGCPauseMillis=10", "-XX:+CMSParallelRemarkEnabled", "-XX:+UseConcMarkSweepGC", "-XX:+CMSIncrementalPacing", "-Xincgc", "-Djava.net.preferIPv4Stack=true", "-Djline.terminal=jline.UnsupportedTerminal", "-jar", "/app/minecraftsrv.jar", "-o", "false", "nogui" ]

#    "-XX:ParallelGCThreads=10", 
#    "-XX:ParallelGCThreads=2", 
