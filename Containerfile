FROM docker.io/library/archlinux:latest

# Support Nvidia Container Runtime (https://developer.nvidia.com/nvidia-container-runtime)
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES all

# Pacman Initialization
RUN pacman-key --init

# Create build user
RUN sed -i 's/#Color/Color/g' /etc/pacman.conf && \
    printf "[multilib]\nInclude = /etc/pacman.d/mirrorlist\n" | tee -a /etc/pacman.conf && \
    sed -i 's/#MAKEFLAGS="-j2"/MAKEFLAGS="-j$(nproc)"/g' /etc/makepkg.conf && \
    pacman -Syu --noconfirm && \
    pacman -S \
        wget \
        base-devel \
        git \
        --noconfirm && \
    useradd -m --shell=/bin/bash build && usermod -L build && \
    echo "build ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    echo "root ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Remove NoExtract
RUN sed -i '/NoExtract.*usr\/share\/i18n/d' /etc/pacman.conf
RUN pacman -Syu glibc --noconfirm
RUN pacman -Qqn | pacman -S --noconfirm -

# Distrobox Integration
USER build
WORKDIR /home/build
RUN git clone https://github.com/KyleGospo/xdg-utils-distrobox-arch.git --single-branch && \
    cd xdg-utils-distrobox-arch/trunk && \
    makepkg -si --noconfirm && \
    cd ../.. && \
    rm -drf xdg-utils-distrobox-arch
USER root
WORKDIR /
RUN git clone https://github.com/89luca89/distrobox.git --single-branch && \
    cp distrobox/distrobox-host-exec /usr/bin/distrobox-host-exec && \
    ln -s /usr/bin/distrobox-host-exec /usr/bin/flatpak && \
    ln -s /usr/bin/distrobox-host-exec /usr/bin/firefox && \
    ln -s /usr/bin/distrobox-host-exec /usr/bin/xdg-user-dir && \
    wget https://github.com/1player/host-spawn/releases/download/$(cat distrobox/distrobox-host-exec | grep host_spawn_version= | cut -d "\"" -f 2)/host-spawn-$(uname -m) -O distrobox/host-spawn && \
    cp distrobox/host-spawn /usr/bin/host-spawn && \
    chmod +x /usr/bin/host-spawn && \
    rm -drf distrobox

# Install extra packages
COPY extra-packages /
RUN pacman -Syu --needed --noconfirm - < extra-packages
RUN rm /extra-packages

# Clean up cache
RUN pacman -Scc --noconfirm

# Add Chaotic-aur
RUN pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
RUN pacman-key --lsign-key 3056513887B78AEB
RUN pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst' --noconfirm
RUN echo '[chaotic-aur]' >> /etc/pacman.conf
RUN echo 'Include = /etc/pacman.d/chaotic-mirrorlist' >> /etc/pacman.conf
RUN pacman -Syu --noconfirm yay obs-vkcapture-git lib32-obs-vkcapture-git

# Add yay and install AUR packages
USER build
WORKDIR /home/build
RUN yay -S tochd downgrade --noconfirm
USER root
WORKDIR /

# Définir la langue par défaut
RUN echo "LANG=fr_CH.UTF-8" > /etc/locale.conf

# Générer et activer les paramètres régionaux
RUN echo "fr_CH.UTF-8 UTF-8" > /etc/locale.gen && locale-gen

# Add some custom ln silverblue (test)
RUN ln -s /run/host/var/data1 /var
RUN ln -s /run/host/var/data2 /var
RUN ln -s /run/host/run/dbus/system_bus_socket  /run/dbus/
RUN ln -s /run/host/run/systemd/system /run/systemd/

# Cleanup
# Native march & tune. This is a gaming image and not something a user is going to compile things in with the intent to share.
# We do this last because it'll only apply to updates the user makes going forward. We don't want to optimize for the build host's environment.
RUN sed -i 's/-march=x86-64 -mtune=generic/-march=native -mtune=native/g' /etc/makepkg.conf && \
    userdel -r build && \
    rm -drf /home/build && \
    sed -i '/build ALL=(ALL) NOPASSWD: ALL/d' /etc/sudoers && \
    sed -i '/root ALL=(ALL) NOPASSWD: ALL/d' /etc/sudoers && \
    rm -rf \
        /tmp/* \
        /var/cache/pacman/pkg/*

