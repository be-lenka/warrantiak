#!/bin/bash

# Check if Serial Number is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <SerialNumber>"
  exit 1
fi

SERIAL_NUMBER="$1"

# Function to fetch type info
get_type_info() {
  local serial_number="$1"

  TYPE_INFO=$(curl -s "https://pcsupport.lenovo.com/us/en/api/v4/mse/getproducts?productId=$serial_number" \
    -H "Accept: application/json")

  # Extract type details
  FULL_TYPE=$(echo "$TYPE_INFO" | grep -o '"Name":"[^"]*"' | sed 's/"Name":"//;s/"//')
  TYPE_NUMBER=$(echo "$FULL_TYPE" | awk -F'Type ' '{print $2}' | awk '{print $1}')
  TYPE_NAME=$(echo "$FULL_TYPE" | awk -F' - ' '{print $1}')

  # Return as a pipe-separated string
  echo "$serial_number|$FULL_TYPE|$TYPE_NUMBER|$TYPE_NAME"
}

# Function to fetch warranty information
get_warranty_info() {
  local serial_number="$1"
  local type_info="$2"

  IFS='|' read -r serial_number full_type type_number type_name <<< "$type_info"

  DATA=$(printf '{"serialNumber":"%s","machineType":"%s","country":"us","language":"en"}' "$serial_number" "$type_number")

  RESPONSE=$(curl -s -X POST "https://pcsupport.lenovo.com/us/en/api/v4/upsell/redport/getIbaseInfo" \
    -H "Content-Type: application/json" \
    -H "Accept: application/json, text/plain, */*" \
    -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:128.0) Gecko/20100101 Firefox/128.0" \
    -d "$DATA")

  WARRANTY_START=$(echo "$RESPONSE" | grep -o '"startDate":"[^"]*"' | sed 's/"startDate":"//;s/"//')
  WARRANTY_END=$(echo "$RESPONSE" | grep -o '"endDate":"[^"]*"' | sed 's/"endDate":"//;s/"//')
  PRODUCT=$(echo "$RESPONSE" | grep -o '"product":"[^"]*"' | sed 's/"product":"//;s/"//')
  MODEL=$(echo "$RESPONSE" | grep -o '"model":"[^"]*"' | sed 's/"model":"//;s/"//')

  # Print results
  echo "SerialNumber: $serial_number"
  echo "FullType: $full_type"
  echo "TypeNumber: $type_number"
  echo "TypeName: $type_name"
  echo "WarrantyStart: $WARRANTY_START"
  echo "WarrantyEnd: $WARRANTY_END"
  echo "Product: $PRODUCT"
  echo "Model: $MODEL"
}

# Fetch Type Info
TYPE_INFO=$(get_type_info "$SERIAL_NUMBER")

# Fetch Warranty Info
get_warranty_info "$SERIAL_NUMBER" "$TYPE_INFO"
