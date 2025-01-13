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

### Example output
```bash
====================== Warrantiak =============================
Serial Number  : UPB5ZLKD
Full Type      : Lenovo L27m-30 - Type 66D0
Type Number    : 66D0
Type Name      : Lenovo L27m-30
---------------------------------------------------------------
Warranty Start : 2022-09-20
2022-09-20
Warranty End   : 2025-10-19
2025-10-19
Product        : 66D0KAC2EU
Model          : KAC2EU
===============================================================
```
If there if there is not this type off formatted output, please check your internet connection.