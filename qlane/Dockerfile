# qlane test target: builds Vikunja (Go API + embedded Vue frontend) from this repository's source.
# Differs from the upstream Dockerfile only where the test target needs it: the final stage is Alpine instead of
# scratch, so the container has a shell (the ai.qlane.postdeploy hook runs `sh -c`) and the CLI can be exec'd.
# No step reaches the network at runtime.

FROM node:24-alpine AS frontend
WORKDIR /build
ENV PNPM_CACHE_FOLDER=.cache/pnpm/ PUPPETEER_SKIP_DOWNLOAD=true CYPRESS_INSTALL_BINARY=0
COPY frontend/pnpm-lock.yaml frontend/package.json frontend/pnpm-workspace.yaml ./
RUN npm install -g corepack && corepack enable && pnpm install --frozen-lockfile
COPY frontend/ ./
RUN echo '{"VERSION": "v2.7.0-qlane"}' > src/version.json && pnpm run build

FROM golang:1.27-alpine AS api
WORKDIR /src
COPY go.mod go.sum ./
RUN go mod download
COPY . ./
COPY --from=frontend /build/dist ./frontend/dist
# cgo on, as upstream builds it: the sqlite driver is compiled in even though this stack runs on Postgres
# (pkg/errorreport references it). The binary links musl, which the Alpine runtime below provides.
RUN apk add --no-cache gcc musl-dev
RUN CGO_ENABLED=1 go build -tags osusergo -trimpath \
      -ldflags '-s -w -X "code.vikunja.io/api/pkg/version.Version=v2.7.0-qlane"' -o /out/vikunja .

FROM alpine:3.22
RUN addgroup -g 1000 vikunja && adduser -D -u 1000 -G vikunja vikunja \
 && mkdir -p /app/vikunja/files && chown -R 1000:1000 /app/vikunja
WORKDIR /app/vikunja
COPY --from=api /out/vikunja /app/vikunja/vikunja
COPY --chmod=0755 qlane/seed-users.sh /usr/local/bin/qlane-seed-users
ENV VIKUNJA_SERVICE_ROOTPATH=/app/vikunja/ PATH=/app/vikunja:$PATH
USER 1000
EXPOSE 3456
ENTRYPOINT ["/app/vikunja/vikunja"]
