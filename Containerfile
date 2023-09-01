FROM docker.io/library/archlinux:latest

LABEL com.github.containers.toolbox="true" \
      name="archlinux-gab" \
      version="specialgab" \
      usage="" \
      summary="" \
      maintainer=""


RUN pacman-key --init

# Enable multilib & color
RUN echo '[multilib]' >> /etc/pacman.conf
RUN echo 'Include = /etc/pacman.d/mirrorlist' >> /etc/pacman.conf
RUN sed -i 's/#Color/Color/g' /etc/pacman.conf

# Remove NoExtract
RUN sed -i '/NoExtract.*usr\/share\/i18n/d' /etc/pacman.conf
RUN pacman -Syu glibc --noconfirm
RUN pacman -Qqn | pacman -S --noconfirm -

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
RUN pacman -Syu --noconfirm yay

# Définir la langue par défaut
RUN echo "LANG=fr_CH.UTF-8" > /etc/locale.conf

# Générer et activer les paramètres régionaux
RUN echo "fr_CH.UTF-8 UTF-8" > /etc/locale.gen && locale-gen

# Compiler boost
RUN sed -i 's/#MAKEFLAGS="-j2"/MAKEFLAGS="-j$(nproc)"/g' /etc/makepkg.conf

# Add some custom ln silverblue (test)
RUN ln -s /run/host/var/data1 /var
RUN ln -s /run/host/var/data2 /var
RUN ln -s /run/host/run/dbus/system_bus_socket  /run/dbus/
RUN ln -s /run/host/run/systemd/system /run/systemd/
