#!/bin/bash
# Function to display products based on category 
display_products (){
  case $1 in
      1) echo "**********************************************"
         echo "*                                            *"
         echo "*               All products                 *"
         echo "*                                            *"
         echo "**********************************************"  
         awk -F ',' -v OFS=', ' '$3 == "Men" || $3 == "Women" {print $1, $2, $3, $NF}' products.txt
        
        ;; 
     2) echo "**********************************************"  
        echo "*                                            *"
        echo "*                Men's clothing              *"
        echo "*                                            *"
        echo "**********************************************"   
       awk -F ',' -v OFS=', ' '$3 == "Men" {print $1, $2, $3, $NF}' products.txt
      
       ;; 
      
    3) echo "**********************************************"  
       echo "*                                            *"
       echo "*                Women's clothing            *"
       echo "*                                            *"
       echo "**********************************************"  
     awk -F ',' -v OFS=', ' '$3 == "Women" {print $1, $2, $3, $NF}' products.txt
       ;;
       
    4) echo "**********************************************"  
       echo "*                                            *"
       echo "*                Unisex clothing             *"
       echo "*                                            *"
       echo "**********************************************"  
       awk -F ',' -v OFS=', ' '$3 == "Unisex" {print $1, $2, $3, $NF}' products.txt
       ;;
       
    *) echo "Invalid choice!"  
       ;;
  esac
}
add_to_basket() {
  while true; do
    read -p "Enter the ID of the product you want to buy: " product_id

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
      
      # Extract product information from products.txt
      product_name=$(awk -F ',' -v id="$product_id" '$1 == id {print $2}' products.txt)
      category=$(awk -F ',' -v id="$product_id" '$1 == id {print $3}' products.txt)
      price=$(awk -F ',' -v id="$product_id" '$1 == id {print $8}' products.txt)
      
      # Add the product ID, name, category, size, and price to the "Basket" file
      printf "%-10s ,%-10s ,%-10s,%-10s,%-10s\n" "$product_id" "$product_name" "$category" "$size" "$price" >> Basket.txt
      echo "Product with ID $product_id (Size: $size) added to Basket."
      
      while true; do
        read -p "Do you want to buy more products? (y/n): " buy_more
        case $buy_more in
          [Yy]) break ;;
          [Nn]) return ;;
          *) echo "Invalid input! Please enter 'y' for yes or 'n' for no." ;;
        esac
      done
    else
      echo "Invalid product ID! Please enter a valid ID."
    fi
  done
}

display_basket(){
  
  # Calculate total price using awk
  total_price=$(awk -F ',' '{total+=$NF} END {print total}' Basket.txt)
  
  # Check if total_price is a number
  if [[ $total_price =~ ^[0-9]+([.][0-9]+)?$ ]]; then
  echo " "
  echo "Your basket contains the following products:"
  cat Basket.txt
  echo "Total Price: $total_price SAR"
  
  else
   echo "****Thank you for visiting our online shopping****"
   
  fi
}


delete_from_basket() {
  while true; do
    read -p "Enter the ID of the product you want to remove: " product_id

    # Check if the product ID exists in the basket
    if grep -q "^$product_id" Basket.txt; then
      while true; do
        echo "Select the size of the product to remove:"
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

     if awk "/^$product_id/ && /$size/" Basket.txt >/dev/null; then
     
       sed -i "/^$product_id/ { /$size/ d }" Basket.txt 
        echo "Product with ID $product_id (Size: $size) removed from the basket."
        
        while true; do
          read -p "Do you want to delete another product? (y/n): " delete_another
          case $delete_another in
            [Yy]) continue 2 ;;
            [Nn]) return ;;
            *) echo "Invalid input! Please enter 'y' for yes or 'n' for no." ;;
          esac
        done
      else 
        echo "Product with ID $product_id and size $size not found in the basket!"
      fi
    else
      echo "Product ID not found in the basket! Please enter a valid ID."
    fi
  done
}
# Function for basket options
basket_options() {
  while true; do
    echo " "
    echo "**********************************************"  
    echo "*              Basket Options                *"
    echo "*                                            *"  
    echo "**********************************************"  
    echo "  1) Confirm order"
    echo "  2) Buy more"
    echo "  3) Delete product"
    echo "  4) Exit"

    # Read basket option with validation loop
    while true; do
      read -p "Enter your choice: " basket_option

      # Check if basket option is a valid number between 1 and 4 (inclusive)
      if [[ "$basket_option" =~ ^[1-4]$ ]]; then
        break;
      else
        echo "Invalid choice! Please enter a number between 1 and 4."
      fi
    done

    case $basket_option in
      1) 
        echo "Order confirmed. Thank you for shopping with us!"
        display_basket
        exit 0
        ;;
      2) 
        add_to_basket
        ;;
      3) 
        delete_from_basket
        ;;
      4) 
        echo "Exiting."
        rm Basket.txt
        exit 0
        ;;
    esac
  done
}
 printf "%-10s ,%-10s ,%-10s ,%-10s,%-10s\n" "Product ID" "Product Name" "Category" "Size" "Price(SAR)" > Basket.txt

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
    add_to_basket
    fi
 
  display_basket
  basket_options
done
  
  
  
  
  
  
 
