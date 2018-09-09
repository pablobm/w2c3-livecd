ARCH=i386
FILES_CACHE_DIR=config/includes.chroot/tmp
DOWNLOADS_CACHE_DIR=$(FILES_CACHE_DIR)/downloads
FLASH_PLUGIN_FILENAME=flash_player_npapi_linux.$(ARCH).tar.gz
FLASH_PLUGIN_FILENAME_OMIT_ARCH=flash_player_npapi_linux.tar.gz
FLASH_PLUGIN_PATH=$(FILES_CACHE_DIR)/$(FLASH_PLUGIN_FILENAME)
FLASH_PLUGIN_PATH_OMIT_ARCH=$(FILES_CACHE_DIR)/$(FLASH_PLUGIN_FILENAME_OMIT_ARCH)
THONNY_PACKAGE=thonny-3.0.8-$(THONNY_ARCH).tar.gz
THONNY_URL=https://bitbucket.org/plas/thonny/downloads/$(THONNY_PACKAGE)
THONNY_DOWNLOAD_PATH=$(DOWNLOADS_CACHE_DIR)/$(THONNY_PACKAGE)
amd64: ARCH=amd64
amd64: THONNY_ARCH=amd64
i386: ARCH=i386
i386: THONNY_ARCH=i686

.PHONY: default

default: amd64
amd64: iso
i386: iso


iso: live-image-$(ARCH).hybrid.iso

live-image-$(ARCH).hybrid.iso: $(FLASH_PLUGIN_PATH) $(THONNY_DOWNLOAD_PATH)
	cp $(FLASH_PLUGIN_PATH) $(FLASH_PLUGIN_PATH_OMIT_ARCH)
	lb clean && lb config --architectures $(ARCH) && lb build

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
