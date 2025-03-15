# Level Config Manager

Provides a bunch of tools to help Level Designers do incredible things with **Unreal Tournament 2004**. 

Last Updated @ 09/06/2010 (V3)

## Usage

1. Install by copying the `LevelConfigManagerV#.u` file to your `/UT2004Root/System/` directory.
2. Then, in `UnrealEd` (down left) input the exec command `obj load file=LevelConfigManagerV#.u` (and replace the # sign with the appropriate version number)
3. Open the "Actor Class Browser" and navigate the tree to : Actor -> Info -> Mutator -> LevelConfigActor (Re-tick the checkbox "Placeable classes only?" if it did not show up), then place the actor anywhere in your map.
4. Modify the actor properties to enhance the gameplay to your liking.
5. Explore many other actors, see below.

Documentation can be found at http://wiki.beyondunreal.com/User:Eliot/LevelConfigManager (Slightly outdated)

## Build

**Level Designers / Mappers SHOULD NOT perform this step**

Clone the repository to your `/UT2004Root/`, and run `Make.bat`, it should be located at `/UT2004Root/LevelConfigManager/Make.bat` (i.e. without the version postfix)

This will generate a `LevelConfigManagerVX.u` file, and the file should have been copied to both the local `/System/` directory as well as your `/UT2004Root/System/` directory.

**Before publishing, make sure to change the `version` variable in `Make.bat` to the appropriate version, and make sure not to use `LevelConfigManagerVX.u' in production.**

## Credits

* [Marco](https://github.com/Marco888) a.k.a **.:..:** for helping out, contributed some code in its early development, and some code snippets are attributed to him.
* "Billa" for testing and providing feedback throughout the development.
