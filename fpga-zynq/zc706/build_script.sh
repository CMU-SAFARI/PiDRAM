ln -sf ../../system_top.bit fpga-images-zc706/boot_image/rocketchip_wrapper.bit
cd fpga-images-zc706; bootgen -image boot.bif -w -o boot.bin
