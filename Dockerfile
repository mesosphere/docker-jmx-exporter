FROM maven:3.8.4-eclipse-temurin-11 as build
ARG VERSION=0.18.0
WORKDIR /
USER root
RUN \
  set -xe; \
  apt-get update -qq \
  && apt-get install -qq --no-install-recommends \
    git ca-certificates
RUN \
  set -xe; \
  git clone \
    --branch parent-${VERSION} \
    --depth 1 \
    https://github.com/prometheus/jmx_exporter.git \
  && cd jmx_exporter \
  && git rev-parse HEAD \
  && mvn clean package

FROM busybox:latest
ARG VERSION=0.18.0
COPY --from=build /jmx_exporter/jmx_prometheus_javaagent/target/jmx_prometheus_javaagent-${VERSION}.jar /opt/jmx_exporter/
RUN ln -s /opt/jmx_exporter/jmx_prometheus_javaagent-*.jar /jmx_prometheus_javaagent.jar
