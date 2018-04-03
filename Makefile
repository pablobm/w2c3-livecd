ARCH=x86_64
FILES_CACHE_DIR=config/includes.chroot/tmp
DOWNLOADS_CACHE_DIR=$(FILES_CACHE_DIR)/downloads
FLASH_PLUGIN=$(FILES_CACHE_DIR)/libflashplayer.so
THONNY_PACKAGE=thonny-2.1.17-$(ARCH).tar.gz
THONNY_URL=https://bitbucket.org/plas/thonny/downloads/$(THONNY_PACKAGE)
THONNY_DOWNLOAD_PATH=$(DOWNLOADS_CACHE_DIR)/$(THONNY_PACKAGE)

.PHONY: default

default: live-image-amd64.hybrid.iso
	
live-image-amd64.hybrid.iso: $(FLASH_PLUGIN) $(THONNY_DOWNLOAD_PATH)
	lb clean && lb config && lb build

$(FLASH_PLUGIN):
	@echo "=========================================="
	@echo
	@echo "  Please download the Linux flash plugin (libflashplayer.so) and leave it at:"
	@echo
	@echo "  $(FLASH_PLUGIN)"
	@echo
	@echo "=========================================="
	@exit 1

$(THONNY_DOWNLOAD_PATH):
	mkdir -p $(DOWNLOADS_CACHE_DIR)
	wget -O $(THONNY_DOWNLOAD_PATH) $(THONNY_URL)
