#!/bin/bash

COMMIT_SHA_1=$(jq -r '.commit.sha' <<<$(curl https://api.github.com/repos/outloudvi/misskey/branches/feat/nanoid-filename))

cat >0001-add-nanoid-filename.patch <<EOF
diff --git a/Dockerfile b/Dockerfile
index aaaaaaaaa..bbbbbbbbb 100644
--- a/Dockerfile
+++ b/Dockerfile
@@ -32,6 +32,9 @@ COPY --link . ./
 
 ARG NODE_ENV=production
 
+# feat/nanoid-filename
+RUN wget -O - https://github.com/outloudvi/misskey/commit/${COMMIT_SHA_1}.patch | git apply && \\
+	pnpm i
 RUN git submodule update --init
 RUN pnpm build
 RUN rm -rf .git/
EOF
