#!/usr/bin/env python3
"""
Build script to generate a JSON file listing all STL files in built_stls directory.
Run this script whenever STL files are added/removed/changed.
(This comment exists to test workflow triggers)
"""

import json
import os
from pathlib import Path
from collections import defaultdict

def extract_category_and_type(filename):
    """
    Extract category and type from filename like 'output_aggregate_allways.stl'
    Returns: (category, type) like ('aggregate', 'allways')
    """
    # Remove 'output_' prefix and '.stl' suffix
    name = filename.replace('output_', '').replace('.stl', '')

    # Split on last underscore to separate category from type
    parts = name.rsplit('_', 1)
    if len(parts) == 2:
        return parts[0], parts[1]
    return name, 'unknown'

def build_file_list():
    """Scan built_stls directory and generate organized file list."""
    stl_dir = Path(__file__).parent / 'built_stls'

    if not stl_dir.exists():
        print(f"Error: Directory {stl_dir} does not exist")
        return

    # Get all .stl files
    stl_files = sorted(stl_dir.glob('*.stl'))

    # Organize by category
    categories = defaultdict(list)

    for stl_file in stl_files:
        category, type_name = extract_category_and_type(stl_file.name)
        categories[category].append({
            'filename': stl_file.name,
            'path': f'../built_stls/{stl_file.name}',
            'type': type_name,
            'display_name': type_name.capitalize()
        })

    # Convert to sorted list of categories
    result = []
    for category in sorted(categories.keys()):
        result.append({
            'category': category,
            'display_name': category.capitalize(),
            'files': sorted(categories[category], key=lambda x: x['type'])
        })

    # Write to JSON file
    output_file = Path(__file__).parent / 'stl_files.json'
    with open(output_file, 'w') as f:
        json.dump(result, f, indent=2)

    print(f"Generated {output_file}")
    print(f"Found {len(stl_files)} STL files in {len(result)} categories")

if __name__ == '__main__':
    build_file_list()
