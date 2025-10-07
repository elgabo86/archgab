FROM quay.io/toolbx/arch-toolbox:latest AS archgab

# Install custom sh
COPY customperso.sh /etc/profile.d/

# Create build user
RUN sed -i 's/#Color/Color/g' /etc/pacman.conf && \
    printf "[multilib]\nInclude = /etc/pacman.d/mirrorlist\n" | tee -a /etc/pacman.conf && \
    sed -i 's/#MAKEFLAGS="-j2"/MAKEFLAGS="-j$(nproc)"/g' /etc/makepkg.conf && \
    pacman-key --init && pacman-key --populate && \
    pacman -Syu --noconfirm && \
    useradd -m --shell=/bin/bash build && usermod -L build && \
    echo "build ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    echo "root ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Distrobox Integration
RUN git clone https://github.com/89luca89/distrobox.git --single-branch /tmp/distrobox && \
    cp /tmp/distrobox/distrobox-host-exec /usr/bin/distrobox-host-exec && \
    ln -s /usr/bin/distrobox-host-exec /usr/bin/flatpak && \
    wget https://github.com/1player/host-spawn/releases/download/$(cat /tmp/distrobox/distrobox-host-exec | grep host_spawn_version= | cut -d "\"" -f 2)/host-spawn-$(uname -m) -O /usr/bin/host-spawn && \
    chmod +x /usr/bin/host-spawn && \
    rm -drf /tmp/distrobox

# Add Chaotic-aur
RUN pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com && \
    pacman-key --lsign-key 3056513887B78AEB && \
    pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst' --noconfirm && \
    echo '[chaotic-aur]' >> /etc/pacman.conf && \
    echo 'Include = /etc/pacman.d/chaotic-mirrorlist' >> /etc/pacman.conf && \
    pacman -Syu --noconfirm

# Install packages Distrobox adds automatically, this speeds up first launch
RUN pacman -S \
        adw-gtk-theme \
        bash-completion \
        bc \
        curl \
        diffutils \
        findutils \
        glibc \
        gnupg \
        inetutils \
        keyutils \
        less \
        lsof \
        man-db \
        man-pages \
        mesa \
        mlocate \
        mtr \
        ncurses \
        nss-mdns \
        opengl-driver \
        openssh \
        pigz \
        pinentry \
        procps-ng \
        rsync \
        shadow \
        sudo \
        tcpdump \
        time \
        traceroute \
        tree \
        tzdata \
        unzip \
        util-linux \
        util-linux-libs \
        vte-common \
        vulkan-intel \
        vulkan-radeon \
        wget \
        words \
        xorg-xauth \
        zip \
        --noconfirm && \
    rm -rf /var/cache/pacman/pkg/*

# Install custom packages
RUN pacman -S \
    base-devel \
    git \
    nano \
    pkgfile \
    fastfetch \
    pipewire \
    pipewire-pulse \
    pipewire-alsa \
    pipewire-jack \
    wireplumber \
    mangohud \
    btop \
    pyenv \
    atuin \
    tk \
    blesh \
    downgrade \
    fuse2 \
    gnu-free-fonts \
    xdvdfs \
    --noconfirm

# Add paru and install AUR packages
USER build
WORKDIR /home/build
RUN git clone https://aur.archlinux.org/paru-bin.git --single-branch && \
    cd paru-bin && \
    makepkg -si --noconfirm && \
    cd .. && \
    rm -drf paru-bin && \
    paru -S \
        tochd \
        --noconfirm
USER root
WORKDIR /

# Add some custom ln silverblue (test)
RUN ln -s /run/host/var/data1 /var
RUN ln -s /run/host/var/data2 /var
# RUN ln -s /run/host/run/dbus/system_bus_socket  /run/dbus/
RUN ln -s /run/host/run/systemd/system /run/systemd/

# Native march & tune
RUN sed -i 's/-march=x86-64 -mtune=generic/-march=native -mtune=native/g' /etc/makepkg.conf

# Créez les liens symboliques pour Podman et Docker
RUN ln -s /usr/bin/distrobox-host-exec /usr/local/bin/podman && \
    ln -s /usr/bin/distrobox-host-exec /usr/local/bin/docker

# Cleanup
RUN userdel -r build && \
    rm -drf /home/build && \
    sed -i '/build ALL=(ALL) NOPASSWD: ALL/d' /etc/sudoers && \
    sed -i '/root ALL=(ALL) NOPASSWD: ALL/d' /etc/sudoers && \
    rm -rf \
        /tmp/* \
        /var/cache/pacman/pkg/*
