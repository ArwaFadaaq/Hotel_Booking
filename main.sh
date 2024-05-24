#!/bin/bash

# Function to display the main menu
display_menu() {
    clear
    echo "**********************************************"
    echo "*                                            *"
    echo "*               Welcome to Our               *"
    echo "*             Awesome Online Shop!           *"
    echo "*                                            *"
    echo "**********************************************"
    echo "1. Log in as Customer"
    echo "2. Log in as Admin"
    echo "3. Exit"
    echo "**********************************************"
}

# Function to handle customer login
customer_login() {
    clear
    echo "**********************************************"
    echo "*                                            *"
    echo "*             Customer Login                 *"
    echo "*                                            *"
    echo "**********************************************"

    # Prompt the user to enter their name
    read -p "Enter your name: " customer_name

    # Loop until a valid phone number is entered
    while true; do
        read -p "Enter your phone number (10 digits): " phone_number
        if [[ $phone_number =~ ^[0-9]{10}$ ]]; then
            break
        else
            echo -e "\e[91mInvalid phone number. Please enter a 10-digit number.\e[0m"
        fi
    done

    # Display a welcome message after successful login
    echo "Welcome, $customer_name! You're now logged in."
    read -p "Press Enter to continue" enter_key
}

# Function to handle admin login
admin_login() {
    clear
    echo "**********************************************"
    echo "*                                            *"
    echo "*               Admin Login                  *"
    echo "*                                            *"
    echo "**********************************************"
    
    # Prompt the user to enter their name
    read -p "Enter your name: " admin_name

    # Prompt for password without showing characters
    read -sp "Enter your password: " admin_password
    
    echo "" # For newline after password input

    # Define valid admin credentials
    declare -A admin_credentials
    admin_credentials["Kawthr"]="Kawthr123"
    admin_credentials["Arwa"]="Arwa123"
    admin_credentials["Sumaiah"]="Sumaiah123"

    # Check if the entered credentials are valid
    if [[ -n "${admin_credentials[$admin_name]}" && "${admin_credentials[$admin_name]}" == "$admin_password" ]]; then
        # Display a welcome message after successful login
        echo "Welcome, $admin_name! You're now logged in."
        read -p "Press Enter to continue" enter_key
    else
        # Display an error message for invalid credentials and prompt to try again
        echo -e "\e[91mInvalid ID or password. Please try again.\e[0m"
        read -p "Press Enter to return to admin login" enter_key
        admin_login
    fi
}

# Main function to control the flow of the script
main() {
    while true; do
        # Display the main menu
        display_menu

        # Prompt the user to enter their choice
        read -p "Enter your choice: " choice

        case $choice in
            1)
                # Handle customer login and launch the customer script
                customer_login
                bash customer.sh
                exit 0
                ;;
            2)
                # Handle admin login and launch the admin script
                admin_login
                bash admin.sh
                exit 0
                ;;
            3)
                # Exit the script with a goodbye message
                echo "Thank you for visiting. Goodbye!"
                exit 0
                ;;
            *)
                # Handle invalid menu choice
                echo -e "\e[91mInvalid choice. Please enter a valid option.\e[0m"
                read -p "Press Enter to return to main menu" enter_key
                ;;
        esac
    done
}

# Call the main function to start the script
main

