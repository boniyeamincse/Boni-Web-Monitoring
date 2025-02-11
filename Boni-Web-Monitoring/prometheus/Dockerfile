FROM prom/prometheus:latest

COPY prometheus.yml /etc/prometheus/
COPY rules.yml /etc/prometheus/
COPY alertmanager.yml /etc/alertmanager/

USER root
RUN chmod 777 /prometheus && \
    chmod 777 /etc/prometheus/

USER nobody 