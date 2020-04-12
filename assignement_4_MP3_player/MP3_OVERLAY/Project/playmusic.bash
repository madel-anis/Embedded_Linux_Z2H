#!/bin/bash


#check if the GPIO Pins Configuration are done

if [ ! -e /sys/class/gpio/gpio23 ] ;
then

echo "23" > /sys/class/gpio/export
echo "in" > /sys/class/gpio/gpio23/direction

fi

if [ ! -e /sys/class/gpio/gpio22 ] ;
then

echo "22" > /sys/class/gpio/export
echo "in" > /sys/class/gpio/gpio22/direction

fi

if [ ! -e /sys/class/gpio/gpio27 ] ;
then

echo "27" > /sys/class/gpio/export
echo "in" > /sys/class/gpio/gpio27/direction

fi

if [ ! -e /sys/class/gpio/gpio17 ] ;
then

echo "17" > /sys/class/gpio/export
echo "in" > /sys/class/gpio/gpio17/direction

fi

#read the playlist
array_OF_Songs()
{

    i=0
    arr=()

    while IFS= read -r var
    do 

    i=$[ $i +1 ]
    arr+=($var)

    done <<< $(find / -iname "*mp3" 2>/dev/null) 
    Max=$i
    Min=0

}

Mass_detected=0
Cmd_detected=0
index=0
status=0


G_Flag=/Project/Global_Flag

GV_loc=/Project/Global_Variable
array_OF_Songs

if [ ${#arr[@]} -eq 0 ]
then

echo "No .MP3 files found"

else

madplay -Q --no-tty-control ${arr[index]} 2>/dev/null  &
song_pid=$!

echo "MP3 Playing > [$(basename ${arr[index]})]"

fi

while :
do

    if [[ $( cat /Project/Global_Flag ) -eq 1 ]]
    then

    array_OF_Songs
    echo 0 > $G_Flag

    fi



    # if user entered cmd play
    if [[ $( cat $GV_loc ) == '1' ]]
	then
        #wait for debouncing
		sleep 0.5

        #Clear the Global Variable
        echo 0 > $GV_loc

        #continue the song 
        kill -18 $song_pid  
        echo "MP3 Playing > [$(basename ${arr[index]})]"

    # if user entered cmd pause
    elif [[ $( cat $GV_loc ) ==  '2' ]]
	then
        #wait for debouncing
		sleep 0.5

	#Clear the Global Variable
        echo 0 > $GV_loc

        #pasue the song 
        kill -19 $song_pid 
        echo "MP3 Paused > [$(basename ${arr[index]})]"

	# if user entered cmd next
    elif [[ $( cat $GV_loc ) == '3' ]]
	then
        #wait for debouncing
		sleep 0.5

        #Clear the Global Variable
        echo 0 > $GV_loc

        #jump to the next song 
        if [ $index -eq $Max ]
		then
			index=0
		else
			index=$(($index+1))
		fi
		disown $song_pid
		kill -9 $song_pid 
		madplay -Q --no-tty-control ${arr[index]} 2>/dev/null  &  
		song_pid=$!

		echo "MP3 Playing > [$(basename ${arr[index]})]"

	# if user entered cmd previous
	elif [[ $( cat $GV_loc ) == '4' ]]
	then
        #wait for debouncing
		sleep 0.5

        #Clear the Global Variable
        echo 0 > $GV_loc

        #jump to the previous song 
	    if [ $index -eq 0 ]
		then
			index=$(($Max -1)) 
		else
			index=$(($index-1))
		fi
		disown $song_pid
		kill -9 $song_pid
		madplay -Q --no-tty-control ${arr[index]} 2>/dev/null  & 
		song_pid=$!

        echo "MP3 Playing > [$(basename ${arr[index]})]"

	#if user entered cmd Shuffle
	elif [[ $( cat $GV_loc ) == '5' ]]
	then
	#wait for debouncing
		sleep 0.5
	#Clear The Global Variable
	echo 0 > $GV_loc

	disown $song_pid
        kill -9 $song_pid
        madplay -Q --no-tty-control -z `echo ${arr[@]}` 2>/dev/null &
        song_pid=$!

        echo "MP3 is Shuffling ..... kda aho w kda ahe "
	


    #check Toogle Button
	elif [ $(cat /sys/class/gpio/gpio17/value) -eq 1 ]
	then
        #wait for debouncing
		sleep 0.5

        #check whether to pause or to play
		if [ $status -eq 0 ]
		then
			kill -19 $song_pid 2>/dev/null
			status=1
            		echo "MP3 Paused > [$(basename ${arr[index]})]"
		else
			kill -18 $song_pid 2>/dev/null
			status=0
			echo "MP3 Playing > [$(basename ${arr[index]})]"
		fi
		
    #check Next Button
	elif [ $(cat /sys/class/gpio/gpio27/value) -eq 1 ]
	then
        #wait for debouncing
		sleep 0.5

		#jump to the next song 
        	if [ $index -eq $(($Max-1)) ]
		then
			index=0
		else
			index=$(($index+1))
		fi

		disown $song_pid
		kill -9 $song_pid 
		madplay -Q --no-tty-control ${arr[index]} 2>/dev/null &
		song_pid=$!

        	echo "MP3 Playing > [$(basename ${arr[index]})]"

    #check previous Button
	elif [ $(cat /sys/class/gpio/gpio22/value) -eq 1 ]
	then
		sleep 1
        #check if the button is still pushed after 1 second
        if [ $(cat /sys/class/gpio/gpio22/value) -eq 1 ]
        then
            #play the previous song
            if [ $index -eq 0 ]
            then
                index=$(($Max -1)) 
            else
                index=$(($index-1))
            fi

	    disown $song_pid	
            kill -9 $song_pid
            madplay -Q --no-tty-control ${arr[index]} 2>/dev/null  &
            song_pid=$!

            echo "MP3 Playing > [$(basename ${arr[index]})]"

        else
            #restart the current song
	    disown $song_pid
            kill -9 $song_pid
            madplay -Q --no-tty-control ${arr[index]} 2>/dev/null  &
            song_pid=$!

            echo "MP3 Playing > [$(basename ${arr[index]})]"

        fi

	elif [ $(cat /sys/class/gpio/gpio23/value) -eq 1 ]
	then
		sleep 0.5
		
		disown $song_pid
		kill -9 $song_pid
		madplay -Q --no-tty-control -z `echo ${arr[@]}` 2>/dev/null &
		song_pid=$!

		echo "MP3 is Shuffling ..... kda aho w kda ahe "

	fi

done
