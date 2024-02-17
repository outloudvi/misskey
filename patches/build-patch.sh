#!/bin/bash

COMMIT_SHA_1=$(jq -r '.commit.sha' <<<$(curl https://api.github.com/repos/outloudvi/misskey/branches/feat/nanoid-filename))

cat >0001-add-nanoid-filename.patch <<EOF
diff --git a/Dockerfile b/Dockerfile
index aaaaaaaaa..bbbbbbbbb 100644
--- a/Dockerfile
+++ b/Dockerfile
@@ -35,6 +35,8 @@ RUN --mount=type=cache,target=/root/.local/share/pnpm/store,sharing=locked \
 COPY --link . ./
 
 RUN git submodule update --init
+# feat/nanoid-filename
+RUN wget -O - https://github.com/outloudvi/misskey/commit/${COMMIT_SHA_1}.patch | git apply
 RUN pnpm build
 RUN rm -rf .git/
EOF
