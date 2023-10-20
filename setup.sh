#!/bin/bash

# 設定要被替換的原始字串
OrigStr="yjring"

# 讀取 dockerAccount 並存入 ＄DOCKER_ACCOUNT 變數
#eval $(cat env.yaml | sed -n 's/^[ \t]*dockerAccount:[ \t]*\([^ \t]*\).*$/DOCKER_ACCOUNT="\1"/p')
eval $(cat env.yaml | sed -n 's/^[ \t]*dockerAccount:[ \t]*\([^[:space:]]*\)[ \t]*$/DOCKER_ACCOUNT="\1"/p')

# 讀取 os 並存入 $OS_ARCH 變數
eval $(cat env.yaml | sed -n 's/^[ \t]*os:[ \t]*\(.*\)[ \t]*$/OS_ARCH="\1"/p')

case "$OS_ARCH" in
    arm|arm64)
        PLATFORMS="linux/arm64"
        ;;
    amd|amd64)
        PLATFORMS="linux/amd64"
        ;;
    *)
        PLATFORMS="linux/amd64,linux/arm64"
        ;;
esac

# 進入到 ./github/workflows/ 
cd .github/workflows/

# 列出要處理的檔案
files=("1_dev_backend_ci.yaml" "2_dev_frontend_ci.yaml" "4_uat_backend_ci.yaml" "5_uat_frontend_ci.yaml")

# 更換Github Action中的 image檔案名稱
for file in "${files[@]}"; do
    # 使用 sed 來替換 IMAGE_NAME: $OrigStr 為 IMAGE_NAME: $DockerAcc
    sed -i "" "s/IMAGE_NAME: $OrigStr/IMAGE_NAME: $DOCKER_ACCOUNT/g" "$file"
    sed -i "" "s|platforms:.*|platforms: ${PLATFORMS}|g" "$file"
    # 印出已修改完成的檔案名
    echo "Modified: $file"
done