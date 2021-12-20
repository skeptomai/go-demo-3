FROM arm64v8/golang:1.16-alpine3.15 AS build
RUN apk add build-base
ADD . /src
WORKDIR /src
RUN go get -d -v -t
RUN go test --cover -v ./... --run UnitTest
RUN go build -v -o go-demo

FROM arm64v8/alpine:3.15
RUN mkdir /lib64 && ln -s /lib/libc.musl-arm64.so.1 /lib64/ld-linux-arm-64.so.2

EXPOSE 8080
ENV DB db
CMD ["go-demo"]

COPY --from=build /src/go-demo /usr/local/bin/go-demo
RUN chmod +x /usr/local/bin/go-demo
