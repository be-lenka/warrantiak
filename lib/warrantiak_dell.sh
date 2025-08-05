#!/bin/bash

function _dell_get_warranty_info() {
    local service_tag="$1"
    local output_json="$2"

    local url="https://www.dell.com/support/home/en-us/product-support/servicetag/$service_tag/warranty"
    local html=$(curl -fsSL "$url")

    local warranty=$(echo "$html" | grep -oP 'Warranty Expiration.*?\K\d{4}-\d{2}-\d{2}' | head -n1)
    local model=$(echo "$html" | grep -oP 'Model.*?\K([A-Za-z0-9 -]+)' | head -n1)

    if [[ "$output_json" == "true" ]]; then
        echo "{\"service_tag\":\"$service_tag\",\"model\":\"$model\",\"warranty_expiration\":\"$warranty\"}"
    else
        echo "Service Tag: $service_tag"
        echo "Model: $model"
        echo "Warranty Expiration: $warranty"
    fi
}