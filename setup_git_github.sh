#!/bin/bash
# 用户输入
read -p "请输入你的 GitHub 用户名: " github_user
read -p "请输入你 GitHub 绑定的邮箱: " github_email
# 配置 git
git config --global user.name "$github_user"
git config --global user.email "$github_email"
echo "Git 用户名和邮箱已配置。"
# 创建 SSH key（如果不存在）
SSH_KEY=~/.ssh/id_ed25519
if [ -f "$SSH_KEY" ]; then
    echo "SSH 密钥已存在，跳过生成。"
else
    ssh-keygen -t ed25519 -C "$github_email" -f "$SSH_KEY" -N ""
    echo "SSH 密钥已生成。"
fi
# 启动 ssh-agent 并添加 key
eval "$(ssh-agent -s)"
ssh-add "$SSH_KEY"
echo "SSH key 已添加到 ssh-agent。"
# 显示公钥内容
echo "复制以下 SSH 公钥并添加到 GitHub（https://github.com/settings/ssh）："
echo "------------------------------------------------------------"
cat "${SSH_KEY}.pub"
echo "------------------------------------------------------------"
# 测试连接
echo "你可以运行以下命令测试连接："
echo "ssh -T git@github.com"
echo "完成。请手动将公钥添加到 GitHub，然后即可使用 git push。"
