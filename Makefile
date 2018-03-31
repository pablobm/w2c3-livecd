ARCH=x86_64
FLASH_PLUGIN=config/includes.chroot/tmp/libflashplayer.so
THONNY_URL=https://bitbucket.org/plas/thonny/downloads/thonny-2.1.17-$(ARCHITECTURE).tar.gz
THONNY_PACKAGE=config/includes.chroot/tmp/thonny-installer

.PHONY: default

default: live-image-amd64.hybrid.iso
	
live-image-amd64.hybrid.iso: $(FLASH_PLUGIN) $(THONNY_PACKAGE)
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

$(THONNY_PACKAGE):
	curl -sS $(THONNY_URL) > $(THONNY_PACKAGE)
