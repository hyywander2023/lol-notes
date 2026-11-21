#!/bin/sh
# 推送到 GitHub
# 说明：WorkBuddy 环境会注入 HTTPS_PROXY=127.0.0.1:60616（无服务监听），
#       且 PortableGit 的 credential-helper-selector 会弹窗阻塞，故全部绕过。
cd "$(dirname "$0")" || exit 1
unset HTTP_PROXY HTTPS_PROXY http_proxy https_proxy ALL_PROXY
export GIT_TERMINAL_PROMPT=0

PROXY="http://127.0.0.1:7890"
TOKEN=$(printf 'protocol=https\nhost=github.com\n\n' | git credential-wincred get \
        | sed -n 's/^password=//p')

if [ -z "$TOKEN" ]; then
    echo "!! 未取到 GitHub token，请先在 Git 凭据管理器里登录一次" >&2
    exit 1
fi

git add -A
git commit -m "笔记同步：$(date '+%Y-%m-%d %H:%M:%S')" || echo "-- 无变更可提交 --"

git -c http.proxy="$PROXY" -c https.proxy="$PROXY" \
    -c credential.helper= \
    -c "url.https://hyywander2023:$TOKEN@github.com/.insteadOf=https://github.com/" \
    push origin main
