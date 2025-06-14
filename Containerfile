ARG CORE_BRANCH=main

FROM ghcr.io/projm-dev-team/core:$CORE_BRANCH

ARG CORE_BRANCH=main
ARG VARIANT=general
ARG DESKTOP=nogui

RUN if [ "$VARIANT" != container ]; then install-packages-build linux-zen linux-firmware linux-zen-headers broadcom-wl-dkms; fi

RUN if [ "$VARIANT" == nvidia ]; then install-packages-build nvidia-dkms lib32-nvidia-utils nvidia-container-toolkit; fi

RUN install-packages-build grub efibootmgr

RUN install-packages-build python-yaml python-click python-fasteners skopeo umoci jq libnotify

COPY overlays/common /

RUN systemctl enable commonarch-update-cleanup
RUN systemctl enable --global commonarch-update-check

# Clean up cache
RUN yes | pacman -Scc
