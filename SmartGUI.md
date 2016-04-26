# SmartGUI #

To bring more fun in developing synthesizer, effect devices and stuff it would be nice to have a powerful tool that helps creating a graphical user interface within a few clicks. As you know GUI programming is a pain in the ass and takes often much more time then the actual application logic.

## Idea ##

We will create a grid based UI editor with certain UI elements (listed below) plus a simple framework to connect the custom UI with the parameters (`de.popforge.parameter`) of your objects (synth, effect, ...). Each element can only occupy a certain rectangular area in the tilemap. Overlapping is not allowed.

Imagine:
```
gui= new SmartGUI();
gui.loadLayout( 'mysynth.xml' );
gui.connect( 'volume/attack', synth.parameterVolumeAttack );
[...]
addChild( gui );
//-> ready
```

# Elements #

We only think in terms of devices, so there is no need for input fields or flying windows. This makes it a lot of easier to keep it clean and simple.

  * Input Elements
    1. Trigger Button
    1. SwitchButton (MappingBoolean)
    1. RadioGroup (MappingValues)
    1. Slider (MappingBoolean,MappingNumber,MappingValues) [horizontal/vertical]
    1. Knobs (Mapping as Sliders)
  * Output Elements
    1. Label
    1. Digit Display
    1. Oscilloscope

More to come soon ...