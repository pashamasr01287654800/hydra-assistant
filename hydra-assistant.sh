#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${YELLOW}==============================================${NC}"
echo -e "${CYAN}             WELCOME TO HYDRA                 ${NC}"
echo -e "${GREEN}Unleash the Power of Brute-Force Precision!  ${NC}"
echo -e "${RED}Shatter Defenses. Expose Vulnerabilities. Dominate the Digital World. ${NC}"
echo -e "${YELLOW}==============================================${NC}"
echo

# Request target IP
while true; do
    read -p "Enter the target IP address: " target_ip
    if [[ -z $target_ip ]]; then
        echo -e "${RED}The target IP cannot be empty.${NC}"
    else
        break
    fi
done

# Request target port
read -p "Enter the target port (leave empty for default): " target_port

# Display supported protocols
services=("ftp" "ssh" "telnet" "smtp" "http-get" "http-post" "https-get" "https-post" "http-get-form" "https-get-form" "http-post-form" "https-post-form" "mysql" "vnc" "rdp" "ldap" "smb" "imap" "pop3" "sftp")
echo "Select the protocol you want to use:"
for i in "${!services[@]}"; do
    echo "$((i+1))) ${services[i]}"
done

# Select protocol
while true; do
    read -p "Enter the number of the protocol: " service_choice
    if [[ $service_choice -lt 1 || $service_choice -gt ${#services[@]} ]]; then
        echo -e "${RED}Invalid choice. Please enter a valid number.${NC}"
    else
        selected_service=${services[service_choice-1]}
        break
    fi
done

# Handle protocols requiring special inputs
case $selected_service in
    "http-get-form"|"https-get-form"|"http-post-form"|"https-post-form")
        while true; do
            read -p "Enter the target URL path (e.g., /login): " url_path
            if [[ -z $url_path ]]; then
                echo -e "${RED}The URL path cannot be empty.${NC}"
            else
                break
            fi
        done

        while true; do
            read -p "Enter POST parameters (e.g., username=^USER^&password=^PASS^): " post_params
            if [[ -z $post_params ]]; then
                echo -e "${RED}POST parameters cannot be empty.${NC}"
            else
                break
            fi
        done

        while true; do
            read -p "Enter the error message to identify failed attempts (e.g., 'Authorization Required'): " error_message
            if [[ -z $error_message ]]; then
                echo -e "${RED}Error message cannot be empty.${NC}"
            else
                break
            fi
        done
        ;;
esac

# Request username or username file
while true; do
    echo "How would you like to specify usernames?"
    echo "1) Enter a username manually"
    echo "2) Use a file containing usernames"
    read -p "Enter your choice (1/2): " username_choice
    case $username_choice in
        1) 
            read -p "Enter the username: " username
            break
            ;;
        2) 
            while true; do
                read -p "Enter the path to the file containing usernames: " username_file
                if [[ ! -f $username_file ]]; then
                    echo -e "${RED}File not found: $username_file.${NC}"
                else
                    break
                fi
            done
            break
            ;;
        *) 
            echo -e "${RED}Invalid choice.${NC}"
            ;;
    esac
done

# Request password or password file
while true; do
    echo "How would you like to specify passwords?"
    echo "1) Enter a password manually"
    echo "2) Use a file containing passwords"
    read -p "Enter your choice (1/2): " password_choice
    case $password_choice in
        1) 
            read -p "Enter the password: " password
            break
            ;;
        2) 
            while true; do
                read -p "Enter the path to the file containing passwords: " password_file
                if [[ ! -f $password_file ]]; then
                    echo -e "${RED}File not found: $password_file.${NC}"
                else
                    break
                fi
            done
            break
            ;;
        *) 
            echo -e "${RED}Invalid choice.${NC}"
            ;;
    esac
done

# Ask the user about including -V
while true; do
    read -p "Do you want to include the '-V' option to show verbose output? (yes/y or no/n): " verbose_choice
    case $verbose_choice in
        yes|y|Y) 
            verbose_option="-V"
            break
            ;;
        no|n|N)
            verbose_option=""
            break
            ;;
        *)
            echo -e "${RED}Invalid input. Please answer 'yes/y' or 'no/n'.${NC}"
            ;;
    esac
done

# Ask the user about the guess type (same as login, null, reverse login)
while true; do
    read -p "If you want to test for passwords (s)ame as login, (n)ull or (r)everse login, enter these letters without spaces (e.g. 'sr') or leave empty otherwise: " guess_type
    if [[ "$guess_type" =~ ^[snr]*$ ]]; then
        break
    else
        echo -e "${RED}Invalid input. Please enter only 's', 'n', 'r' without spaces, or leave empty.${NC}"
    fi
done

# Ask the user about the -t option (attempts per second)
while true; do
    read -p "Enter the number of attempts per second (-t option, e.g., 10): " attempts_per_second
    if [[ -z $attempts_per_second ]]; then
        # If the user leaves the field blank, -t is not added
        break
    elif [[ ! $attempts_per_second =~ ^[0-9]+$ ]] || [ "$attempts_per_second" -le 0 ]; then
        echo -e "${RED}Please enter a valid positive integer.${NC}"
    else
        break
    fi
done

# Build the final Hydra command
hydra_command="hydra "

if [[ $username_choice -eq 1 ]]; then
    hydra_command+="-l $username "
else
    hydra_command+="-L $username_file "
fi

if [[ $password_choice -eq 1 ]]; then
    hydra_command+="-p $password "
else
    hydra_command+="-P $password_file "
fi

hydra_command+="-u "

# Add the guess type based on user's input (add "-e" only if $guess_type is not empty)
if [[ -n $guess_type ]]; then
    hydra_command+="-e $guess_type "
fi

# Add the -V option based on the user's choice
if [[ -n $verbose_option ]]; then
    hydra_command+="$verbose_option "
fi

# Add the -t option only if the user provided a value
if [[ -n $attempts_per_second ]]; then
    hydra_command+="-t $attempts_per_second "
fi

if [[ $selected_service == "http-get-form" || $selected_service == "https-get-form" || $selected_service == "http-post-form" || $selected_service == "https-post-form" ]]; then
    hydra_command+="-m \"$url_path:$post_params:$error_message\" $target_ip $selected_service"
else
    hydra_command+="$target_ip $selected_service"
fi

# Output the final command
echo -e "${GREEN}The final Hydra command is:${NC}"
echo -e "${YELLOW}$hydra_command${NC}"

# Ask for confirmation before execution
while true; do
    read -p "Do you want to execute this command? (yes/y or no/n): " user_response
    case $user_response in
        yes|y|Y)
            echo -e "${GREEN}Executing the command...${NC}"
            eval $hydra_command
            break
            ;;
        no|n|N)
            echo -e "${RED}Exiting the script.${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid input. Please answer 'yes/y' or 'no/n'.${NC}"
            ;;
    esac
done
