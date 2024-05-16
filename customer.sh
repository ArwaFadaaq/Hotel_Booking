#!/bin/bash
# Function to display products based on category 
display_products (){
  case $1 in
    1) echo "Men's clothing"
       awk -F ',' '$3 == "Men" {print $1, $2, $3, $NF}' products.txt
       read -p "Press Enter to return to menu" enter_key
       ;; 
      
    2) echo "Women's clothing"
       awk -F ',' '$3 == "Women" {print $1, $2, $3, $NF}' products.txt
       read -p "Press Enter to return to menu" enter_key
       ;; 
    *) echo "Invalid choice!"  
       ;;
  esac
}

# Main loop
while true; do
  # Display clothing options
  echo "**********************************************"
  echo "*                                            *"
  echo "*                Customer Menu               *"
  echo "*                                            *"
  echo "**********************************************"
  echo "Select a category:"
  echo "  1) Women's clothing"
  echo "  2) Men's clothing"
  echo "  3) Exit"

  # Read user choice with validation loop
  while true; do
    read -p "Enter your choice: " choice

    # Check if choice is a valid number between 1 and 3 (inclusive)
    if [[ "$choice" =~ ^[1-3]$ ]]; then
      break;
    else
      echo "Invalid choice! Please enter a number between 1 and 3."
    fi
  done

  # Check if user chose to exit (option 3)
  if [[ "$choice" == "3" ]]; then
    exit 0;
  else
    # Display products based on valid choice
    display_products "$choice"
  fi
done




