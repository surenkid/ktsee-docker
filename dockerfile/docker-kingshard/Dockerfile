FROM golang:1.13.8 as builder
WORKDIR /go/src/app
COPY . .
RUN CGO_ENABLED=0 make

FROM alpine:3.11.3

# Change timezone to Asia/Shanghai
RUN apk add tzdata && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
  && echo "Asia/Shanghai" > /etc/timezone \
  && apk del tzdata

RUN mkdir -p /etc/kingshard

COPY --from=builder /go/src/app/bin/kingshard /usr/local/bin/
COPY --from=builder /go/src/app/etc/ks.yaml /etc/kingshard/
CMD kingshard -config=/etc/kingshard/ks.yaml