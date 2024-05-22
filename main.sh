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

    read -p "Enter your name: " customer_name

    while true; do
        read -p "Enter your phone number (10 digits): " phone_number
        if [[ $phone_number =~ ^[0-9]{10}$ ]]; then
            break
        else
            echo "Invalid phone number. Please enter a 10-digit number."
        fi
    done

    echo "Welcome back, $customer_name! You're now logged in."
    read -p "Press Enter to return to main menu" enter_key
}

# Function to handle admin login
admin_login() {
    clear
    echo "**********************************************"
    echo "*                                            *"
    echo "*               Admin Login                  *"
    echo "*                                            *"
    echo "**********************************************"
    read -p "Enter your ID: " admin_id

    # Prompt for password without showing characters
    echo -n "Enter your password: "

    # Turn off echoing
    stty -echo

    # Read password
    read admin_password

    # Turn echoing back on
    stty echo

    echo "" # For newline after password input

    # Define valid admin credentials
    declare -A admin_credentials
    admin_credentials["Kawthr"]="Kawthr123"
    admin_credentials["Arwa"]="Arwa123"
    admin_credentials["Sumaiah"]="Sumaiah123"

    # Check if the entered credentials are valid
    if [[ -n "${admin_credentials[$admin_id]}" && "${admin_credentials[$admin_id]}" == "$admin_password" ]]; then
        echo "Welcome, $admin_id! You're now logged in."
        read -p "Press Enter to continue" enter_key
        # Here you can call another script or continue with admin tasks
        # For example: sh admin.sh
    else
        echo "Invalid ID or password. Please try again."
        read -p "Press Enter to return to admin login" enter_key
    fi
}

# Main function
main() {
    while true; do
        display_menu

        read -p "Enter your choice: " choice

        case $choice in
            1)
                customer_login
                ;;
            2)
                admin_login
                ;;
            3)
                echo "Thank you for visiting. Goodbye!"
                exit 0
                ;;
            *)
                echo "Invalid choice. Please enter a valid option."
                read -p "Press Enter to return to main menu" enter_key
                ;;
        esac
    done
}

# Call the main function
main

