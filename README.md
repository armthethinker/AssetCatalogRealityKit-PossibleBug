# AssetCatalogRealityKit-PossibleBug

This repo is an example of a possible bug in RealityKit and Xcode asset catalogs referenced in this forum question: https://developer.apple.com/forums/thread/700144.

## Notes
The app displays a simple `.nonAR` RealityKit scene with a PBR material. One button loads this material from a folder included in the app bundle. The other button loads the same material from an asset catalog. Loading from an asset catalog ruins the look of the material ... or I've applied the wrong settings somewhere 🤷‍♂️.

After some experimentation, I _think_ the visual error is coming from how the asset catalog handles the normal map. My console also threw this error when loading the normal data from the asset catalog.

```
ReadPhotoshopImageResource:284: Corrupt 8BIM data. Reported 8BIM length (38 bytes) exceeds actual length (37 bytes).
```

I thought maybe this was something to do with how the original texture was created. I created an arbitrary normal map in Blender, but that too gave the same error. (That texture can be found in the asset catalog.)

## Credits
- HDRI from [Poly Haven](https://polyhaven.com/a/peppermint_powerplant).
- Wood texture from [Poly Haven](https://polyhaven.com/a/wood_table_001).
