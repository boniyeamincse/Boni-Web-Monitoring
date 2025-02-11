FROM grafana/grafana:latest

COPY grafana.ini /etc/grafana/
COPY datasources /etc/grafana/provisioning/datasources/

USER root
RUN chown -R grafana:grafana /etc/grafana/provisioning/datasources/
USER grafana 