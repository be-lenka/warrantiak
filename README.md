# Warrantiak: Device Warranty Checker

**Warrantiak** is a shell script to check the warranty status of devices using their serial numbers. Currently, it supports Lenovo devices, with plans to add support for HP and Apple in the future.

---

## Features

- Fetch device type and warranty information from Lenovo's API.
- Display warranty start and end dates, product type, and model.
- Simple and easy-to-use command-line interface.

---

## Requirements

- `curl`: Used to send API requests.
- A working internet connection.

---

## Usage

### Running the Script
```bash
./warrantiak.sh <SerialNumber>
```

