FROM golang:1.19-bullseye as build

RUN git clone https://github.com/grafana/mimir-proxies.git
RUN cd mimir-proxies && make build

FROM gcr.io/distroless/static AS final
COPY --from=build /go/mimir-proxies/dist/graphite-proxy-writes /graphite-proxy-writes
EXPOSE 8000
ENTRYPOINT ["/graphite-proxy-writes"]
CMD []
