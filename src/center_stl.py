import sys
# pip install numpy-stl
from stl import mesh
import numpy as np

"""
Centers the X and Y coordinates of a 3D STL model to the origin (0,0) while keeping the Z coordinate unchanged.

(openscad can't center imported STLs itself, so it's necessary to preprocess them with this script)
"""


def center_stl(input_file, output_file):
    # Load the STL file
    your_mesh = mesh.Mesh.from_file(input_file)

    # Calculate the center of the bounding box (min + max) / 2
    min_point = your_mesh.vectors.min(axis=(0, 1))
    max_point = your_mesh.vectors.max(axis=(0, 1))
    center = (min_point + max_point) / 2

    # Set Z component of the center to 0 so we don't shift vertically
    center[2] = 0

    # Shift vectors by subtracting the center (only affects X and Y now)
    your_mesh.vectors -= center

    # Save the new STL
    your_mesh.save(output_file)
    print(f"Centered X/Y for {input_file} and saved to {output_file}")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python center_stl.py <input.stl>")
    else:
        center_stl(sys.argv[1], sys.argv[1].replace('.stl', '_centered.stl'))