#!/bin/sh
# 推送到 GitHub（绕过 WorkBuddy 环境的代理与凭据选择器）
cd "$(dirname "$0")" || exit 1
unset HTTP_PROXY HTTPS_PROXY http_proxy https_proxy ALL_PROXY
git -c http.proxy=http://127.0.0.1:7890 \
    -c https.proxy=http://127.0.0.1:7890 \
    -c credential.helper=wincred \
    add -A
git -c credential.helper=wincred commit -m "笔记同步：$(date '+%Y-%m-%d %H:%M:%S')"
git -c http.proxy=http://127.0.0.1:7890 \
    -c https.proxy=http://127.0.0.1:7890 \
    -c credential.helper=wincred \
    -c credential.helperSelectors.selected=manager \
    push origin main
