export PATH=$HOST_DIR/bin:$PATH

aarch64-linux-gcc $TARGET_DIR/myApplications/printHello.c -o $TARGET_DIR/myApplications/printHello.o
cp $TARGET_DIR/myApplications/printHello.c  $TARGET_DIR/myApplications/printHello.o


echo  ""  >>  $TARGET_DIR/../images/rpi-firmware/config.txt
echo  "dtparam=audio=on"  >>  $TARGET_DIR/../images/rpi-firmware/config.txt
echo  "hdmi_safe=1"  >>  $TARGET_DIR/../images/rpi-firmware/config.txt
echo  "hdmi_drive=2"  >>  $TARGET_DIR/../images/rpi-firmware/config.txt


chmod a+x $TARGET_DIR/Project/playmusic.bash
chmod a+x $TARGET_DIR/Project/USB_Detection.bash
chmod a+x $TARGET_DIR/etc/init.d/S60-MusicPlayer