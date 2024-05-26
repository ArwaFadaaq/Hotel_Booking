#!/bin/bash

# Function to display products based on category
# Takes one argument: the category choice
display_products () {
  case $1 in
    1)  # Display all products
      clear
      echo "**********************************************"
      echo "*                                            *"
      echo "*                All products                *"
      echo "*                                            *"
      echo "**********************************************"  
      printf "| %-10s | %-15s | %-10s | %-10s |\n" "Product ID" "Product Name" "Category" "Price (SAR)"
      printf "|------------|-----------------|------------|-------------|\n"
      # Use awk to print all products with categories "Men", "Women", or "Unisex"
      awk -F ',' '{printf "| %-10s | %-15s | %-10s | %-11s |\n", $1, $2, $3, $NF}' products.txt
      ;;
    2)  # Display men's clothing
      clear
      echo "**********************************************"  
      echo "*                                            *"
      echo "*               Men's clothing               *"
      echo "*                                            *"
      echo "**********************************************"
      printf "| %-10s | %-15s | %-10s | %-10s |\n" "Product ID" "Product Name" "Category" "Price (SAR)"
      printf "|------------|-----------------|------------|-------------|\n"
      # Use awk to print products with the category "Men"
      awk -F ',' '$3 == "Men" {printf "| %-10s | %-15s | %-10s | %-11s |\n", $1, $2, $3, $NF}' products.txt
      ;;
    3)  # Display women's clothing
      clear
      echo "**********************************************"  
      echo "*                                            *"
      echo "*              Women's clothing              *"
      echo "*                                            *"
      echo "**********************************************" 
      printf "| %-10s | %-15s | %-10s | %-10s |\n" "Product ID" "Product Name" "Category" "Price (SAR)"
      printf "|------------|-----------------|------------|-------------|\n"
      # Use awk to print products with the category "Women"
      awk -F ',' '$3 == "Women" {printf "| %-10s | %-15s | %-10s | %-11s |\n", $1, $2, $3, $NF}' products.txt
      ;;
    4)  # Display unisex clothing
      clear
      echo "**********************************************" 
      echo "*                                            *"
      echo "*              Unisex clothing               *"
      echo "*                                            *"
      echo "**********************************************"
      printf "| %-10s | %-15s | %-10s | %-10s |\n" "Product ID" "Product Name" "Category" "Price (SAR)"
      printf "|------------|-----------------|------------|-------------|\n"
      # Use awk to print products with the category "Unisex"
      awk -F ',' '$3 == "Unisex" {printf "| %-10s | %-15s | %-10s | %-11s |\n", $1, $2, $3, $NF}' products.txt
      ;;
    *)  # Invalid choice
      echo -e "\e[91mInvalid choice.\e[0m"
      ;;
  esac
}

# Function to add products to the basket
add_to_basket() {
  while true; do
  
    # Prompt the user to enter the ID of the product they want to buy
    read -p "Enter the ID of the product you want to buy: " product_id
    
    # Set the category filter based on user selection
    case $1 in
      2) select_category="Men" ;;    # Men's clothing
      3) select_category="Women" ;;  # Women's clothing
      4) select_category="Unisex" ;; # Unisex clothing
      1) select_category="Men|Women|Unisex" ;; # All categories
    esac
    
    # Retrieve the category of the selected product from products.txt
    product_category=$(awk -F ',' -v id="$product_id" '$1 == id {print $3}' products.txt)
    
    # Check if the product ID exists and matches the selected category
    if grep -q "^$product_id," products.txt && [[ "$product_category" =~ $select_category ]]; then
      # Ask for the size of the product
      while true; do
        echo "Select the size of the product:"
        echo "1) Small"
        echo "2) Medium"
        echo "3) Large"
        echo "4) XLarge"
        read -p "Enter your choice (1-4): " size_choice
        
        # Set the size and corresponding quantity column based on user input
        case $size_choice in
          1) size="S"; qty_column=4; break ;;  # Small
          2) size="M"; qty_column=5; break ;;  # Medium
          3) size="L"; qty_column=6; break ;;  # Large
          4) size="XL"; qty_column=7; break ;; # XLarge
          *) echo -e "\e[91mInvalid choice! Please enter a number between 1 and 4.\e[0m"
             continue ;; # Invalid size choice
        esac
      done
      
      # Use awk to get the available quantity of the selected size with the product id
      qty=$(awk -F ',' -v id="$product_id" -v col="$qty_column" '$1 == id {print $col}' products.txt)
      
      # Check if the selected size is available for the product
      if [[ -n "$qty" && "$qty" -gt 0 ]]; then
        # Reduce the quantity of the selected product in products.txt
        awk -F ',' -v id="$product_id" -v col="$qty_column" '{if ($1 == id) {$col--;} print}' OFS=',' products.txt > temp.txt && mv temp.txt products.txt
        
        # Extract product information from products.txt
        product_name=$(awk -F ',' -v id="$product_id" '$1 == id {print $2}' products.txt)
        category=$(awk -F ',' -v id="$product_id" '$1 == id {print $3}' products.txt)
        price=$(awk -F ',' -v id="$product_id" '$1 == id {print $8}' products.txt)
        
        # Add the product ID, name, category, size, and price to the "Basket" file
        echo "$product_id,$product_name,$category,$size,$price" >> Basket.txt
        echo "Product with ID $product_id (Size: $size) added to Basket."
      else
        echo -e "\e[91mOut of stock for $size size of this product.\e[0m"
      fi
    else
      echo -e "\e[91mInvalid product ID or category! Please enter a valid ID from the specified category.\e[0m"
      continue
    fi

    # Ask the user if they want to buy other products
    while true; do
      read -p "Do you want to buy other products? (y/n): " buy_more
      case $buy_more in
        [Yy]) break ;; # If yes, break the inner loop and continue to add more products
        [Nn]) # If no, check if basket not empty 
          if [[ -f Basket.txt && -s Basket.txt ]]; then
            return
          else
            echo "Your basket is empty."
            read -p "Press Enter to return to the customer menu" enter_key
            customer_menu
          fi ;;
        *) echo -e "\e[91mInvalid input! Please enter 'y' for yes or 'n' for no.\e[0m" ;;
      esac
    done
  done
}

# Function to delete products from the basket
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
        
        # Set the size and corresponding quantity column based on user input
        case $size_choice in
          1) size="S"; qty_column=4; break ;;  # Small
          2) size="M"; qty_column=5; break ;;  # Medium
          3) size="L"; qty_column=6; break ;;  # Large
          4) size="XL"; qty_column=7; break ;; # XLarge
          *) echo -e "\e[91mInvalid choice! Please enter a number between 1 and 4.\e[0m";;
        esac
      done
      
      # Check if the product with the specified size exists in the basket
      if grep -q "^$product_id.*,$size," Basket.txt; then
        # Increase the quantity of the selected product in products.txt
        awk -F ',' -v id="$product_id" -v col="$qty_column" '{if ($1 == id) {$col++;} print}' OFS=',' products.txt > temp.txt && mv temp.txt products.txt
        
        # Remove the product from the basket
        sed -i "/^$product_id.*,$size,/d" Basket.txt 
        echo "Product with ID $product_id (Size: $size) removed from the basket."

        # Check if the basket has more than one line
        if [ "$(wc -l < Basket.txt)" -gt 0 ]; then
          while true; do
            # Ask if the user wants to delete another product
            read -p "Do you want to delete another product? (y/n): " delete_another
            case $delete_another in
              [Yy]) continue 2 ;; # #  If yes, Continue to the outer loop to delete another product
              [Nn]) return ;; # If no, exit the function
              *) echo -e "\e[91mInvalid input! Please enter 'y' for yes or 'n' for no.\e[0m" ;;
            esac
          done
        else
          echo "The basket is now empty!"
          read -p "Press Enter to return to the customer menu" enter_key
          customer_menu
        fi
      else 
        echo -e "\e[91mProduct with ID $product_id and size $size not found in the basket.\e[0m"
      fi
    else
      echo -e "\e[91mProduct ID not found in the basket! Please enter a valid ID.\e[0m"
    fi
  done
}

# Function to display the basket
display_basket() {
  # Check if the basket file exists and is not empty
  if [[ -f Basket.txt && -s Basket.txt ]]; then
  
    # Calculate the total price of the products in the basket
    total_price=$(awk -F ',' '{total+=$NF} END {print total}' Basket.txt)
    
    echo "Your basket contains the following products:"
    # Print table header
    printf "| %-10s | %-15s | %-10s | %-5s | %-10s |\n" "Product ID" "Product Name" "Category" "Size" "Price (SAR)"
    printf "|------------|-----------------|------------|-------|-------------|\n"
    
    # Display each product in the basket
    while IFS=',' read -r id name category size price; do
      printf "| %-10s | %-15s | %-10s | %-5s | %-11s |\n" "$id" "$name" "$category" "$size" "$price"
    done < Basket.txt
    echo "Total Price: $total_price SAR"
  else
    echo "Your basket is empty."
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
      1)  # Confirm the order
        echo "Order confirmed. Thank you for shopping with us!"
        display_basket
        rm Basket.txt
        exit ;;
      2)  # Buy more products
        display_products 1
        add_to_basket 1 ;;
      3)  # Delete a product from the basket
        delete_from_basket ;;
      4)  # Exit the basket options
        echo "Thank you for visiting our online shopping"
        if [ -f Basket.txt ]; then
            rm Basket.txt
        fi
        exit ;;
      *)  # Invalid choice
        echo -e "\e[91mInvalid choice! Please enter a number between 1 and 4.\e[0m"
        sleep 2 ;;
    esac
  done
}

# Function to display the customer menu
customer_menu() {
  while true; do
    clear
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
      1|2|3|4)
        # Display products based on user choice
        display_products "$choice"
        # Add selected products to the basket
        add_to_basket "$choice"
        # Display the basket contents
        display_basket
        read -p "Press Enter to complete your shopping" enter_key
        # Show basket options
        basket_options
        ;;
      5)  # Exit the customer menu
        exit 0
        ;;
      *)  # Invalid choice
        echo -e "\e[91mInvalid choice! Please enter a number between 1 and 5.\e[0m"
        sleep 2 ;;
    esac
  done
}

# Start the script by displaying the customer menu
customer_menu
