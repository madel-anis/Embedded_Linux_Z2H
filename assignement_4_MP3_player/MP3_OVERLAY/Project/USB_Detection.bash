#!/bin/bash

#USB Detection Script

#this Script is used to detect the inserted media and mount it on the run time



number_of_Dev=0
real_dev_num=0
prev_state=0


#infinite Loop

while true;
do
	#list all the inserted Devices in array
	Devices="$(fdisk -l /dev/sd* | grep -v 'Unknown' | grep -v 'Empty'  | awk '/^\/dev\/sd/ {print $1}' )"

	#check if there is a device or not
	if [[ ${Devices[0]} == `fdisk: can\'t open \'/dev/sd*\': No such file or directory`  ]]
	then
		real_dev_num=0

	else

		real_dev_num=${#Devices[@]}

	fi

	#loop on the array of devices
	for Device in $Devices; 
	do
		#Create a mount point 
		mountpoint="/media/$(basename $Device)"

		#make a directory for the mount point if exist ignore
	        mkdir -p $mountpoint

		#mount the device if not mounted
	        mount $Device $mountpoint

	done

	#check if new device is connected
        if [[ $number_of_Dev -lt $real_dev_num  ]]
        then

                 #shout out
                 aplay /Project/Espeak_Media_Entered

		 #update Global Flag
		 echo 1 > /Project/Global_Flag


	#check if a device is removed
        elif [[ $number_of_Dev -gt $real_dev_num ]]
        then

	        #shout out
       		aplay /Project/Espeak_Media_Removed

		#update the Global Flag
	        echo 1 > /Project/Global_Flag

	fi
		
	#update number_of_Dev
	number_of_Dev=$real_dev_num

	#loop on the empty devices
	for um_Device in $Devices;
	do
		#Create unmouted point
		umountPoint="/media/$(basename $um_Device)"

		check=`ls $umountPoint | wc -l`

                if [[ $check == '0' ]]
		then
			umount $umountPoint
			rm -r  $umountPoint
		fi
	done
  
done
