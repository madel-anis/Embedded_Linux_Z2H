export PATH=$HOST_DIR/bin:$PATH

aarch64-linux-gcc $TARGET_DIR/myApplications/printHello.c -o $TARGET_DIR/myApplications/printHello.o

echo  ""  >>  /home/mohamed/Desktop/Embedded_Linux_Course/iti_share/Origin_Buildroot/buildroot-2019.11.1/output/images/rpi-firmware/config.txt
echo  "dtparam=audio=on"  >>  /home/mohamed/Desktop/Embedded_Linux_Course/iti_share/Origin_Buildroot/buildroot-2019.11.1/output/images/rpi-firmware/config.txt
