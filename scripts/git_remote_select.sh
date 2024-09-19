#!/usr/bin/env bash

get_remote_names() {
    git remote -v | awk '{print $1}' | sort | uniq
}

# # Prompt function
# prompt_select() {
#     options=($(get_remote_names))
#     echo "Please select an option:"
#     for i in "${!options[@]}"; do
#         echo "$(($i + 1)). ${options[$i]}"
#     done
# }

# # Main script
# # clear
# # prompt_select

# # Read user input
# read -rp "Enter your choice (1-${#options[@]}): " choice

# # Validate and process the user choice
# if [[ $choice =~ ^[0-9]+$ ]] && ((choice >= 1 && choice <= ${#options[@]})); then
#     selected_option="${options[$((choice - 1))]}"
#     echo "You selected: $selected_option"
# else
#     echo "Invalid choice. Exiting..."
# fi

# # Function to prompt user for selection
# prompt_select() {
#     local options=("$@")  # Store options in an array
#     local num_options=${#options[@]}  # Number of options
#     local selected_index=0  # Index of the currently selected option

#     # Enable reading single key presses
#     old_stty=$(stty -g)
#     stty -icanon

#     # Function to print the options menu
#     print_menu() {
#         clear
#         echo "Please select an option:"
#         for i in "${!options[@]}"; do
#             if [[ $i -eq $selected_index ]]; then
#                 echo "  > ${options[$i]}"
#             else
#                 echo "    ${options[$i]}"
#             fi
#         done
#     }

#     # Function to handle arrow key input
#     handle_arrow_key() {
#         local key
#         read -rsn1 key  # Read single key

#         case "$key" in
#             $'\x1b')  # Escape key (exit without selecting)
#                 selected_index=-1
#                 ;;
#             $'\x0a')  # Enter key
#                 break  # Exit loop and return selected option
#                 ;;
#             $'\x5b')  # Arrow keys
#                 read -rsn2 key  # Read additional key for arrow keys
#                 case "$key" in
#                     "A")  # Up arrow
#                         selected_index=$((selected_index - 1))
#                         ;;
#                     "B")  # Down arrow
#                         selected_index=$((selected_index + 1))
#                         ;;
#                 esac
#                 ;;
#         esac

#         # Ensure selected index stays within bounds
#         if ((selected_index < 0)); then
#             selected_index=$((num_options - 1))
#         elif ((selected_index >= num_options)); then
#             selected_index=0
#         fi

#         print_menu  # Redraw menu
#     }

#     # Main loop to handle input
#     while true; do
#         print_menu

#         # Read keypress
#         read -rsn1 key

#         case "$key" in
#             $'\x1b')  # Escape key (exit without selecting)
#                 selected_index=-1
#                 break
#                 ;;
#             $'\x0a')  # Enter key
#                 break  # Exit loop and return selected option
#                 ;;
#             $'\x5b')  # Arrow keys
#                 handle_arrow_key
#                 ;;
#         esac
#     done

#     # Restore original terminal settings
#     stty "$old_stty"

#     # Return selected option index (-1 if no option selected)
#     echo "$selected_index"
# }

# # Example usage
# options=("Option 1" "Option 2" "Option 3" "Quit")

# # Prompt for selection
# selected_index=$(prompt_select "${options[@]}")

# # Process selected option
# if ((selected_index >= 0)); then
#     selected_option="${options[$selected_index]}"
#     echo "You selected: $selected_option"
# else
#     echo "No option selected. Exiting..."
# fi


#!/usr/bin/env bash

# Renders a text based list of options that can be selected by the
# user using up, down and enter keys and returns the chosen option.
#
#   Arguments   : list of options, maximum of 256
#                 "opt1" "opt2" ...
#   Return value: selected index (0 for opt1, 1 for opt2 ...)
function select_option {

    # little helpers for terminal print control and key input
    ESC=$( printf "\033")
    cursor_blink_on()  { printf "$ESC[?25h"; }
    cursor_blink_off() { printf "$ESC[?25l"; }
    cursor_to()        { printf "$ESC[$1;${2:-1}H"; }
    print_option()     { printf "   $1 "; }
    print_selected()   { printf "  $ESC[7m $1 $ESC[27m"; }
    get_cursor_row()   { IFS=';' read -sdR -p $'\E[6n' ROW COL; echo ${ROW#*[}; }
    key_input()        { read -s -n3 key 2>/dev/null >&2
                         if [[ $key = $ESC[A ]]; then echo up;    fi
                         if [[ $key = $ESC[B ]]; then echo down;  fi
                         if [[ $key = ""     ]]; then echo enter; fi; }

    # initially print empty new lines (scroll down if at bottom of screen)
    for opt; do printf "\n"; done

    # determine current screen position for overwriting the options
    local lastrow=`get_cursor_row`
    local startrow=$(($lastrow - $#))

    # ensure cursor and input echoing back on upon a ctrl+c during read -s
    trap "cursor_blink_on; stty echo; printf '\n'; exit" 2
    cursor_blink_off

    local selected=0
    while true; do
        # print options by overwriting the last lines
        local idx=0
        for opt; do
            cursor_to $(($startrow + $idx))
            if [ $idx -eq $selected ]; then
                print_selected "$opt"
            else
                print_option "$opt"
            fi
            ((idx++))
        done

        # user key control
        case `key_input` in
            enter) break;;
            up)    ((selected--));
                   if [ $selected -lt 0 ]; then selected=$(($# - 1)); fi;;
            down)  ((selected++));
                   if [ $selected -ge $# ]; then selected=0; fi;;
        esac
    done

    # cursor position back to normal
    cursor_to $lastrow
    printf "\n"
    cursor_blink_on

    return $selected
}


echo "Select one option using up/down keys and enter to confirm:"
echo

# options=("one" "two" "three")

options=($(get_remote_names))
options+=("Quit")

# select_option "${options[@]}"
# choice=$?

# echo "Choosen index = $choice"
# echo "        value = ${options[$choice]}"





# Prompt for selection
# selected_index=$(select_option "${options[@]}")
select_option "${options[@]}"
selected_index=$?

# Process selected option
if ((selected_index >= 0 && selected_index < ${#options[@]} - 1)); then
    selected_option="${options[$selected_index]}"
    echo "You selected: $selected_option"

    git branch --set-upstream-to="${selected_option}/$(git symbolic-ref --short HEAD)"
elif ((selected_index == ${#options[@]} - 1)); then
    echo "Exiting..."
else
    echo "Invalid option. Exiting..."
fi
