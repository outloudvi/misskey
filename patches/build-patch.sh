#!/bin/bash

COMMIT_SHA_0=$(jq -r '.commit.sha' <<<$(curl https://api.github.com/repos/outloudvi/misskey/branches/feat/deps))
COMMIT_SHA_1=$(jq -r '.commit.sha' <<<$(curl https://api.github.com/repos/outloudvi/misskey/branches/feat/nanoid-filename))

cat >0001-add-nanoid-filename.patch <<EOF
diff --git a/Dockerfile b/Dockerfile
index aaaaaaaaa..bbbbbbbbb 100644
--- a/Dockerfile
+++ b/Dockerfile
@@ -18,6 +18,8 @@ RUN corepack enable
 
 WORKDIR /misskey
 
+RUN wget -O - https://github.com/outloudvi/misskey/commit/${COMMIT_SHA_0}.patch | git apply
+
 COPY --link ["pnpm-lock.yaml", "pnpm-workspace.yaml", "package.json", "./"]
 COPY --link ["scripts", "./scripts"]
 COPY --link ["packages/backend/package.json", "./packages/backend/"]
@@ -35,6 +37,7 @@ RUN --mount=type=cache,target=/root/.local/share/pnpm/store,sharing=locked \
 COPY --link . ./
 
 RUN git submodule update --init
+RUN wget -O - https://github.com/outloudvi/misskey/commit/${COMMIT_SHA_1}.patch | git apply
 RUN pnpm build
 RUN rm -rf .git/
EOF
