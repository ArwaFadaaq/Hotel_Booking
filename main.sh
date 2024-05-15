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
    read -p "Enter your phone number: " phone_number
    # For demonstration purposes, any phone number is accepted
    echo "Welcome back, dear customer! You're now logged in."
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
    # Add your admin login logic here
    # For demonstration purposes, let's assume a fixed admin ID and password
    if [ "$admin_id" = "admin" ] && [ "$admin_password" = "admin123" ]; then
        echo "Welcome, Administrator! You're now logged in."
        ./admin.sh
    else
        echo "Invalid ID or password. Please try again."
    fi
    read -p "Press Enter to return to main menu" enter_key
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
                ;;
        esac
    done
}

# Call the main function
main

