# D&D Terrain Pillar Connector

3D printable pillar connector for tabletop RPG paper terrain systems.

## Description

This pillar connector is designed to work with paper cardstock dungeon walls. The connector features slots on all four sides that accept paper wall tabs, allowing you to build modular dungeon interiors and building layouts.

## Specifications

- **Height:** 2 inches (50.8mm)
- **Cross-section:** 2/3" × 2/3" square (16.93mm)
- **Slots:** Four slots (one per face), centered, running 1" down from top
- **Construction:** Hollow with 2mm walls to save filament
- **File format:** STL for 3D printing

## Files

- `pillar_connector.scad` - OpenSCAD source file (parametric, editable)
- `pillar_connector.stl` - Ready-to-print STL file

## Printing

Standard PLA settings should work fine. The model is designed for FDM/FFF printers with typical 0.4mm nozzles.

 * Required:
  * "Detect thin walls" or "Wall generator: arachne"
 * Optional:
  * Nominal layer height: <= 0.20 mm
  * "Variable Layer Height"

Use "Detect thin walls" ensures your slicer doesn't skip the "paper-thin" segments that fit the wall slots.  Keeping these thin slots allows compatibilty with preexisting paper wall designs.

## Customization

The OpenSCAD file is parametric. Edit the parameters at the top of `pillar_connector.scad` to adjust:
- Pillar height
- Face width
- Slot dimensions
- Wall thickness

Regenerate the STL with:
```bash
openscad -o pillar_connector.stl pillar_connector.scad
```

## STL Viewer

This repository includes a web-based STL viewer for previewing all models. The viewer features:
- Split-screen interface with file list and 3D preview
- White background with flat-shaded models and black edge outlines
- Interactive rotation and zoom controls
- Automatic file list generation

### Viewing Models

**Online:** Visit the GitHub Pages site (once deployed) to view all models in your browser.

**Locally:**
```bash
python3 -m http.server 8000
```
Then open http://localhost:8000 in your browser.

### Updating the File List

The file list is automatically generated from the `/built_stls` directory:

**Manual update:**
```bash
python3 build_file_list.py
```

**Automatic update:** When you push STL files to the `built_stls/` directory, a GitHub Action automatically:
1. Runs `build_file_list.py` to regenerate `stl_files.json`
2. Commits the updated file list
3. Deploys to GitHub Pages

You can also manually trigger the workflow from the GitHub Actions tab.

### GitHub Pages Setup

To enable GitHub Pages deployment:
1. Go to repository Settings → Pages
2. Under "Build and deployment", select "GitHub Actions" as the source
3. Push changes to trigger the deployment

The site will be available at `https://yourusername.github.io/repository-name/`

## License

CC SA-BY-4.0
