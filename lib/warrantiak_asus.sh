#!/bin/bash

function _asus_get_warranty_info() {
    local serial="$1"
    local output_json="$2"

    local url="https://www.asus.com/global/support/warranty-status-inquiry"

    local response=$(curl -fsSL "$url")
    local csrf=$(echo "$response" | grep -oP 'name="_csrf" value="\K[^"]+')
    local cookie=$(echo "$response" | grep -oP 'Set-Cookie: \K[^;]+' || true)

    local postdata="sn=$serial&_csrf=$csrf"
    local warranty_response=$(curl -fsSL -c cookie.txt -b cookie.txt \
        -H "Content-Type: application/x-www-form-urlencoded" \
        -d "$postdata" \
        "$url")

    local model=$(echo "$warranty_response" | grep -oP 'Model.*?<span.*?>\K[^<]+' | head -n1)
    local warranty=$(echo "$warranty_response" | grep -oP 'Warranty Expiration.*?<span.*?>\K[^<]+' | head -n1)

    if [[ "$output_json" == "true" ]]; then
        echo "{\"serial\":\"$serial\",\"model\":\"$model\",\"warranty_expiration\":\"$warranty\"}"
    else
        echo "Serial: $serial"
        echo "Model: $model"
        echo "Warranty Expiration: $warranty"
    fi
}
