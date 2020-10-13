FROM debian:sid
RUN apt-get update && apt-get -y install \
        openjdk-11-jre \
        apt-transport-https locales-all libpng16-16 libxinerama1 libgl1-mesa-glx libfontconfig1 libfreetype6 libxrender1 \
        libxcb-shm0 libxcb-render0 adduser cpio findutils \
        procps \
    && apt-get -y install libreoffice --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update \ 
	&& apt-get -y install --no-install-recommends dos2unix libfontconfig1 \
	&& rm -rf /var/lib/apt/lists/*

# Make homedir
RUN mkdir -p /app
# Export APP_HOME
ENV APP_HOME /app


ENV USER=java
ENV UID=102
ENV GID=102

RUN groupadd --gid $GID --system java 
RUN adduser --system --no-create-home --disabled-password --gecos "" --home "$APP_HOME" --ingroup "$USER" --no-create-home --uid "$UID" "$USER"

# Adding group / user with ID 102
#RUN groupadd --gid 102 --system java \
#  && adduser --system --no-create-home --uid 102 --home $APP_HOME --shell /sbin/nologin java -c java

RUN chown -R 102:102 $APP_HOME \
  && chmod -R 755 $APP_HOME

COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh
RUN dos2unix /usr/local/bin/entrypoint.sh

USER java

EXPOSE 8080 9090 8000

COPY target/*.jar $APP_HOME/app.jar
ENV JAVA_OPTS "-showversion"

## Enable Disable Remote debugging by changing the bit of DEBUG
#ENV DEBUG "true"

ENTRYPOINT [ "entrypoint.sh" ]
CMD java $JAVA_OPTS -jar $APP_HOME/app.jar
