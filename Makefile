ARCH=i386
INCLUDES_DIR=config/includes.chroot
FILES_CACHE_DIR=$(INCLUDES_DIR)/tmp
DOWNLOADS_CACHE_DIR=$(FILES_CACHE_DIR)/downloads
FLASH_PLUGIN_FILE=flash_player_npapi_linux.$(ARCH).tar.gz
FLASH_PLUGIN_PATH=$(FILES_CACHE_DIR)/$(FLASH_PLUGIN_FILE)
THONNY_PACKAGE=thonny-3.0.8-$(ARCH).tar.gz
THONNY_URL=https://bitbucket.org/plas/thonny/downloads/$(THONNY_PACKAGE)
THONNY_DOWNLOAD_PATH=$(DOWNLOADS_CACHE_DIR)/$(THONNY_PACKAGE)
ORIGINAL_WALLPAPER=$(INCLUDES_DIR)/usr/share/w2c3/desktop-wallpaper-sans-fingerprint.png
GIT_BRANCH=$(shell git branch | grep '^*' | cut -d' ' -f2)
DATE=$(shell date +"%Y-%m-%d")
BUILD_MSG="build: $(DATE)^$(GIT_BRANCH)"
FINGERPRINTED_WALLPAPER=$(INCLUDES_DIR)/usr/share/w2c3/desktop-wallpaper.png

.PHONY: default fingerprint

default: live-image-$(ARCH).hybrid.iso

live-image-$(ARCH).hybrid.iso: $(FLASH_PLUGIN_PATH) $(THONNY_DOWNLOAD_PATH) fingerprint
	lb clean && lb config && lb build

fingerprint:
	convert $(ORIGINAL_WALLPAPER) -size 250x50 -gravity NorthWest -pointsize 20 -font courier -fill white -draw 'text 10,10 $(BUILD_MSG)' $(FINGERPRINTED_WALLPAPER)

$(FLASH_PLUGIN_PATH):
	@echo "=========================================="
	@echo
	@echo "  Please download the Linux flash plugin package ($(FLASH_PLUGIN_FILE)) and leave it at:"
	@echo
	@echo "  $(FLASH_PLUGIN_PATH)"
	@echo
	@echo "=========================================="
	@exit 1

$(THONNY_DOWNLOAD_PATH):
	mkdir -p $(DOWNLOADS_CACHE_DIR)
	wget -O $(THONNY_DOWNLOAD_PATH) $(THONNY_URL)
