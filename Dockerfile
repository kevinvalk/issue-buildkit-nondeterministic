# NOTES:
# - A minimum of three COPY statements are required, with more than 3 the problem compounds and happens more often
#   - When switched from node:16-bullseye-slim to alpine the minimum COPY statements increased to 4...
# - It does not matter if you are using --link yes or not
# - It does not matter if they are from the same `--from` or different `--from`
# - If you are using `COPY --from=scratch / /` the problem does not show up, so a minimum of a file needs to exist
# - The frontend used does not matter (example `# syntax=docker/dockerfile:1.4`)

FROM scratch as technologies

COPY --from=alpine:3.16.2 / /
COPY --from=alpine:3.16.2 / /
COPY --from=alpine:3.16.2 / /
COPY --from=alpine:3.16.2 / /
COPY --from=alpine:3.16.2 / /
COPY --from=alpine:3.16.2 / /
COPY --from=alpine:3.16.2 / /
COPY --from=alpine:3.16.2 / /
