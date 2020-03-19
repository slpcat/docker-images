FROM golang:1.8-alpine as builder

RUN apk update && apk upgrade && \
	apk add --no-cache git
RUN go get -u sourcegraph.com/sourcegraph/appdash/cmd/...

FROM alpine:3.5  

RUN apk --no-cache add ca-certificates
WORKDIR /
COPY --from=builder /go/bin/appdash .

EXPOSE 7700
EXPOSE 7701

CMD ["/appdash", "serve"]  

