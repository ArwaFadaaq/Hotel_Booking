<<<<<<< HEAD
hi arwa
=======
#!/bin/bash

# Initialize product ID counter outside the function
id_counter=5

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
    
    	printf "Product Category:\n1. Men\n2. Women\nEnter the number corresponding to the category: "
    	read choice
    	
    	# Validate category choice
    	if [ $choice -eq 1 ] 2>/dev/null;then
    		category="Men"
    		break
    	elif [ $choice -eq 2 ] 2>/dev/null;then
    		category="Women"
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

>>>>>>> 9a09f61ca28f11db8b49ebd31409699045a81c73
