FROM grafana/agent:v0.27.0 as build
FROM ubuntu:jammy AS final
RUN apt-get update && apt-get install -qy libsystemd-dev tzdata ca-certificates && \
  if [ `uname -m` = "x86_64" ]; then apt-get install -qy libbpfcc; fi && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
COPY --from=build /bin/agent /bin/agent
COPY agent-local-config.yaml /etc/agent/agent.yaml
EXPOSE 12345
ENTRYPOINT ["/bin/agent"]
CMD ["--config.file=/etc/agent/agent.yaml", "--metrics.wal-directory=/etc/agent/data"]
