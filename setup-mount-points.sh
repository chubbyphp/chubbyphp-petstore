#!/bin/sh
# Creates every file/dir that docker-compose.yml bind-mounts, so docker does not
# turn missing files into directories. Existing files are never overwritten.
#
# Shell, git, ssh and npm files live in the host home (~), the coding agent
# (LLM) dirs live in .home within this repository (git-ignored).
set -eu

LLM_HOME="$(cd "$(dirname "$0")" && pwd)/.home"

# writes stdin into the given file, unless it already exists
seed() {
    if [ -f "$1" ]; then
        cat > /dev/null
    else
        cat > "$1"
    fi
}

# bash
touch ~/.bash_docker
touch ~/.bash_history

# zsh
touch ~/.zsh_docker
touch ~/.zsh_history

# git
touch ~/.gitconfig
touch ~/.gitignore

# ssh
mkdir -p ~/.ssh
touch ~/.ssh/github.pub

# npm
touch ~/.npmrc

# antigravity (lives within ~/.gemini, next to gemini, plus ~/.config/antigravity)
mkdir -p "$LLM_HOME/.gemini/antigravity-cli" "$LLM_HOME/.config/antigravity"

seed "$LLM_HOME/.gemini/antigravity-cli/settings.json" <<'EOF'
{
    "allowNonWorkspaceAccess": true,
    "colorScheme": "terminal",
    "showTips": false,
    "toolPermission": "always-proceed",
    "trustedWorkspaces": [
        "/app"
    ]
}
EOF

chmod 700 \
    "$LLM_HOME/.gemini/antigravity-cli" \
    "$LLM_HOME/.config/antigravity"
chmod 600 "$LLM_HOME/.gemini/antigravity-cli/settings.json"

# claude
mkdir -p "$LLM_HOME/.claude"

seed "$LLM_HOME/.claude/settings.json" <<'EOF'
{
    "fileCheckpointingEnabled": false,
    "permissions": {
        "defaultMode": "bypassPermissions"
    },
    "skipDangerousModePermissionPrompt": true,
    "spinnerTipsEnabled": false,
    "switchModelsOnFlag": false,
    "theme": "auto"
}
EOF

chmod 700 "$LLM_HOME/.claude"
chmod 600 "$LLM_HOME/.claude/settings.json"

# codex
mkdir -p "$LLM_HOME/.codex"

seed "$LLM_HOME/.codex/config.toml" <<'EOF'
approval_policy = "never"
sandbox_mode = "danger-full-access"

[notice]
hide_full_access_warning = true
EOF

chmod 700 "$LLM_HOME/.codex"
chmod 600 "$LLM_HOME/.codex/config.toml"

# gemini
mkdir -p "$LLM_HOME/.gemini"

seed "$LLM_HOME/.gemini/settings.json" <<'EOF'
{
    "general": {
        "checkpointing": {
            "enabled": false
        }
    },
    "security": {
        "disableYoloMode": false,
        "folderTrust": {
            "enabled": false
        }
    },
    "ui": {
        "autoThemeSwitching": true,
        "hideTips": true
    }
}
EOF

chmod 700 "$LLM_HOME/.gemini"
chmod 600 "$LLM_HOME/.gemini/settings.json"

# opencode
mkdir -p "$LLM_HOME/.config/opencode" "$LLM_HOME/.local/share/opencode"

seed "$LLM_HOME/.config/opencode/opencode.jsonc" <<'EOF'
{
    "$schema": "https://opencode.ai/config.json",
    "permission": {
        "*": "allow"
    }
}
EOF

seed "$LLM_HOME/.config/opencode/tui.json" <<'EOF'
{
    "$schema": "https://opencode.ai/tui.json",
    "theme": "system",
    "tips": false
}
EOF

chmod 700 \
    "$LLM_HOME/.config/opencode" \
    "$LLM_HOME/.local/share/opencode"
chmod 600 \
    "$LLM_HOME/.config/opencode/opencode.jsonc" \
    "$LLM_HOME/.config/opencode/tui.json"

# pi (configured packages get installed on startup)
mkdir -p "$LLM_HOME/.pi/agent"

seed "$LLM_HOME/.pi/agent/settings.json" <<'EOF'
{
    "packages": [
        "git:github.com/huggingface/pi-llama"
    ]
}
EOF

chmod 700 "$LLM_HOME/.pi/agent"
chmod 600 "$LLM_HOME/.pi/agent/settings.json"
