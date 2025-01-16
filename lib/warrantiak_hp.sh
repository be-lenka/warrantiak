#!/usr/bin/env bash

_hp_json_output() {
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

_hp_get_type_info() {
  local serial_number="$1"

  TYPE_INFO=$(curl -s "https://support.hp.com/wcc-services/searchresult/sk-en?q=$serial_number&context=pdp&authState=anonymous&template=WarrantyLanding" \
    -H "Accept: application/json, text/plain, */*" \
    -H "Accept-Encoding: gzip, deflate, br" \
    -H "Accept-Language: en-GB,en;q=0.9" \
    -H "Referer: https://support.hp.com/sk-en/check-warranty" \
    -H "Sec-Fetch-Dest: empty" \
    -H "Sec-Fetch-Mode: cors" \
    -H "Sec-Fetch-Site: same-origin" \
    -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.2 Safari/605.1.15" \
    --compressed)

  echo "$TYPE_INFO"
}

_hp_get_warranty_info() {
  local serial_number="$1"
  local product_number="$2"
  local json_output="$3"

  # Construct the JSON payload
  local payload=$(cat <<EOF
{
    "productNumber": "$product_number",
    "serialNumber": "$serial_number",
    "countryCode": "US",
    "authState": "anonymous",
    "languageCode": "en"
}
EOF
)

  # Make the POST request
  local response=$(curl -s -X POST "https://support.hp.com/wcc-services/profile/devices/warranty/specs?authState=anonymous&template=checkWarranty" \
    -H "Content-Type: application/json" \
    -H "Accept: application/json, text/plain, */*" \
    -H "Accept-Encoding: gzip, deflate, br" \
    -H "Accept-Language: en-GB,en;q=0.9" \
    -H "Referer: https://support.hp.com/sk-en/warrantyresult" \
    -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.2 Safari/605.1.15" \
    --compressed \
    -d "$payload")

  # Check if the response contains valid data
  if echo "$response" | grep -q "\"status\":\"OK\""; then
    # Extract fields using grep, sed, and awk
    local warranty_start=$(echo "$response" | grep -o '"warrantyStartDate":"[^"]*"' | sed 's/"warrantyStartDate":"//;s/"//')
    local warranty_end=$(echo "$response" | grep -o '"warrantyEndDate":"[^"]*"' | sed 's/"warrantyEndDate":"//;s/"//')
    local status=$(echo "$response" | grep -o '"status":"[^"]*"' | sed 's/"status":"//;s/"//')
    local product_name=$(echo "$response" | grep -o '"productName":"[^"]*"' | sed 's/"productName":"//;s/"//')

    # Output the JSON
    [[ "$json_output" == "true" ]] && { _lenovo_json_output; return; }

    # Output the human-readable format
    echo ""
    echo "====================== HP Warranty Info ======================="
    echo "Product Name    : $product_name"
    echo "Serial Number   : $serial_number"
    echo "Product Number  : $product_number"
    echo "Warranty Start  : $warranty_start"
    echo "Warranty End    : $warranty_end"
    echo "Warranty Status : $status"
    echo "==============================================================="
  else
    echo "Failed to retrieve warranty information. Response:"
    echo "$response"
  fi
}

