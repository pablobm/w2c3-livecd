default: amd64

.PHONY: default fingerprint iso amd64 i386

INCLUDES_DIR=config/includes.chroot
FILES_CACHE_DIR=$(INCLUDES_DIR)/tmp
DOWNLOADS_CACHE_DIR=$(FILES_CACHE_DIR)/downloads
FLASH_PLUGIN_FILENAME=flash_player_npapi_linux.$(FLASH_ARCH).tar.gz
FLASH_PLUGIN_FILENAME_OMIT_ARCH=flash_player_npapi_linux.tar.gz
FLASH_PLUGIN_PATH=$(FILES_CACHE_DIR)/$(FLASH_PLUGIN_FILENAME)
FLASH_PLUGIN_PATH_OMIT_ARCH=$(FILES_CACHE_DIR)/$(FLASH_PLUGIN_FILENAME_OMIT_ARCH)
THONNY_PACKAGE=thonny-3.0.8-$(THONNY_ARCH).tar.gz
THONNY_URL=https://bitbucket.org/plas/thonny/downloads/$(THONNY_PACKAGE)
THONNY_DOWNLOAD_PATH=$(DOWNLOADS_CACHE_DIR)/$(THONNY_PACKAGE)
ORIGINAL_WALLPAPER=$(INCLUDES_DIR)/usr/share/w2c3/desktop-wallpaper-sans-fingerprint.png
GIT_BRANCH=$(shell git branch | grep '^*' | cut -d' ' -f2)
DATE=$(shell date +"%Y-%m-%d")
BUILD_MSG="build: $(DATE)^$(GIT_BRANCH)"
FINGERPRINTED_WALLPAPER=$(INCLUDES_DIR)/usr/share/w2c3/desktop-wallpaper.png
ISO=live-image-$(ARCH).hybrid.ido

amd64:
	ARCH=amd64 THONNY_ARCH=x86_64 FLASH_ARCH=x86_64 $(MAKE) iso
i386:
	ARCH=i386 THONNY_ARCH=i686 FLASH_ARCH=i386 $(MAKE) iso

iso: $(FLASH_PLUGIN_PATH) $(THONNY_DOWNLOAD_PATH) fingerprint
	cp $(FLASH_PLUGIN_PATH) $(FLASH_PLUGIN_PATH_OMIT_ARCH)
	lb clean && lb config --architectures $(ARCH) && lb build

fingerprint:
	convert $(ORIGINAL_WALLPAPER) -size 250x50 -gravity NorthWest -pointsize 20 -font courier -fill white -draw 'text 10,10 $(BUILD_MSG)' $(FINGERPRINTED_WALLPAPER)

$(FLASH_PLUGIN_PATH):
	@echo "=========================================="
	@echo
	@echo "  Please download the Linux flash plugin package ($(FLASH_PLUGIN_FILENAME)) and leave it at:"
	@echo
	@echo "  $(FLASH_PLUGIN_PATH)"
	@echo
	@echo "=========================================="
	@exit 1

$(THONNY_DOWNLOAD_PATH):
	mkdir -p $(DOWNLOADS_CACHE_DIR)
	wget -O $(THONNY_DOWNLOAD_PATH) $(THONNY_URL)
