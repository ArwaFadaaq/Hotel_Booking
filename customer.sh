#!/bin/bash
# Function to display products based on category 
display_products (){
  case $1 in
      1) echo "**********************************************"
         echo "*                                            *"
         echo "*               All products                 *"
         echo "*                                            *"
         echo "**********************************************"  
         awk -F ',' '$3 == "Men" || $3 == "Women" {print $1, $2, $3, $NF}' products.txt
        
        ;; 
     2) echo "**********************************************"  
        echo "*                                            *"
        echo "*                Men's clothing              *"
        echo "*                                            *"
        echo "**********************************************"   
       awk -F ',' '$3 == "Men" {print $1, $2, $3, $NF}' products.txt
      
       ;; 
      
    3) echo "**********************************************"  
       echo "*                                            *"
       echo "*                Women's clothing            *"
       echo "*                                            *"
       echo "**********************************************"  
       awk -F ',' '$3 == "Women" {print $1, $2, $3, $NF}' products.txt
       ;;
       
    4) echo "**********************************************"  
       echo "*                                            *"
       echo "*                Unisex clothing             *"
       echo "*                                            *"
       echo "**********************************************"  
       awk -F ',' '$3 == "Unisex" {print $1, $2, $3, $NF}' products.txt
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
  echo "Select what you want to see:"
  echo "  1) All products   "
  echo "  2) Men's  clothing"
  echo "  3) Women's clothing"
  echo "  4) Unisex clothing"
  echo "  5) Exit"

# Read user choice with validation loop
  while true; do
    read -p "Enter your choice: " choice

    # Check if choice is a valid number between 1 and 5 (inclusive)
    if [[ "$choice" =~ ^[1-5]$ ]]; then
      break;
    else
      echo "Invalid choice! Please enter a number between 1 and 5."
    fi
  done

  # Check if user chose to exit (option 5)
  if [[ "$choice" == "5" ]]; then
    exit 0;
  else
    # Display products based on valid choice
    display_products "$choice"

    # Prompt user to buy a product
    while true; do
      read -p "Enter the ID of the product you want to buy (or press Enter to return to menu): " product_id
      
      # Check if the user wants to return to the menu
      if [[ -z "$product_id" ]]; then
        break;
      fi
      
      # Check if the product ID exists in the products list
      if grep -q "^$product_id," products.txt; then
        # Ask for the size of the product
        while true; do
          echo "Select the size of the product:"
          echo "1) Small"
          echo "2) Medium"
          echo "3) Large"
          echo "4) XLarge"
          read -p "Enter your choice (1-4): " size_choice
          
          case $size_choice in
            1) size="Small"; break ;;
            2) size="Medium"; break ;;
            3) size="Large"; break ;;
            4) size="XLarge"; break ;;
            *) echo "Invalid choice! Please enter a number between 1 and 4." ;;
          esac
        done
        
        # Add the product ID and size to the "Basket" file
        echo "$product_id, $size" >> Basket.txt
        echo "Product with ID $product_id (Size: $size) added to Basket."
        
      else
        echo "Invalid product ID! Please enter a valid ID."
      fi
    done
  fi
done
