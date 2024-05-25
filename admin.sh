#!/bin/bash

# Initialize product ID counter outside the function
id_counter=9

# Function to add a new product
add_product() {
    # Clear the terminal screen
    clear
    # Print the header for the add product section
    echo "**********************************************"
    echo "*                                            *"
    echo "*                Add Product                 *"
    echo "*                                            *"
    echo "**********************************************"
    
    # Prompt user to enter product details
    echo "Enter product details:"
    
    # Increment product ID counter to generate a unique ID for each product
    id_counter=$((id_counter + 1))
    id=$(printf "%03d" $id_counter)
    
    # Prompt for product name
    read -p "Product Name: " name
    
    # Display product category options
    printf "Product Category:\n1. Men\n2. Women\n3. Unisex\n"
    
    # Loop to validate category choice
    while true; do
        read -p "Enter the number corresponding to the category: " choice
        case $choice in
            1)
                category="Men"
                break
                ;;
            2)
                category="Women"
                break
                ;;
            3)
                category="Unisex"
                break
                ;;
            *)
                # Error message for invalid category choice
                echo -e "\033[31mInvalid choice. Please select a valid category.\033[0m"
                ;;
        esac
    done
    
    # Prompting for Quantity (S) with validation
    while true; do
        read -p "Quantity (S): " quantity_s
        # Validate input to ensure it's a numeric value
        if [[ "$quantity_s" =~ ^[0-9]+$ ]]; then
            break
        else
            echo -e "\033[31mInvalid input. Please enter a numeric value.\033[0m"
        fi
    done

    # Prompting for Quantity (M) with validation
    while true; do
        read -p "Quantity (M): " quantity_m
        # Validate input to ensure it's a numeric value
        if [[ "$quantity_m" =~ ^[0-9]+$ ]]; then
            break
        else
            echo -e "\033[31mInvalid input. Please enter a numeric value.\033[0m"
        fi
    done

    # Prompting for Quantity (L) with validation
    while true; do
        read -p "Quantity (L): " quantity_l
        # Validate input to ensure it's a numeric value
        if [[ "$quantity_l" =~ ^[0-9]+$ ]]; then
            break
        else
            echo -e "\033[31mInvalid input. Please enter a numeric value.\033[0m"
        fi
    done

    # Prompting for Quantity (XL) with validation
    while true; do
        read -p "Quantity (XL): " quantity_xl
        # Validate input to ensure it's a numeric value
        if [[ "$quantity_xl" =~ ^[0-9]+$ ]]; then
            break
        else
            echo -e "\033[31mInvalid input. Please enter a numeric value.\033[0m"
        fi
    done

    # Prompting for Price with validation
    while true; do
        read -p "Price (SAR): " price
        # Validate input to ensure it's a numeric value
        if [[ "$price" =~ ^[0-9]+$ ]]; then
            break
        else
            echo -e "\033[31mInvalid input. Please enter a numeric value.\033[0m"
        fi
    done
    
    # Concatenate all product details and append to products.txt file
    echo "$id,$name,$category,$quantity_s,$quantity_m,$quantity_l,$quantity_xl,$price" >> products.txt
    
    # Confirmation message for successful addition
    echo "Product added successfully."
    
    # Pause and prompt user to press Enter to return to the menu
    read -p "Press Enter to return to menu" enter_key
}


# Function to delete a product
delete_product() {
    clear
    echo "**********************************************"
    echo "*                                            *"
    echo "*              Delete Product                *"
    echo "*                                            *"
    echo "**********************************************"
    
    read -p "Enter product ID to delete: " product_id
    
    # Check if the product exists
    if grep -q "$product_id" products.txt; then
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
        
        while true; do
            # Ask for confirmation
            read -p "Are you sure you want to delete this product? (y/n): " confirm
            case $confirm in
                [Yy])
                    # Delete product from the file using sed
                    sed -i "/$product_id/d" products.txt
                    echo "Product $product_id deleted successfully."
                    break
                    ;;
                [Nn])
                    echo "Deletion canceled."
                    break
                    ;;
                *)
                    echo -e "\033[31mInvalid input! Please enter 'y' for yes or 'n' for no.\033[0m"
                    ;;
            esac
        done
    else
        echo -e "\033[31mProduct $product_id not found.\033[0m"
    fi
    read -p "Press Enter to return to menu" enter_key
}

# Function to display products in the warehouse
display_products() {
    clear
    echo "**********************************************"
    echo "*                                            *"
    echo "*        Products in the Warehouse           *"
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

# Main menu loop
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
        *)
            echo -e "\033[31mInvalid choice. Please try again.\033[0m"
            sleep 2 ;; # Display error message for invalid choices
    esac
done
