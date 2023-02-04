#!/bin/bash

COMMIT_SHA_1=$(jq -r '.commit.sha' <<<$(curl https://api.github.com/repos/outloudvi/misskey/branches/feat/nanoid-filename))
COMMIT_SHA_2=$(jq -r '.commit.sha' <<<$(curl https://api.github.com/repos/outloudvi/misskey/branches/feat/i-5964))

cat >0001-add-nanoid-filename.patch <<EOF
diff --git a/Dockerfile b/Dockerfile
index aaaaaaaaaa..bbbbbbbbbb 100644
--- a/Dockerfile
+++ b/Dockerfile
@@ -28,6 +28,11 @@ COPY . ./
 ARG NODE_ENV=production
 
 RUN git submodule update --init
+# feat/nanoid-filename
+RUN wget -O - https://github.com/outloudvi/misskey/commit/${COMMIT_SHA_1}.patch | git apply && \\
+# feat/i-5964
+    wget -O - https://github.com/outloudvi/misskey/commit/${COMMIT_SHA_2}.patch | git apply && \\
+    pnpm install
 RUN pnpm build
 
 FROM node:${NODE_VERSION}-slim AS runner
EOF
