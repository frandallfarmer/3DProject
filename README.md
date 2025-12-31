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

## License

Open source - feel free to use, modify, and share.
