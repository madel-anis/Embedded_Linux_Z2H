#!/bin/bash

#make local variable for the location and name of our database in /etc folder
database_file=/etc/phonebookDB.txt

#check if the database file exists, if not create a new one
if [ -e "$database_file" ];
then
	#do nothing
	:
else
	#create a new database file int etc 
	sudo touch /etc/phonebookDB.txt
fi

#welcome statment
echo "Welcome to the Database Script"
echo


#main Arrays
declare -a user_name
declare -a last_name
declare -a first_number
declare -a second_number
declare -a third_number
declare -a forth_number

Numbers=('first' 'second' 'third' 'forth')

i=0
#opening the file and reading it
while  read -r user_name[i] last_name[i] first_number[i] second_number[i] third_number[i] forth_number[i]
do
#echo "${user_name[i]} ${last_name[i]} ${first_number[i]} ${second_number[i]} ${third_number[i]} ${forth_number[i]}"
  ((i++))
done < "$database_file"





#check which option has been entered
case $1 in 

# option of inserting new contact to the database 
"-i")
		flag=0
		index=0
		read -p  "please Enter the first and last name separeted by a space : " -r temp1 temp2
		
		if [ -z $temp1 ] || [ -z $temp2 ]
		then
					echo "Wrong input, first or last name has not been entered "
		else 
				#check if the name is not already exist
				for element in ${user_name[@]}
					do
							if [ $element = $temp1 ]
							then 
										if [ ${last_name[index]} = $temp2 ]
										then
													flag=1
													break
										fi
							fi
							((index++))
				done
				
				#if the name is not exist add it with the multiple numbers upto 4 numbers
				if [ $flag = 0 ]
				then
							user_name[i]=$temp1
							last_name[i]=$temp2
							answer='y'
							counter=0
							while [ $answer = 'y' ]
							do 
										read -p  "please Enter the ${Numbers[counter]} number : " -r Input
										case $counter in
										0)
												first_number[i]=$Input;;
										1)
												second_number[i]=$Input;;
										2)	
												third_number[i]=$Input;;
										3)
												forth_number[i]=$Input;;
										esac
										
										if [ $counter -lt 3 ]
										then
												read -p  "Do you want to add more numbers to this username ? ('y' or 'n') : " -r answer
												while [ $answer != 'n' ] && [ $answer != 'y' ]
												do
																	read -p  "Wrong Input, please enter whether 'y' or 'n' : " -r answer
												done
												((counter++))
										else
												answer='n'
										fi
							done
							data="${user_name[i]} ${last_name[i]} ${first_number[i]} ${second_number[i]} ${third_number[i]} ${forth_number[i]}"
							
							  echo $data   |  sudo tee  -a  $database_file  >>  /dev/null
				else
							echo "Sorry, this name is already exist"
				fi
				
		fi;;
		
		
		
		
		
# option of viewing all contacts in the database 
"-v")
		flag=0
		index=0
		
		#print the data in the array
		
		echo "FirstName	LastName	First Number	Second Number	Third Number	Forth Number"
		
		for user in ${user_name[@]}
		do
				echo "$user		${last_name[index]}		${first_number[index]}	${second_number[index]}	${third_number[index]}	${forth_number[index]}"
				((index++))
				flag=1
		done
		
		#if the there is no data, tell the user
		if [ $flag -eq 0 ]
		then
					echo "There is no data in your database"
		fi;;
		
		
		
		
		
		
		
# option of searching about specific contact in the database 
"-s") 

		flag=0
		search_index=0
		
		read -p  "please Enter the first and last name of required contact to be searched separeted by a space : " -r temp1 temp2
		
		if [ -z $temp1 ] || [ -z $temp2 ]
		then
					echo "Wrong Input, first or last name has not  been entered"
		else
					for user in ${user_name[@]}
					do
							if [  $user = $temp1 ]
							then
										if [ ${last_name[search_index]} = $temp2 ]
										then
													flag=1
													break
										fi
							fi
							((search_index++))
					done
					
					if [  $flag -eq 1 ]
					then
							echo 
							echo "${user_name[search_index]}	${last_name[search_index]}	${first_number[search_index]}	${second_number[search_index]}	${third_number[search_index]}	${forth_number[search_index]}"
					else
							echo "No contact found for $temp1 $temp2"
					fi
		fi;;
		
		
		
		
		
		
		
# option of deleting the entire database 
"-e")
		read -p  "Do you realy want to delete all the contents of the database  ? ('y' or 'n') : " -r answer
		while [ $answer != 'n' ] && [ $answer != 'y' ]
		do
							read -p  "Wrong Input, please enter whether 'y' or 'n' : " -r answer
		done
		
		if [ $answer = 'y' ]
		then 
					sudo truncate -s0 $database_file
		fi;;
		
		
		
		
		
		
		
# option of deleting specific contact in the database 		
"-d")

		flag=0
		search_index=0
		
		read -p  "please Enter the first and last name of required contact to be deleted separeted by a space : " -r temp1 temp2
		
		if [ -z $temp1 ] || [ -z $temp2 ]
		then
					echo "Wrong Input, no contact name has been entered"
		else
					for user in ${user_name[@]}
					do
							if [  $user = $temp1 ]
							then
										if [ ${last_name[search_index]} = $temp2 ]
										then
													flag=1
													break
										fi
							fi
							((search_index++))
					done
					
					if [  $flag -eq 1 ]
					then	
								sudo truncate -s0 $database_file
								i=0
								for element in  ${user_name[@]}
								do
										if [ $search_index -ne $i ]
										then
										
													data="${user_name[i]} ${last_name[i]} ${first_number[i]} ${second_number[i]} ${third_number[i]} ${forth_number[i]}"
													echo $data   |  sudo tee  -a  $database_file  >>  /dev/null
										fi
										((i++))
								done
							
					else
							echo "No contact found for $temp1 $temp2"
					fi

		fi;;
*)
	echo "This script is used to build Phonebook database"
	echo "The database can hold the first and last names of the contact"
	echo "Every contact can have up to 4 phone numbers "
	echo
	echo "to use this script type this command"
	echo "./phonebook [-option] "
	echo
	echo 'where "option" can be'
	echo
	echo "-i to insert new contact"
	echo "-v to view all the saved contacts details"
	echo "-s to search by contact name"
	echo "-e to delete all the contacts"
	echo "-d to delete specific contact name";;
esac

echo
echo "End of the Script"
echo "Thanks for using the Fun ScRiPts :D "