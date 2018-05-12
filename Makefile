ARCH=x86_64
FILES_CACHE_DIR=config/includes.chroot/tmp
DOWNLOADS_CACHE_DIR=$(FILES_CACHE_DIR)/downloads
FLASH_PLUGIN_FILE=flash_player_npapi_linux.x86_64.tar.gz
FLASH_PLUGIN_PATH=$(FILES_CACHE_DIR)/$(FLASH_PLUGIN_FILE)
THONNY_PACKAGE=thonny-2.1.17-$(ARCH).tar.gz
THONNY_URL=https://bitbucket.org/plas/thonny/downloads/$(THONNY_PACKAGE)
THONNY_DOWNLOAD_PATH=$(DOWNLOADS_CACHE_DIR)/$(THONNY_PACKAGE)

.PHONY: default

default: live-image-amd64.hybrid.iso
	
live-image-amd64.hybrid.iso: $(FLASH_PLUGIN_PATH) $(THONNY_DOWNLOAD_PATH)
	lb clean && lb config && lb build

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
