# zplug
source ~/.zplug/init.zsh

# 補完機能
autoload -U compinit
compinit

# プロンプト
# 上段カレントディレクトリ 下段ユーザー名@ホスト名
# プロンプト項目設定: https://qiita.com/yamagen0915/items/77fb78d9c73369c784da
# プロンプト色設定: https://qiita.com/mollifier/items/40d57e1da1b325903659
PROMPT='%F{cyan}%~%f
%F{green}%n@%m $%f '

# バージョン管理システムの表示
# 参考: http://tkengo.github.io/blog/2013/05/12/zsh-vcs-info/
# 参考: https://techblog.recochoku.jp/5644
# 参考: https://qiita.com/ToruIwashita/items/fa114effda34214c9371
# 参考: http://www.sirochro.com/note/terminal-zsh-prompt-customize/
# バージョン管理システム表示用の関数読み込み
autoload -Uz vcs_info 
# unstagedstrやstagedstrをformatに適用可能にする
zstyle ':vcs_info:git:*' check-for-changes true
# ワーキングツリーに編集済みのファイルが存在する状態(編集済みのファイルがあり、addされる前状態)
zstyle ':vcs_info:git:*' unstagedstr "%F{yellow}--working three(please add)--"
# ステージングにファイルが存在する状態(addされた状態)
zstyle ':vcs_info:git:*' stagedstr "%F{magenta}-staging<index>(please commit)-"
# 表示フォーマットの指定(# 色付けあり)
zstyle ':vcs_info:*' formats "%F{green}%c%u[%b]%f"
## アクション時のフォーマットの指定(# 色付けあり)
zstyle ':vcs_info:*' actionformats '[%b|%F{red}%a]'
# プロンプト表示毎にバージョン管理システム情報の取得
precmd () { vcs_info }
# 右に表示
setopt prompt_subst
RPROMPT=$RPROMPT'${vcs_info_msg_0_}'

# ディレクトリ名を入力のみでcd可能に
setopt auto_cd

# lsの色付け
# https://news.mynavi.jp/article/zsh-9/
export LSCOLORS=ehfxcxdxbxegedabagacad
alias ls="ls -G"
zstyle ':completion:*' list-colors 'di=34' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'

# 履歴ファイルの保存先
export HISTFILE=${HOME}/.zsh_history
# メモリ保存の履歴の数
HISTSIZE=10000 
# 履歴ファイル保存の履歴の数
SAVEHIST=10000 
# 補完時に履歴を自動展開         
setopt hist_expand

#履歴のインクリメンタル検索でワイルドカード利用可能
bindkey '^R' history-incremental-pattern-search-backward
bindkey '^S' history-incremental-pattern-search-forward

# 入力途中に履歴から候補を補完
# 参考: https://masutaka.net/chalow/2014-05-18-2.html
autoload -U history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
# control + p
bindkey "^[p" history-beginning-search-backward-end
# control + n
bindkey "^[n" history-beginning-search-forward-end

# 入力補完: https://github.com/zsh-users/zsh-completions
zplug "zsh-users/zsh-completions" 

# 履歴からコマンド候補: zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-autosuggestions"

# シンタックスハイライト: https://github.com/zsh-users/zsh-syntax-highlighting
# compinit 以降に読み込むようにするため、ロードの優先度を2に変更している
zplug "zsh-users/zsh-syntax-highlighting", defer:2

# ヒストリサーチ: https://github.com/zsh-users/zsh-history-substring-search
zplug "zsh-users/zsh-history-substring-search"

#補完候補を詰めて表示
setopt LIST_PACKED
#複数のリダイレクトやパイプに対応
setopt MULTIOS
#履歴がfullの場合はFIFO
setopt HIST_EXPIRE_DUPS_FIRST
#履歴検索で、重複を飛ばす
setopt HIST_FIND_NO_DUPS
#重複する履歴を保持しない
setopt HIST_IGNORE_ALL_DUPS
#履歴を共有
setopt SHARE_HISTORY
#補完時に履歴を自動的に展開
setopt HIST_EXPAND
#Wordの途中でもカーソル位置で補完
setopt COMPLETE_IN_WORD

# anyenv: https://github.com/riywo/anyenv
# env系をまとめて管理
export PATH="$HOME/.anyenv/bin:$PATH"
eval "$(anyenv init -)"

# Go
export GOPATH=$HOME/go
PATH=$PATH:$GOPATH/bin

# GAE/Go
export PATH=$PATH:$HOME/google-cloud-sdk/platform/google_appengine/

# node
export PATH=$PATH:~/.nodebrew/current/bin

# direnv: https://github.com/direnv/direnv
# https://qiita.com/kompiro/items/5fc46089247a56243a62
eval "$(direnv hook zsh)"

# gcloud: https://cloud.google.com/sdk/downloads?hl=JA
# The next line updates PATH for the Google Cloud SDK.
if [ -f '$HOME/google-cloud-sdk/path.zsh.inc' ]; then . '$HOME/google-cloud-sdk/path.zsh.inc'; fi
# The next line enables shell command completion for gcloud.
if [ -f '$HOME/google-cloud-sdk/completion.zsh.inc' ]; then . '$HOME/google-cloud-sdk/completion.zsh.inc'; fi

# 未インストール項目のインストール
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# コマンドのリンク=>PATHの追加=>プラグインの読み込み
zplug load --verbose

# .zshrcを記述するに当たって参考にさせていただいた記事等
# https://github.com/zsh-users
# https://github.com/zplug/zplug/blob/master/doc/guide/ja/README.md
# https://qiita.com/b4b4r07/items/f37aadef0b3f740e8c14
# https://qiita.com/Jung0/items/300f8b83520e56766f22
# https://qiita.com/kotashiratsuka/items/ae37757aa1d31d1d4f4d

// Macのsleep
alias sleep="osascript -e 'tell application \"Finder\" to sleep'"
