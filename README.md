# Non deterministic output of `moby.buildkit.cache.v0`

When using inline cache using BuildKit the final image hash becomes nondeterministic under certain conditions. I observed that the `link` identifiers in `moby.buildkit.cache.v0` are not given deterministic and may "randomly" switch between caches.

The problem does NOT happen when using `DOCKER_BUILDKIT=1 BUILDKIT_INLINE_CACHE=1 docker build -t test .`

The problem DOES happen when using `docker compose build` OR `docker buildx build --cache-to type=inline -t test --load .`

## Output

### docker build

```
[+] Building 0.2s (12/12) FINISHED
 => [internal] load build definition from Dockerfile
 => => transferring dockerfile: 37B
 => [internal] load .dockerignore
 => => transferring context: 2B
 => FROM docker.io/library/alpine:3.16.2
 => => resolve docker.io/library/alpine:3.16.2
 => CACHED [technologies 1/8] COPY --from=alpine:3.16.2 / /
 => CACHED [technologies 2/8] COPY --from=alpine:3.16.2 / /
 => CACHED [technologies 3/8] COPY --from=alpine:3.16.2 / /
 => CACHED [technologies 4/8] COPY --from=alpine:3.16.2 / /
 => CACHED [technologies 5/8] COPY --from=alpine:3.16.2 / /
 => CACHED [technologies 6/8] COPY --from=alpine:3.16.2 / /
 => CACHED [technologies 7/8] COPY --from=alpine:3.16.2 / /
 => CACHED [technologies 8/8] COPY --from=alpine:3.16.2 / /
 => exporting to image
 => => exporting layers
 => => writing image sha256:cb99842b51d9a9c4020a0058e061330c7577226d224ecab3df39eedefd755e4c
 => => naming to docker.io/library/test
```

```
[+] Building 0.6s (12/12) FINISHED
 => [internal] load build definition from Dockerfile
 => => transferring dockerfile: 37B
 => [internal] load .dockerignore
 => => transferring context: 2B
 => FROM docker.io/library/alpine:3.16.2
 => => resolve docker.io/library/alpine:3.16.2
 => CACHED [technologies 1/8] COPY --from=alpine:3.16.2 / /
 => CACHED [technologies 2/8] COPY --from=alpine:3.16.2 / /
 => CACHED [technologies 3/8] COPY --from=alpine:3.16.2 / /
 => CACHED [technologies 4/8] COPY --from=alpine:3.16.2 / /
 => CACHED [technologies 5/8] COPY --from=alpine:3.16.2 / /
 => CACHED [technologies 6/8] COPY --from=alpine:3.16.2 / /
 => CACHED [technologies 7/8] COPY --from=alpine:3.16.2 / /
 => CACHED [technologies 8/8] COPY --from=alpine:3.16.2 / /
 => exporting to image
 => => exporting layers
 => => writing image sha256:cb99842b51d9a9c4020a0058e061330c7577226d224ecab3df39eedefd755e4c
 => => naming to docker.io/library/test
```

### docker buildx build

```
[+] Building 0.3s (15/15) FINISHED
 => [internal] load .dockerignore
 => => transferring context: 2B
 => [internal] load build definition from Dockerfile
 => => transferring dockerfile: 871B
 => [internal] load metadata for docker.io/library/alpine:3.16.2
 => FROM docker.io/library/alpine:3.16.2@sha256:bc41182d7ef5ffc53a40b044e725193bc10142a1243f395ee852a8d9730fc2ad
 => => resolve docker.io/library/alpine:3.16.2@sha256:bc41182d7ef5ffc53a40b044e725193bc10142a1243f395ee852a8d9730fc2ad
 => CACHED [technologies 1/8] COPY --from=alpine:3.16.2 / /
 => CACHED [technologies 2/8] COPY --from=alpine:3.16.2 / /
 => CACHED [technologies 3/8] COPY --from=alpine:3.16.2 / /
 => CACHED [technologies 4/8] COPY --from=alpine:3.16.2 / /
 => CACHED [technologies 5/8] COPY --from=alpine:3.16.2 / /
 => CACHED [technologies 6/8] COPY --from=alpine:3.16.2 / /
 => CACHED [technologies 7/8] COPY --from=alpine:3.16.2 / /
 => CACHED [technologies 8/8] COPY --from=alpine:3.16.2 / /
 => preparing layers for inline cache
 => exporting to oci image format
 => => exporting layers
 => => exporting manifest sha256:3dbd0d4f9f77de69368520395f2e32de84fde3a803239a65f1563d0fcd0bf723
 => => exporting config sha256:79416b366dc469cd54497924db5f7a4031e7a5e24964b7c56f4598cb3f382b65
 => => sending tarball
 => importing to docker
```

```
[+] Building 1.7s (15/15) FINISHED
 => [internal] load .dockerignore
 => => transferring context: 2B
 => [internal] load build definition from Dockerfile
 => => transferring dockerfile: 871B
 => [internal] load metadata for docker.io/library/alpine:3.16.2
 => FROM docker.io/library/alpine:3.16.2@sha256:bc41182d7ef5ffc53a40b044e725193bc10142a1243f395ee852a8d9730fc2ad
 => => resolve docker.io/library/alpine:3.16.2@sha256:bc41182d7ef5ffc53a40b044e725193bc10142a1243f395ee852a8d9730fc2ad
 => CACHED [technologies 1/8] COPY --from=alpine:3.16.2 / /
 => CACHED [technologies 2/8] COPY --from=alpine:3.16.2 / /
 => CACHED [technologies 3/8] COPY --from=alpine:3.16.2 / /
 => CACHED [technologies 4/8] COPY --from=alpine:3.16.2 / /
 => CACHED [technologies 5/8] COPY --from=alpine:3.16.2 / /
 => CACHED [technologies 6/8] COPY --from=alpine:3.16.2 / /
 => CACHED [technologies 7/8] COPY --from=alpine:3.16.2 / /
 => CACHED [technologies 8/8] COPY --from=alpine:3.16.2 / /
 => preparing layers for inline cache
 => exporting to oci image format
 => => exporting layers
 => => exporting manifest sha256:95eb4ee4ed7d64674d036c074eb2b3bdbecf4f6838686263510faaaf6c17131d
 => => exporting config sha256:6c409f3f5ef782f41dfe1c07c0871be1342e7e92cde92d976811f1c70aaf0715
 => => sending tarball
 => importing to docker
```

### docker compose build

```
[+] Building 0.2s (13/13) FINISHED
 => [internal] load build definition from Dockerfile
 => => transferring dockerfile: 32B
 => [internal] load .dockerignore
 => => transferring context: 2B
 => FROM docker.io/library/alpine:3.16.2
 => => resolve docker.io/library/alpine:3.16.2
 => CACHED [technologies 1/8] COPY --from=alpine:3.16.2 / /
 => CACHED [technologies 2/8] COPY --from=alpine:3.16.2 / /
 => CACHED [technologies 3/8] COPY --from=alpine:3.16.2 / /
 => CACHED [technologies 4/8] COPY --from=alpine:3.16.2 / /
 => CACHED [technologies 5/8] COPY --from=alpine:3.16.2 / /
 => CACHED [technologies 6/8] COPY --from=alpine:3.16.2 / /
 => CACHED [technologies 7/8] COPY --from=alpine:3.16.2 / /
 => CACHED [technologies 8/8] COPY --from=alpine:3.16.2 / /
 => exporting to image
 => => exporting layers
 => => writing image sha256:cdce2600045a9759ee61964c19351d89ee22384fc455dbaea510459b34c9bff2
 => => naming to docker.io/library/problem-nondeterministic
 => exporting cache
 => => preparing build cache for export
```

```
[+] Building 1.1s (13/13) FINISHED
 => [internal] load build definition from Dockerfile
 => => transferring dockerfile: 32B
 => [internal] load .dockerignore
 => => transferring context: 2B
 => FROM docker.io/library/alpine:3.16.2
 => => resolve docker.io/library/alpine:3.16.2
 => CACHED [technologies 1/8] COPY --from=alpine:3.16.2 / /
 => CACHED [technologies 2/8] COPY --from=alpine:3.16.2 / /
 => CACHED [technologies 3/8] COPY --from=alpine:3.16.2 / /
 => CACHED [technologies 4/8] COPY --from=alpine:3.16.2 / /
 => CACHED [technologies 5/8] COPY --from=alpine:3.16.2 / /
 => CACHED [technologies 6/8] COPY --from=alpine:3.16.2 / /
 => CACHED [technologies 7/8] COPY --from=alpine:3.16.2 / /
 => CACHED [technologies 8/8] COPY --from=alpine:3.16.2 / /
 => exporting to image
 => => exporting layers
 => => writing image sha256:a90b4160e0690cd6aa0b08dbfcda438c97bb4a65212db0bdeb93fee6844d5363
 => => naming to docker.io/library/problem-nondeterministic
 => exporting cache
 => => preparing build cache for export
```

## Version

```
docker version
Client:
 Cloud integration: v1.0.29
 Version:           20.10.17
 API version:       1.41
 Go version:        go1.17.11
 Git commit:        100c701
 Built:             Mon Jun  6 23:04:45 2022
 OS/Arch:           darwin/arm64
 Context:           default
 Experimental:      true

Server: Docker Desktop 4.12.0 (85629)
 Engine:
  Version:          20.10.17
  API version:      1.41 (minimum version 1.12)
  Go version:       go1.17.11
  Git commit:       a89b842
  Built:            Mon Jun  6 23:01:01 2022
  OS/Arch:          linux/arm64
  Experimental:     false
 containerd:
  Version:          1.6.8
  GitCommit:        9cd3357b7fd7218e4aec3eae239db1f68a5a6ec6
 runc:
  Version:          1.1.4
  GitCommit:        v1.1.4-0-g5fd4c4d
 docker-init:
  Version:          0.19.0
  GitCommit:        de40ad0
```
