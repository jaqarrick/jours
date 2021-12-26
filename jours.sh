#!/bin/bash
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # #MMMMMMMM""M MMP"""""YMM M""MMMMM""M MM"""""""`MM MP""""""`MM # # # # # # # # # # # #
# # # # # # # # # #MMMMMMMM  M M' .mmm. `M M  MMMMM  M MM  mmmm,  M M  mmmmm..M # # # # # # # # # # # #
# # # # # # # # # #MMMMMMMM  M M  MMMMM  M M  MMMMM  M M'        .M M.      `YM # # # # # # # # # # # #
# # # # # # # # # #MMMMMMMM  M M  MMMMM  M M  MMMMM  M MM  MMMb. "M MMMMMMM.  M # # # # # # # # # # # #
# # # # # # # # # #M. `MMM' .M M. `MMM' .M M  `MMM'  M MM  MMMMM  M M. .MMM'  M # # # # # # # # # # # #
# # # # # # # # # #MM.     .MM MMb     dMM Mb       dM MM  MMMMM  M Mb.     .dM # # # # # # # # # # # #
# # # # # # # # # #MMMMMMMMMMM MMMMMMMMMMM MMMMMMMMMMM MMMMMMMMMMMM MMMMMMMMMMM # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # Simple, secure journaling from the command line # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # Author: Jack Carrick, https://github.com/jaqarrick  # # # # # # # # # # # # # # # # #
# # # # # # # # # License: MIT License (c) 2021-2022  # # # # # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # Version: 1.0.0  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # Info at: https://github.com/jaqarrick/jours # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# TODO silently fail on errors

# SET UP GLOBAL VARS
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
RESET='\033[0m'
ULINE='\033[4m'
CONFIG_PATH=~/.joursconfig
ARGUMENT_1_GLOBAL=$1
ARGUMENT_2_GLOBAL=$2

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # #       _   _ _     # # # # # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # _   _| |_(_) |___ # # # # # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # #| | | | __| | / __|# # # # # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # #| |_| | |_| | \__ \# # # # # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # \__,_|\__|_|_|___/ # # # # # # # # # # # # # # # # #  # # # # # # #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

function check_init_status() {
	# check if config file has been created, unles the init command is being called
	if [ ! -f "$CONFIG_PATH" ]; then
		if [ "$ARGUMENT_1_GLOBAL" != "init" ]; then
			echo -e "${RED}Journal hasn't been initiated yet${RESET}"
			echo -e "Run ${GREEN}jours init${RESET} to get started"
			exit 1
		fi
	else
		source "${CONFIG_PATH}"
		source "$JOURS_ENTRIES_DIRECTORY"/.current
		echo "current journal: $CURRENT_JOURNAL"
	fi

}

function init_journal() {
	if [ -f "$HOME/.joursconfig" ]; then
		echo "Looks like you've already initiated a journal. Do you want to remove it?"
		echo -e "Type ${GREEN}YES${RESET} to confirm."
		read -r response
		if [ "$response" = "YES" ]; then
			rm "$HOME/.joursconfig"
		else
			echo -e "Goodbye."
			exit 1
		fi
	fi

	echo -e "${ULINE}Welcome to jours, a simple CLI designed for safe and secure journaling${RESET}"
	echo -e "Where would you like your journal to live? Copy and paste the directory in the console. Defaults to ${BLUE}~/Documents/\n${RESET}"
	read -r JOURS_ROOT_DIRECTORY

	# Check if string is empty using -z
	if [[ -z $JOURS_ROOT_DIRECTORY ]]; then
		# TODO: change directory location based on OS. Right now its just MACOSX
		JOURS_ROOT_DIRECTORY="$HOME/Documents/jours"

		echo "No input entered, using $JOURS_ROOT_DIRECTORY."

	else
		echo "Using $JOURS_ROOT_DIRECTORY as root directory"
	fi

	# Now that we have the root directory, we can check to see if it already exists
	if [ -d "$JOURS_ROOT_DIRECTORY" ]; then
		echo -e "${RED}Looks like Jours has already been set up at${RESET} ${BLUE}$JOURS_ROOT_DIRECTORY${RESET}"
		echo -e "You can erase your data by removing the jours directory with ${GREEN}"
		echo -e "cd $JOURS_ROOT_DIRECTORY && cd .."
		echo -e "rm -rf jours/${RESET}"
		exit 1
	fi

	# Create the root directory
	echo -e "Creating Jours root directory at ${BLUE}$JOURS_ROOT_DIRECTORY${RESET}"
	mkdir "$JOURS_ROOT_DIRECTORY"

	echo "Who is the author of this journal?"
	read -r AUTHOR

	create_password
	touch ~/.joursconfig
	echo "JOURS_ROOT_DIRECTORY='$JOURS_ROOT_DIRECTORY'" >>~/.joursconfig
	echo "JOURS_ENTRIES_DIRECTORY='$JOURS_ROOT_DIRECTORY/entries'" >>~/.joursconfig
	echo "Enter a name for this journal"
	read -r journal_name
	echo "CURRENT_JOURNAL='$journal_name'" >>"$JOURS_ROOT_DIRECTORY"/entries/.current
	echo "AUTHOR='$AUTHOR'" >>~/.joursconfig

	### Create all the internal directories and files ###
	cd "$JOURS_ROOT_DIRECTORY" || exit
	mkdir entries exposed
	mkdir entries/"$journal_name"
	echo "
Jours is a simple CLI designed for safe and secure journaling.
Getting started

After installing the cli run

jours init

You will be prompted to input a location for your journal. This defaults to ~/Documents/jours

You will then be prompted to create a password for your journal. Just hit enter to let jours recommend a password.

IMPORTANT: If you forget or lose your password, you will not have access to any of your encrypted entries!

Once initiated, you can run

jours login

You'll be prompted for a password.
Creating an entry

Compose an entry with:

jours compose

Or, edit a specific entry with

jours compose <date>

<date> is in YYYY-MM-DD format, for example:

jours compose 2011-11-31

Reading your entries

If you want to read a single entry or collection of entries without editing run

jours read <date>

# or

jours read <month>

<month> is in YYYY-MM format and concatinates all entries from a given month into a single text file.

Read today's entry:

jours read today

Read this month's entries:

jours read month

Read this year's entries:

jours read year

You can read your entire journal with

jours read all

The read command decrypts all relevant entries and prints the result in the /exposed/journal.txt.
Logging out

To logout from jours simply type

jours logout

This encrypts all unencrypted entries, removes the journal.txt file, and locks the /entries directory.
Switching Journals

Jours supports multiple journals to keep your thoughts and notes more organized. To create a new one use

jours create <journal name>

To switch journals while logged in use

jours switch 

# or

jours switch <journal name>

Locking entries

If you want to manually lock or unlock entries while logged in, use the lock or unlock command.

To lock/unlock the entry for today's date just run

jours lock

# or 

jours unlock

To lock/unlock a specific entry run

jours lock <date>

# or

jours unlock <date>

To lock/unlock all entries run

jours lock all

# or

jours unlock all
" >readme.txt

	echo -e "Congratulations! Your journal is ready to go. Compose an entry with ${GREEN}jours compose${RESET}"
	echo -e "Don't forget to run ${GREEN}jours logout${RESET} when you're finished."
	echo -e "For more information use ${GREEN}jours info${RESET}"

}

function check_arguments() {

	if [ -z "$ARGUMENT_1_GLOBAL" ]; then
		echo "Please pass in an argument to the journal"
		exit 1
	fi

}

function execute_command() {
	case $ARGUMENT_1_GLOBAL in
	init)
		init_journal
		;;
	login)
		jours_login
		;;
	logout)
		check_logged_in_status
		jours_logout "$ARGUMENT_2_GLOBAL"
		;;
	unlock)
		check_logged_in_status
		crypt unlock "$ARGUMENT_2_GLOBAL"
		;;

	lock)
		check_logged_in_status
		crypt lock "$ARGUMENT_2_GLOBAL"
		;;
	compose)
		check_logged_in_status
		compose
		;;
	read)
		check_logged_in_status
		jours_read "$ARGUMENT_2_GLOBAL"
		;;
	create)
		check_logged_in_status
		create_journal
		;;
	switch)
		check_logged_in_status
		switch_journal "$ARGUMENT_2_GLOBAL"
		;;
	rehash)
		check_logged_in_status
		rehash
		;;
	info)
		jours_info
		;;
	*)
		echo -e "Unknown command. please try again or use ${GREEN}jours info${RESET} if you're stuck."
		;;
	esac
}

function find_entry_location() {
	local entry_name="$1"
	directory_name=$(echo "$entry_name" | cut -c 1-7)
	echo "$JOURS_ENTRIES_DIRECTORY/$directory_name/$entry_name"
}

function find_entry_directory() {
	local entry_name="$1"
	directory_name=$(echo "$entry_name" | cut -c 1-7)
	echo "$JOURS_ENTRIES_DIRECTORY/$directory_name"
}

function jours_login() {
	echo "Welcome to jours. Please type your password:"
	read -s -r pass
	# validate password
	validate_password "$pass"
	# unlock / unzip entries directory
	padlock_entries unlock "$pass"
	echo -e "${GREEN}Login succeeded${RESET}"
	# if there is more than one journal, ask which journal to use
	cd "$JOURS_ENTRIES_DIRECTORY" || exit
	num_journals="$(expr $(ls | wc -l))"
	if [ ! "$num_journals" -eq 1 ]; then
		switch_journal
	fi
}

function switch_journal() {
	target_journal="$1"
	if [[ -z $target_journal ]]; then
		echo "What journal do you want to use?"
		cd "$JOURS_ENTRIES_DIRECTORY" || exit
		ls
		read -r target_journal
	fi

	if [ ! -d "$JOURS_ENTRIES_DIRECTORY"/"$target_journal" ]; then
		echo -e "${RED}This journal doesn't seem to exist.${RESET} Please type a valid journal or use ${GREEN}jours create${RESET} to make a new one."
		switch_journal
	fi

	echo -e "Switched to ${GREEN}$target_journal${RESET}"
	echo "CURRENT_JOURNAL='$target_journal'" >"$JOURS_ENTRIES_DIRECTORY"/.current
}

function create_journal() {
	# prompt the name of the journal
	echo -e "${GREEN}What's the name of this journal?${RESET}"
	read -r new_journal_name
	# validate name of journal
	# create the directory
	mkdir "$JOURS_ROOT_DIRECTORY/entries/$new_journal_name"
	# ask if you want to switch to this journal
	echo "Do you want to switch to this journal now? [y/n]"
	read -r answer
	if [ "$answer" == "y" ]; then
		echo -e "Switching to ${GREEN}$new_journal_name!${RESET}"
		echo "CURRENT_JOURNAL='$new_journal_name'" >>"$JOURS_ROOT_DIRECTORY"/entries/.current
	fi
}

function jours_logout() {
	echo "Please confirm your password:"
	read -r -s pass
	validate_password "$pass"
	echo "Have you saved your password correctly? ${ULINE}This is important.${RESET} [y/n]"
	read -r answer
	echo "$answer"
	if [ "$answer" == "y" ]; then
		echo "Clearing session information"
		if [ -d "$JOURS_ROOT_DIRECTORY/exposed/" ]; then
			rm -rf "$JOURS_ROOT_DIRECTORY"/exposed/
		fi
		padlock_journals lock "$pass"
		padlock_entries lock "$pass"
		echo -e "${GREEN}Succesfully locked all entries! Have a good day!${RESET}"
	elif [ "$answer" == "n" ]; then
		echo "Make sure you have saved your password!"
		echo "Do you want to view your password? [y/n]"
		read -r confirm_view_pass
		if [ "$confirm_view_pass" == "y" ]; then
			echo "Your password is: $(cat .secret)"
		fi
		padlock_all lock
		echo -e "${GREEN}Succesfully locked all entries! Have a good day!${RESET}"

	else
		echo "Unknown answer... type y or n!"
		jours_logout
	fi

}

function validate_day_format() {
	if [[ $1 =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
		echo "Date $1 is in valid format (YYYY-MM-DD)"
		return 0
	else
		echo "Date $1 is in an invalid format (not YYYY-MM-DD)"
		return 1
	fi

}

function validate_month_format() {
	if [[ $1 =~ ^[0-9]{4}-[0-9]{2}$ ]]; then
		echo "Date $1 is in valid format (YYYY-MM)"
		return 0
	else
		echo "Date $1 is in an invalid format (not YYYY-MM)"
		return 1
	fi
}

function check_logged_in_status() {
	if [ ! -d "$JOURS_ROOT_DIRECTORY/entries" ]; then
		echo -e "${RED}Please log in to execute this command.${RESET}"
		echo -e "Use ${GREEN}jours login${RESET}"
		exit 1
	fi
}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # #                       _   # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # #  ___ _ __ _   _ _ __ | |_   # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # / __| '__| | | | '_ \| __|# # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # #| (__| |  | |_| | |_) | |_ # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # \___|_|   \__, | .__/ \__|# # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # #           |___/|_|        # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

function create_password() {
	echo -e "Please enter a password you'd like to use or hit the ${GREEN}enter${RESET} key to generate a random one"
	echo "...The latter is recommended"
	read -s -r NEW_PASS
	target_directory=$JOURS_ROOT_DIRECTORY

	cd "$target_directory" || exit
	# generate salt
	openssl rand -base64 6 -out .salt
	if [[ -z $NEW_PASS ]]; then
		echo "Generating new password..."
		echo
		NEW_PASS=$(openssl rand -hex 32)
		echo "Your password is:"
		echo
		echo "$NEW_PASS"
		echo
		echo "Make sure to copy / save this somewhere safe!"

	else
		echo "Please retype your new password"
		read -s -r confirmed_pass
		if [ "$confirmed_pass" != "$NEW_PASS" ]; then
			echo -e "${RED} Passwords don't match. Try again."
			create_password
		else
			echo "Your password is $NEW_PASS"
		fi
	fi

	# hash the password with the salt
	salt_in=$(cat .salt)

	openssl passwd -1 -salt "$salt_in" "$NEW_PASS" >.hash

}

function validate_password() {
	# prompt password
	# validate password against hash + salt\
	echo "What's your password?"

	local password=$1
	echo "typed password: $password"
	# hash password with salt
	salt_in=$(cat "$JOURS_ROOT_DIRECTORY"/.salt)
	hash_attempt=$(openssl passwd -1 -salt "$salt_in" "$password")
	stored_hash=$(cat "$JOURS_ROOT_DIRECTORY"/.hash)
	if [ "$stored_hash" == "$hash_attempt" ]; then
		echo "Password accepted"
	else
		# exit 1 if the password doesn't match
		echo "Incorrect password!"
		exit 1
	fi
}

function padlock() {
	local option=$1
	echo "option: $option"
	local file_to_lock=$2
	local password="$3"

	[[ $option = "lock" ]] && local file_location="$(find_entry_location "$file_to_lock").txt" || local file_location="$(find_entry_location "$file_to_lock").enc"
	[[ $option = "lock" ]] && local encrypt_option="encode" || local encrypt_option="decode"
	[[ $option = "lock" ]] && file_type=".enc" || file_type=".txt"
	file_directory="$(find_entry_directory "$file_to_lock")"
	local output_file_path=$file_directory/$file_to_lock$file_type
	echo "file location: $file_location, file directory: $file_directory"
	encrypt_decrypt_single_file $encrypt_option "$file_location" "$output_file_path" "$password"
	if [[ $* == *-read* ]]; then
		local journal_file_path=$JOURS_ROOT_DIRECTORY/exposed/$CURRENT_JOURNAL.txt
		cat "$output_file_path" >>"$journal_file_path"
	fi
	rm "$file_location"
}

function padlock_multiple() {
	local option=$1
	local dirname_to_lock="$2"
	local password="$3"

	if [[ $* == *-read* ]]; then
		local read_flag="-read"
	fi

	[[ $option = "lock" ]] && local encrypt_option="encode" || local encrypt_option="decode"
	[[ $option = "lock" ]] && local input_file_type=".txt" || local input_file_type=".enc"
	[[ $option = "lock" ]] && local output_file_type=".enc" || local output_file_type=".txt"

	local full_dirname_to_lock="$JOURS_ENTRIES_DIRECTORY/$CURRENT_JOURNAL/$dirname_to_lock"
	cd "$full_dirname_to_lock" || exit
	for file in *; do
		input_file="$(pwd)/$file"
		output_file="$(pwd)/${file%.*}$output_file_type"
		if [[ $file == *$input_file_type ]]; then
			encrypt_decrypt_single_file $encrypt_option "$input_file" "$output_file" "$password"
			rm "$input_file"
		fi

		if [[ $* == *-read* ]]; then
			local journal_file_path="$JOURS_ROOT_DIRECTORY/exposed/$CURRENT_JOURNAL.txt"

			if [ ! -d "$JOURS_ROOT_DIRECTORY/exposed/" ]; then
				mkdir "$JOURS_ROOT_DIRECTORY"/exposed/
			fi
			if [ ! -f "$journal_file_path" ]; then
				touch "$journal_file_path"
			fi
			cat "$output_file" >>"$journal_file_path"
			echo "

			- - - - - - - - - - - - - - -

			" >>"$journal_file_path"
		fi
	done

}

function padlock_all() {
	if [[ $* == *-read* ]]; then
		local read_flag="-read"
	fi

	local option="$1"
	local password="$2"
	# In entries directory iterate over each month directory
	if [ ! -d "$JOURS_ENTRIES_DIRECTORY/$CURRENT_JOURNAL" ]; then
		echo -e "${RED}Your entries directory doesn't seem to exist!"
		echo -e "$JOURS_ENTRIES_DIRECTORY"
		exit 1
	fi

	for dir in $JOURS_ENTRIES_DIRECTORY/$CURRENT_JOURNAL/*/; do
		local dir=${dir%*/} # remove the trailing "/"
		padlock_multiple "$option" "${dir##*/}" "$password" "$read_flag"
	done

}

function padlock_journals() {
	local option="$1"
	local password="$2"
	# lock all journal entries
	for jour in $JOURS_ENTRIES_DIRECTORY/*/; do
		echo "journal: $jour"
		for dir in $jour/*/; do
			local dir=${dir%*/} # remove the trailing "/"
			padlock_multiple "$option" "${dir##*/}" "$password"
		done
	done
}

function padlock_entries {
	local option="$1"
	local password="$2"
	cd "$JOURS_ROOT_DIRECTORY" || exit
	if [ "$option" = "lock" ]; then
		tar -czvf entries.tgz entries
		encrypt_decrypt_single_file encode "$JOURS_ROOT_DIRECTORY"/entries.tgz locked.enc "$password"
		rm -rf entries
		rm entries.tgz
	elif [ "$option" = "unlock" ]; then
		encrypt_decrypt_single_file decode "$JOURS_ROOT_DIRECTORY"/locked.enc "$JOURS_ROOT_DIRECTORY"/entries.tgz "$password"
		tar -xzvf entries.tgz
		rm "$JOURS_ROOT_DIRECTORY"/entries.tgz
		rm "$JOURS_ROOT_DIRECTORY"/locked.enc
	fi

}

function encrypt_decrypt_single_file {

	local input_file_path="$2"
	local output_file_path="$3"
	local secret="$4"

	[[ $1 = "encode" ]] && local encrypt_option="" || local encrypt_option="-d"
	openssl enc $encrypt_option -p -aes-256-cbc -salt -in "$input_file_path" -out "$output_file_path" -k "$secret"

}

function crypt() {
	local target_date=$2
	local option=$1
	echo "Please type your password."
	read -s -r password_in

	validate_password "$password_in"

	if validate_month_format "$target_date"; then
		echo -e "${RED}$target_date month $target_date${RESET}"
		padlock_multiple "$option" "$target_date" "$password_in"
	elif validate_day_format "$target_date"; then
		echo -e "${RED}target day $target_date${RESET}"
		padlock "$option" "$target_date" "$password_in"
	elif [ "$target_date" == "all" ]; then
		echo -e "${RED}$option all entries${RESET}"
		padlock_all "$option" "$password_in"
	else
		echo "Unrecognized option. Enter a valid day, or month, or 'all' to lock all entries"
		exit 1
	fi

}

function rehash() {
	# prompt / validate password
	echo "Please type your password:"
	read -s -r password
	validate_password "$password"
	# unlock all journals and entries
	padlock_journals unlock "$password"

	echo -e "${GREEN}Creating new password!${RESET}"
	create_password
	echo "${GREEN}Your password was successfully changed. To complete the process please logout and log back in. Wait till later? [y/n]"
	read -r answer

	if [ "$answer" = "n" ]; then
		jours_logout
		exit 0
	fi
}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # #    ___ ___  _ __ ___  _ __   ___  ___  ___  # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # #   / __/ _ \| '_ ` _ \| '_ \ / _ \/ __|/ _ \ # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # #  | (_| (_) | | | | | | |_) | (_) \__ \  __/ # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # #   \___\___/|_| |_| |_| .__/ \___/|___/\___| # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # #                      |_|                    # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

function compose() {

	cd "$JOURS_ROOT_DIRECTORY"/entries/"$CURRENT_JOURNAL"/ || exit
	current_month="$(date +"%Y-%m")"
	if [ ! -d "$JOURS_ROOT_DIRECTORY/entries/$current_month" ]; then
		mkdir "$current_month"
		cd "$current_month" || exit
	else
		cd "$JOURS_ROOT_DIRECTORY"/entries/"$CURRENT_JOURNAL"/"$current_month" || exit

	fi
	current_date=$(date +"%Y-%m-%d")
	if [ -f "./$current_date.txt" ]; then
		echo "exists."
		open ./"$current_date".txt
	else
		local new_entry_name=$current_date.txt
		echo "$new_entry_name"
		touch "$new_entry_name"
		echo "$current_date" >>"$current_date".txt
		echo "Hello jours" >>"$current_date".txt
		open "$new_entry_name"
	fi

}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # #                     _ # # # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # #  _ __ ___  __ _  __| |# # # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # | '__/ _ \/ _` |/ _` |# # # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # | | |  __/ (_| | (_| |# # # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # |_|  \___|\__,_|\__,_|# # # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

function jours_read() {

	journal_file_path="$JOURS_ROOT_DIRECTORY/exposed/$CURRENT_JOURNAL.txt"
	if [[ -f $journal_file_path ]]; then
		rm "$journal_file_path"
		touch "$journal_file_path"
	fi

	echo "Please type your password:"
	read -s -r password

	validate_password "$password"

	local target_date=$1
	local option="unlock"
	if validate_month_format "$target_date"; then
		echo -e "${RED}$target_date month $target_date${RESET}"
		padlock_multiple $option "$target_date" "$password" -read
	elif validate_day_format "$target_date"; then
		echo -e "${RED}target day $target_date${RESET}"
		padlock $option "$target_date" "$password" -read
	elif [ "$target_date" == "all" ]; then
		echo -e "${RED}$option all entries${RESET}"
		padlock_all $option "$password" -read
	else
		echo "Unrecognized option. Enter a valid day, or month, or 'all' to lock all entries"
		exit 1
	fi

	echo "Open Journal? [y/n]"
	read -r answer

	if [ "$answer" = "y" ]; then
		open "$JOURS_ROOT_DIRECTORY"/exposed/"$CURRENT_JOURNAL".txt
	else
		echo -e "${RED}Goodbye.${RESET}"
		exit 1
	fi

}

# INFO FUNCTION
function jours_info() {
	if [ -d "$JOURS_ROOT_DIRECTORY" ]; then
		open "$JOURS_ROOT_DIRECTORY"/readme.txt
	else
		echo -e "No root directory, run ${GREEN}jours init${RESET}"
		exit 1
	fi
}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # # # #  _____  _____  ___  # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # # # # / _ \ \/ / _ \/ __| # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # # # #|  __/>  <  __/ (__  # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # # # #\___/_/\_\___|\___|  # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
check_init_status

# once config file is sourced, set this globally
check_arguments
execute_command