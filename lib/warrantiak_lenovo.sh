#!/usr/bin/env bash

LENOVO_API_BASE_URL="https://pcsupport.lenovo.com/us/en/api/v4"
HP_API_BASE_URL=""
APPLE_API_BASE_URL=""

_lenovo_json_output() {
    echo "{"
    echo "  \"SerialNumber\": \"$serial_number\","
    echo "  \"FullType\": \"$full_type\","
    echo "  \"TypeNumber\": \"$type_number\","
    echo "  \"TypeName\": \"$type_name\","
    echo "  \"WarrantyStart\": \"$WARRANTY_START\","
    echo "  \"WarrantyEnd\": \"$WARRANTY_END\","
    echo "  \"Product\": \"$PRODUCT\","
    echo "  \"Model\": \"$MODEL\""
    echo "}"
}

_lenovo_get_type_info() {
  local serial_number="$1"

  TYPE_INFO=$(curl -s "$LENOVO_API_BASE_URL/mse/getproducts?productId=$serial_number" \
    -H "Accept: application/json")

  # Extract the "Name" field
  FULL_TYPE=$(echo "$TYPE_INFO" | grep -o '"Name":"[^"]*"' | sed 's/"Name":"//;s/"//')

  # Split to extract TypeNumber and TypeName
  TYPE_NUMBER=$(echo "$FULL_TYPE" | awk -F'Type ' '{print $2}' | awk '{print $1}')
  TYPE_NAME=$(echo "$FULL_TYPE" | awk -F' - ' '{print $1}')

  # Return as a pipe-separated string
  echo "$serial_number|$FULL_TYPE|$TYPE_NUMBER|$TYPE_NAME"
}

_lenovo_get_warranty_info() {
  local serial_number="$1"
  local type_info="$2"
  local json_output="$3"

  # Parse the pipe-separated values
  IFS='|' read -r serial_number full_type type_number type_name <<< "$type_info"

  # Construct JSON payload
  DATA=$(printf '{"serialNumber":"%s","machineType":"%s","country":"us","language":"en"}' "$serial_number" "$type_number")

  RESPONSE=$(curl -s -X POST "$LENOVO_API_BASE_URL/upsell/redport/getIbaseInfo" \
    -H "Content-Type: application/json" \
    -H "Accept: application/json, text/plain, */*" \
    -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:128.0) Gecko/20100101 Firefox/128.0" \
    -d "$DATA")

  WARRANTY_START=$(echo "$RESPONSE" | grep -o '"startDate":"[^"]*"' | sed 's/"startDate":"//;s/"//')
  WARRANTY_END=$(echo "$RESPONSE" | grep -o '"endDate":"[^"]*"' | sed 's/"endDate":"//;s/"//')
  PRODUCT=$(echo "$RESPONSE" | grep -o '"product":"[^"]*"' | sed 's/"product":"//;s/"//')
  MODEL=$(echo "$RESPONSE" | grep -o '"model":"[^"]*"' | sed 's/"model":"//;s/"//')

  # Output the JSON
  [[ "$json_output" == "true" ]] && { _lenovo_json_output; return; }

  # Output the human-readable format
  echo ""
  echo "=================== LENOVO Warranty Info ======================="
  echo "Serial Number  : $serial_number"
  echo "Full Type      : $full_type"
  echo "Type Number    : $type_number"
  echo "Type Name      : $type_name"
  echo "---------------------------------------------------------------"
  echo "Warranty Start : $WARRANTY_START"
  echo "Warranty End   : $WARRANTY_END"
  echo "Product        : $PRODUCT"
  echo "Model          : $MODEL"
  echo "==============================================================="

}
