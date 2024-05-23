#!/bin/bash


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



# Function to display products based on category 
 display_products (){
  case $1 in
    1) echo "Women's clothing"
      # Add code to display women's clothing products (replace with your logic)
      ;;  # Use double semicolons (;) to terminate case statements 
    2) echo "Men's clothing"
      # Add code to display men's clothing products (replace with your logic)
      ;;  # Use double semicolons (;) to terminate case statements 
    *) echo "Invalid choice!"  # Handle unexpected case inside display_products
      ;;
  esac
}
