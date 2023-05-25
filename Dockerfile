FROM 16-alpine AS builder
WORKDIR /

COPY package.json ./
COPY yarn.lock ./
COPY public ./public
COPY server ./server
COPY src ./src
RUN yarn --frozen-lockfile
RUN yarn build
RUN chmod 755 ./index-*

FROM alpine:latest 
RUN apk --no-cache add ca-certificates
WORKDIR /
COPY --from=builder /build ./build
COPY --from=builder /index-alpine ./mikanarr
EXPOSE 12306
VOLUME /data
CMD ["./mikanarr"]
