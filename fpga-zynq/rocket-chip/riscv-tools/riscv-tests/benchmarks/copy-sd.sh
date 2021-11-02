make
cp rowcopy.riscv ../../../../zc706/
cd ../../../../zc706
sudo make ramdisk-open
sudo cp rowcopy.riscv ramdisk/home/root/
sudo make ramdisk-close && sudo rm -rf ramdisk/
cp fpga-images-zc706/uramdisk.image.gz /media/ataberk/SDC/
