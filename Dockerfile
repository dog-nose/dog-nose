FROM ubuntu:22.04

# 環境変数の設定
ENV DEBIAN_FRONTEND=noninteractive
ENV SHELL=/bin/zsh
ENV HOME=/root

# 基本パッケージのインストール
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    make \
    build-essential \
    software-properties-common \
    ca-certificates \
    gnupg \
    lsb-release \
    locales \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# 日本語ロケール設定
RUN locale-gen ja_JP.UTF-8
ENV LANG=ja_JP.UTF-8
ENV LANGUAGE=ja_JP:ja
ENV LC_ALL=ja_JP.UTF-8

# 作業ディレクトリの設定
WORKDIR /workspace

# リポジトリをコピー
COPY . .

# デフォルトシェルをzshに変更
RUN chsh -s /bin/zsh

# テスト用のエントリーポイント
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

# ghq用のディレクトリを作成
RUN mkdir -p /root/src/github.com/dog-nose

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/bin/bash"]