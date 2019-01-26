default: amd64

.PHONY: default iso amd64 i386

FILES_CACHE_DIR=config/includes.chroot/tmp
DOWNLOADS_CACHE_DIR=$(FILES_CACHE_DIR)/downloads
FLASH_PLUGIN_FILENAME=flash_player_npapi_linux.$(FLASH_ARCH).tar.gz
FLASH_PLUGIN_FILENAME_OMIT_ARCH=flash_player_npapi_linux.tar.gz
FLASH_PLUGIN_PATH=$(FILES_CACHE_DIR)/$(FLASH_PLUGIN_FILENAME)
FLASH_PLUGIN_PATH_OMIT_ARCH=$(FILES_CACHE_DIR)/$(FLASH_PLUGIN_FILENAME_OMIT_ARCH)
THONNY_PACKAGE=thonny-3.0.8-$(THONNY_ARCH).tar.gz
THONNY_URL=https://bitbucket.org/plas/thonny/downloads/$(THONNY_PACKAGE)
THONNY_DOWNLOAD_PATH=$(DOWNLOADS_CACHE_DIR)/$(THONNY_PACKAGE)
ISO=live-image-$(ARCH).hybrid.iso

amd64:
	ARCH=amd64 THONNY_ARCH=x86_64 FLASH_ARCH=x86_64 $(MAKE) iso
i386:
	ARCH=i386 THONNY_ARCH=i686 FLASH_ARCH=i386 $(MAKE) iso

iso: $(FLASH_PLUGIN_PATH) $(THONNY_DOWNLOAD_PATH) $(ISO)

$(ISO):
	rm -f cache
	mkdir -p cache-$(ARCH)
	ln -s cache-$(ARCH) cache
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
