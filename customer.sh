#!/bin/bash
# Function to display products based on category 
# Takes one argument: the category choice
display_products (){
  case $1 in
      1) clear
         echo "**********************************************"
         echo "*                                            *"
         echo "*                All products                *"
         echo "*                                            *"
         echo "**********************************************"  
         # Use awk to print all products with categories "Men", "Women", or "Unisex"
         awk -F ',' -v OFS=', ' '$3 == "Men" || $3 == "Women" || $3 == "Unisex" {print $1, $2, $3, $NF}' products.txt ;; 
      2) clear
         echo "**********************************************"  
         echo "*                                            *"
         echo "*               Men's clothing               *"
         echo "*                                            *"
         echo "**********************************************"  
         # Use awk to print products with the category "Men"
         awk -F ',' -v OFS=', ' '$3 == "Men" {print $1, $2, $3, $NF}' products.txt ;; 
      3) clear
         echo "**********************************************"  
         echo "*                                            *"
         echo "*              Women's clothing              *"
         echo "*                                            *"
         echo "**********************************************"  
         # Use awk to print products with the category "Women"
         awk -F ',' -v OFS=', ' '$3 == "Women" {print $1, $2, $3, $NF}' products.txt ;;
      4) clear
         echo "**********************************************" 
         echo "*                                            *"
         echo "*              Unisex clothing               *"
         echo "*                                            *"
         echo "**********************************************"
         # Use awk to print products with the category "Unisex"
         awk -F ',' -v OFS=', ' '$3 == "Unisex" {print $1, $2, $3, $NF}' products.txt ;;
      *) echo "Invalid choice!" ;;
  esac
}

# Function to add products to the basket
add_to_basket() {
  while true; do
  # Prompt the user to enter the ID of the product they want to buy
    read -p "Enter the ID of the product you want to buy: " product_id
    # Check if the product ID exists in the products file
    if grep -q "^$product_id," products.txt; then
      # Ask for the size of the product
      while true; do
        echo "Select the size of the product:"
        echo "1. Small"
        echo "2. Medium"
        echo "3. Large"
        echo "4. XLarge"
        read -p "Enter your choice (1-4): " size_choice
        
        # Determine the selected size and check its availability
        case $size_choice in
          1)
            size="Small"
            # Use awk to get the available quantity of the Small size with the product id
            qty=$(awk -F ',' -v id="$product_id" '$1 == id {print $4}' products.txt) 
            ;;
          2)
            size="Medium"
             # Use awk to get the available quantity of the Medium size with the product id
            qty=$(awk -F ',' -v id="$product_id" '$1 == id {print $5}' products.txt)
            ;;
          3)
            size="Large"
            # Use awk to get the available quantity of the Large size with the product id
            qty=$(awk -F ',' -v id="$product_id" '$1 == id {print $6}' products.txt)
            ;;
          4)
            size="XLarge"
            # Use awk to get the available quantity of the XLarge size with the product id
            qty=$(awk -F ',' -v id="$product_id" '$1 == id {print $7}' products.txt)
            ;;
          *)
            echo "Invalid choice! Please enter a number between 1 and 4." # Handle invalid input
            continue
            ;;
        esac

        # Check if the selected size is available
        if [ "$qty" -gt 0 ]; then
        	# Extract product information from products.txt
      		product_name=$(awk -F ',' -v id="$product_id" '$1 == id {print $2}' products.txt)
      		category=$(awk -F ',' -v id="$product_id" '$1 == id {print $3}' products.txt)
      		price=$(awk -F ',' -v id="$product_id" '$1 == id {print $8}' products.txt)
      
      		# Add the product ID, name, category, size, and price to the "Basket" file
      		echo "$product_id," "$product_name," "$category," "$size," "$price" >> Basket.txt
      		echo "Product with ID $product_id (Size: $size) added to Basket."
      	else
      		echo "Selected size $size is not available for this product."
        fi
        break
      done
      # Ask the user if they want to buy other products
      while true; do
        read -p "Do you want to buy other products? (y/n): " buy_more
        case $buy_more in
          [Yy]) break ;; # If yes, break the inner loop and continue to add more products
          [Nn]) return ;; # If no, exit the function
          *) echo "Invalid input! Please enter 'y' for yes or 'n' for no." ;; # Handle invalid input
        esac
      done
      
    else
      echo "Invalid product ID! Please enter a valid ID."
    fi
  done
}
  

delete_from_basket() {
while true; do
    read -p "Enter the ID of the product you want to remove: " product_id

    # Check if the product ID exists in the basket
    if grep -q "^$product_id" Basket.txt; then
    # Ask for the size of the product to delete
        while true; do
            echo "Select the size of the product to remove:"
            echo "1) Small"
            echo "2) Medium"
            echo "3) Large"
            echo "4) XLarge"
            read -p "Enter your choice (1-4): " size_choice
	    # Determine the selected size based on the user's choice
            case $size_choice in
                1) size="Small"; break ;; # Set size to Small and exit loop
                2) size="Medium"; break ;; # Set size to Medium and exit loop
                3) size="Large"; break ;; # Set size to Large and exit loop
                4) size="XLarge"; break ;; # Set size to XLarge and exit loop
                *) echo "Invalid choice! Please enter a number between 1 and 4." ;; # Handle invalid input
            esac
        done
	# Check if the product with the specified size exists in the basket
        if grep -q "^$product_id.*$size" Basket.txt; then
        # delete the product with the specified size from the basket
            sed -i "/^$product_id/ { /$size/ d }" Basket.txt 
            echo "Product with ID $product_id (Size: $size) removed from the basket."

            # Check if the basket has more than one line
            if [ "$(wc -l < Basket.txt)" -gt 0 ]; then
                while true; do
                # Ask if the user wants to delete another product
                    read -p "Do you want to delete another product? (y/n): " delete_another
                    case $delete_another in
                        [Yy]) continue 2 ;; #  If yes, Continue to the outer loop to delete another product
                        [Nn]) return ;; # If no, exit the function
                        *) echo "Invalid input! Please enter 'y' for yes or 'n' for no." ;; # Handle invalid input
                    esac
                done
            else
                echo "The basket is now empty!"
                exit
            fi
        else 
            echo "Product with ID $product_id and size $size not found in the basket!"
        fi
    else
        echo "Product ID not found in the basket! Please enter a valid ID."
    fi
done
}


display_basket(){
  
  # Calculate total price using awk
  total_price=$(awk -F ',' '{total+=$NF} END {print total}' Basket.txt)
  
  # Check if total_price is a number
  if [[ $total_price -eq $total_price ]] 2>/dev/null; then
  echo " "
  
  echo "Your basket contains the following products:"
     # Print table header
        printf "| %-10s | %-15s | %-10s | %-12s | %-10s |\n" "Product ID" "Product Name" "Category" "Size" "Price (SAR)"
        printf "|------------|-----------------|------------|--------------|-------------|\n"

        # Read data from file and print data rows
        while IFS=',' read -r id name category size price; do
            printf "| %-10s | %-15s | %-10s | %-12s | %-11s |\n" "$id" "$name" "$category" "$size" "$price"
        done < Basket.txt
  
  echo "Total Price: $total_price SAR"
  
  else
   echo "*Thank you for visiting our online shopping*"
   
  fi
}

# Function for basket options
basket_options() {
  
  while true; do
  
    clear
    echo " "
    echo "**********************************************" 
    echo "*                                            *" 
    echo "*              Basket Options                *"
    echo "*                                            *"
    echo "**********************************************" 
    echo "  1) Confirm order"
    echo "  2) Buy more"
    echo "  3) Delete product"
    echo "  4) Exit"
    read -p "Enter your choice: " basket_option

    case $basket_option in
      1) 
        echo "Order confirmed. Thank you for shopping with us!"
        display_basket # Display th basket
        rm Basket.txt # Remove the basket file and exit the script
        exit ;;
      2) 
        add_to_basket ;; # Call the function to add more products to the basket
      3) 
        delete_from_basket ;; # Call the function to delete a product from the basket
      4)
        echo "Exiting."
        rm Basket.txt # Remove the basket file and exit the script
        exit ;;
      *) echo "Invalid choice! Please enter a number between 1 and 4."
         sleep 2 ;; # Handle invalid input
    esac
  done
}
 


# Main loop
while true; do
  # Clear the screen and display the basket options menu
  clear
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
  read -p "Enter your choice: " choice

  case $choice in
  	1|2|3|4) display_products "$choice"
           add_to_basket  ;; #Call the function to add products to the basket
        5) exit 0 ;; # Exit the script
        *) echo "Invalid choice! Please enter a number between 1 and 5."
           sleep 2 ;; # Handle invalid input
  esac
  display_basket
  basket_options #Call the function to display basket options after added to the basket
done
