# ehough/docker-kodi - Dockerized Kodi with audio and video.
#
# https://github.com/ehough/docker-kodi
# https://hub.docker.com/r/erichough/kodi/
#
# Copyright 2018-2020 - Eric Hough (eric@tubepress.com)
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

FROM ubuntu:focal

# install the team-xbmc ppa
RUN apt-get update                                                        && \
    apt-get install -y --no-install-recommends software-properties-common && \
    add-apt-repository ppa:team-xbmc/ppa                                  && \
    apt-get -y purge openssl software-properties-common                   && \
    apt-get -y --purge autoremove                                         && \
    rm -rf /var/lib/apt/lists/*

# besides kodi, we will install a few extra packages:
#  - ca-certificates              allows Kodi to properly establish HTTPS connections
#  - kodi-eventclients-kodi-send  allows us to shut down Kodi gracefully upon container termination
#  - kodi-game-libretro           allows Kodi to utilize Libretro cores as game add-ons
#  - kodi-game-libretro-*         Libretro cores
#  - kodi-inputstream-*           input stream add-ons
#  - kodi-peripheral-joystick     enables the use of gamepads, joysticks, game controllers, etc.
#  - kodi-pvr-*                   PVR add-ons
#  - kodi-screensaver-*           additional screensavers
#  - locales                      additional spoken language support (via x11docker --lang option)
#  - pulseaudio                   in case the user prefers PulseAudio instead of ALSA
#  - tzdata                       necessary for timezone selection
RUN packages="                                               \
                                                             \
    ca-certificates                                          \
    kodi                                                     \
    kodi-eventclients-kodi-send                              \
    kodi-game-libretro                                       \  
    kodi-inputstream-adaptive                                \   
    kodi-peripheral-joystick                                 \
    kodi-pvr-argustv                                         \
    kodi-pvr-dvblink                                         \
    kodi-pvr-dvbviewer                                       \
    kodi-pvr-filmon                                          \
    kodi-pvr-hts                                             \
    kodi-pvr-iptvsimple=3.9.8-1~focal                        \
    kodi-pvr-mediaportal-tvserver                            \
    kodi-pvr-mythtv                                          \
    kodi-pvr-nextpvr                                         \
    kodi-pvr-njoy                                            \
    kodi-pvr-octonet                                         \
    kodi-pvr-pctv                                            \
    kodi-pvr-sledovanitv-cz                                  \
    kodi-pvr-stalker                                         \
    kodi-pvr-teleboy                                         \
    kodi-pvr-vbox                                            \ 
    kodi-pvr-wmc                                             \
    kodi-pvr-zattoo                                          \ 
    locales                                                  \
    pulseaudio                                               \
    tzdata                                                   \
    libxv1                                                   \
    va-driver-all"                                        && \
                                                             \
    apt-get update                                        && \
    apt-get install -y --no-install-recommends $packages  && \
    apt-get -y --purge autoremove                         && \
    rm -rf /var/lib/apt/lists/*

# setup entry point
COPY entrypoint.sh /usr/local/bin
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
