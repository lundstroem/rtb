# RTB Project

## Overview
The idea behind the RTB (Real Time Buffer) project is to provide a really simple way of 
drawing directly to the screen, and to write to the audio output buffer in real time using Swift.

## Workflow
Add new files which extend RTB, and change the instance returned by RTB.instance(). 
When aiming to create a new project for App Store release etc, it's advisable to copy the whole project to a new repo to avoid sharing code with other projects. Set supported Device Orientation, bundleID etc in the new project.

## Specs
- Main target platform is iOS, but macOS is supported for development purposes.
- Total screen size is hardcoded to 256x256, which is clipped to 144x256 for portrait and 256x144 on landscape to get a 16:9 ratio on iPhone screens.
- Audio format is Int16 interleaved.

## Versioning
As it's fairly early in the development process, versioning has not been introduced yet and breaking changes can be introduced!

## TODO
- Util to generate icons sizes and names from 16x16 icon.
- Wavechange in Oscillator
- More audio effects.