FLASH_PLUGIN=config/includes.chroot/tmp/libflashplayer.so

.PHONY: default

default: live-image-amd64.hybrid.iso
	
live-image-amd64.hybrid.iso: $(FLASH_PLUGIN)
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
