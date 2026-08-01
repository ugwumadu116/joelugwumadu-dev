# Static site, so there is nothing to build — nginx serves the files directly.
FROM nginx:1.27-alpine

# Coolify's healthcheck shells out to curl and only falls back to busybox wget;
# without curl a healthy container is judged unhealthy on a missing binary.
# (This is the same trap that rolled back the router's first deploy — N10.)
RUN apk add --no-cache curl

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY site /usr/share/nginx/html

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
  CMD curl -fsS http://127.0.0.1:8080/ >/dev/null || exit 1
