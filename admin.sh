#!/bin/bash

# Initialize product ID counter outside the function
id_counter=8

# Function to add a new product
add_product() {
    clear
    echo "**********************************************"
    echo "*                                            *"
    echo "*                Add Product                 *"
    echo "*                                            *"
    echo "**********************************************"
    
    echo "Enter product details:"
    
    # Increment product ID counter
    id_counter=$((id_counter + 1))
    id=$(printf "%03d" $id_counter)
        	
    read -p "Product Name: " name
    
    while true; do
    
    	printf "Product Category:\n1. Men\n2. Women\n3. Unisex\nEnter the number corresponding to the category: "
    	read choice
    	
    	# Validate category choice
    	if [ $choice -eq 1 ] 2>/dev/null;then
    		category="Men"
    		break
    	elif [ $choice -eq 2 ] 2>/dev/null;then
    		category="Women"
    		break
    	elif [ $choice -eq 3 ] 2>/dev/null;then
    		category="Unisex"
    		break
    	else
    		echo "Invalid choice. Please select a valid category."
    	fi
    done
    
    read -p "Quantity (S): " quantity_s
    read -p "Quantity (M): " quantity_m
    read -p "Quantity (L): " quantity_l
    read -p "Quantity (XL): " quantity_xl
    read -p "Price (SAR): " price
    
    # Concatenate details with commas and add it to product.txt file
    echo "$id,$name,$category,$quantity_s,$quantity_m,$quantity_l,$quantity_xl,$price" >> products.txt
    echo "Product added successfully."
    read -p "Press Enter to return to menu" enter_key
    
}

# Function to delete a product
delete_product(){
    clear
    echo "**********************************************"
    echo "*                                            *"
    echo "*              Delete Product                *"
    echo "*                                            *"
    echo "**********************************************"
    
    read -p "Enter product ID to delete: " product_id
    # Check if the product exists
    if [ $(grep -c "$product_id" products.txt) -eq 1 ]; then
    
    	# Display product details
        echo "====Product Details===="
        product_details=$(grep "$product_id" products.txt)
        
        echo "Product Name: $(echo "$product_details" | cut -d ',' -f 2)"
        echo "Category: $(echo "$product_details" | cut -d ',' -f 3)"
        echo "Quantity (S): $(echo "$product_details" | cut -d ',' -f 4)"
        echo "Quantity (M): $(echo "$product_details" | cut -d ',' -f 5)"
        echo "Quantity (L): $(echo "$product_details" | cut -d ',' -f 6)"
        echo "Quantity (XL): $(echo "$product_details" | cut -d ',' -f 7)"
        echo "Price (SAR): $(echo "$product_details" | cut -d ',' -f 8)"
        
        # Ask for confirmation
        read -p "Are you sure you want to delete this product? (y/n): " confirm
        if [ "$confirm" = "y" ]; then
            # Delete product from the file using sed
            sed -i "/$product_id/d" products.txt
            echo "Product $product_id deleted successfully."
        else
            echo "Deletion canceled."
        fi
    else
        echo "Product $product_id not found."
    fi
    read -p "Press Enter to return to menu" enter_key
    
}
  
# Function to display products in the warehouse
display_products() {
    clear
    echo "**********************************************"
    echo "*                                            *"
    echo "*        Products in the warehouse           *"
    echo "*                                            *"
    echo "**********************************************"
    
    # Print table header
    printf "| %-10s | %-15s | %-7s | %-12s | %-12s | %-12s | %-12s | %-10s |\n" "Product ID" "Product Name" "Category" "Quantity (S)" "Quantity (M)" "Quantity (L)" "Quantity (XL)" "Price (SAR)"
    printf "|------------|-----------------|----------|--------------|--------------|--------------|---------------|-------------|\n"

    # Read data from file and print data rows
    while IFS=',' read -r id name category qty_s qty_m qty_l qty_xl price; do
        printf "| %-10s | %-15s | %-8s | %-12s | %-12s | %-12s | %-13s | %-11s |\n" "$id" "$name" "$category" "$qty_s" "$qty_m" "$qty_l" "$qty_xl" "$price"
    done < products.txt

    read -p "Press Enter to return to menu" enter_key
}      

# Main menu
while true; do

    clear
    echo "**********************************************"
    echo "*                                            *"
    echo "*                 Admin Menu                 *"
    echo "*                                            *"
    echo "**********************************************"
    
    echo "1. Add Product"
    echo "2. Delete Product"
    echo "3. Display Available Products"
    echo "4. Exit"
    read -p "Enter your choice: " choice

    case $choice in
        1) add_product ;; # Call add_product function
        2) delete_product ;; # Call delete_product function
        3) display_products ;; # Call display_products function
        4) exit ;; # Exit the script
        *) echo "Invalid choice. Please try again." ;; # Display error message for invalid choices
    esac
done
