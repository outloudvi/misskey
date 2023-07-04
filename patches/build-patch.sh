#!/bin/bash

COMMIT_SHA_1=$(jq -r '.commit.sha' <<<$(curl https://api.github.com/repos/outloudvi/misskey/branches/feat/nanoid-filename))

cat >0001-add-nanoid-filename.patch <<EOF
diff --git a/Dockerfile b/Dockerfile
index aaaaaaaaa..bbbbbbbbb 100644
--- a/Dockerfile
+++ b/Dockerfile
@@ -24,11 +24,13 @@ COPY --link ["packages/backend/package.json", "./packages/backend/"]
 COPY --link ["packages/frontend/package.json", "./packages/frontend/"]
 COPY --link ["packages/sw/package.json", "./packages/sw/"]
 COPY --link ["packages/misskey-js/package.json", "./packages/misskey-js/"]
+COPY --link . ./
 
+# feat/nanoid-filename
 RUN --mount=type=cache,target=/root/.local/share/pnpm/store,sharing=locked \\
-	pnpm i --frozen-lockfile --aggregate-output
-
-COPY --link . ./
+	wget -O - https://github.com/outloudvi/misskey/commit/${COMMIT_SHA_1}.patch | git apply && \\
+	pnpm i --frozen-lockfile --aggregate-output && \\
+	cd packages/frontend && pnpm i --save nanoid
 
 ARG NODE_ENV=production
 
EOF
