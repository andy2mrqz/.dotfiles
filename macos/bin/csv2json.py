#!/usr/bin/env -S rtx x python@3.11 -- python3

import csv
import json
import sys

# Function to convert CSV to JSON


def csv_to_json(csv_file_path, json_file_path):
    # Read the CSV and add data to a dictionary
    data = []
    with open(csv_file_path, mode='r', encoding='utf-8') as csv_file:
        csv_reader = csv.DictReader(csv_file)
        for row in csv_reader:
            data.append(row)

    # Write the data to a JSON file
    with open(json_file_path, mode='w', encoding='utf-8') as json_file:
        json_file.write(json.dumps(data, indent=4))


if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: csv2json.py input.csv output.json")
        sys.exit(1)

    csv_file_path = sys.argv[1]
    json_file_path = sys.argv[2]

    # Call the function to convert CSV to JSON
    csv_to_json(csv_file_path, json_file_path)

    print(
        f"""
        CSV data from '{csv_file_path}' has been successfully converted to
        JSON and saved to '{json_file_path}'
        """)
