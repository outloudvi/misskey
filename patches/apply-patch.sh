#!/bin/bash
set -eu

PACKAGES_TO_INSTALL=(
    "frontend:nanoid"
)

apply_patch() {
    COMMIT_SHA=$(jq -r '.commit.sha' <<<$(curl https://api.github.com/repos/outloudvi/misskey/branches/$1))
    echo "Applying branch $1 (SHA1: ${COMMIT_SHA})"
    wget -O - https://github.com/outloudvi/misskey/commit/${COMMIT_SHA}.patch | git apply
}

apply_packages() {
    for i in "${PACKAGES_TO_INSTALL[@]}"; do
        DIR=$(echo "$i" | cut -d":" -f 1)
        PACKS=$(echo "$i" | cut -d":" -f 2)
        pushd "packages/$DIR"
        for j in $(echo "$PACKS" | tr ',' '\n'); do
            echo Installing "$j" to "$DIR"
            npx pnpm@8 install "$j"
        done
        popd
    done
}

post_apply_packages() {
    rm -rf **/node_modules
}

shopt -s globstar
apply_packages
post_apply_packages
apply_patch feat/nanoid-filename
apply_patch feat/fe-debug
shopt -u globstar
