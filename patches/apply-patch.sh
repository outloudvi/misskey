#!/bin/bash

apply_patch() {
    COMMIT_SHA=$(jq -r '.commit.sha' <<<$(curl https://api.github.com/repos/outloudvi/misskey/branches/$1))
    echo "Applying branch $1 (SHA1: ${COMMIT_SHA})"
    wget -O - https://github.com/outloudvi/misskey/commit/${COMMIT_SHA}.patch | git apply
}

apply_patch feat/deps
apply_patch feat/nanoid-filename
