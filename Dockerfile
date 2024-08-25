FROM archlinux:latest

# Install base ****
RUN pacman -Syu --noconfirm \
    base-devel \
    git \
    make \
    python \
    python-pip \
    rust \
    sudo \
    vim \
    neovim \
    tmux \
    wget \
    curl \
    fish \
    act \
    starship \
    nodejs \
    stow

RUN pacman -Scc --noconfirm
RUN rm -rf /var/cache/pacman/pkg/*

RUN useradd -m -G wheel -s /usr/bin/fish inter
RUN echo "inter ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
USER inter
WORKDIR /home/inter
RUN mkdir -p /home/inter/DontGoogleTwice

# Install paru
RUN git clone https://aur.archlinux.org/paru.git && cd paru && makepkg -si --noconfirm

# I need python 3.10 for work
RUN paru -S --noconfirm python310

# Install tpm
RUN git clone https://github.com/tmux-plugins/tpm /home/inter/.tmux/plugins/tpm

RUN paru -S --noconfirm \
    npm \
    lolcat \
    yazi

RUN sudo npm install -g neovim yarn

# Copy config
RUN git clone https://github.com/kowalskiexe/dotfiles.git && cd dotfiles && stow .

RUN /home/inter/.tmux/plugins/tpm/bin/install_plugins

CMD fish
