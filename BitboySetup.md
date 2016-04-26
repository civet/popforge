# Introduction #

This manual will guide you through the process of setting up the Bitboy application. In this example we will use FlexBuilder 3 but theoretically all of our projects can be compiled using the command line.

## Requirements ##

We assume you went through the LibrarySetup and have the following already set up:

  * A working PopforgeLibrary project
  * Subversive and the Popforge repositoy (you created it while setting up the library)

# Creating the Bitboy project #

  * Go to `File` > `New` and select `ActionScript Project`
  * Name the project "Bitboy"
  * Click Next
  * Enter "src" as the `Main source folder`
  * Enter "BitboyApp.as" as the `Main application file`
  * Switch to the `Library path` tab
  * Click `Add Project...`
  * Select "PopforgeLibrary" and click `Ok`
  * Click `Finish`

# Sharing the project #

By following these instructions your library project will be connected to our code repository at Google Code.

  * Locate your Bitboy project in the Navigator
  * Right click and select `Team` > `Share Project...`
  * Choose `SVN` as the repository type
  * Click `Next`
  * Select `Use existing repository location`
  * Select the repository that points to http://popforge.googlecode.com/svn/
  * Click `Next`
  * Select `Use specified name` in the `Name on Repository` group
  * Enter "flash/Bitboy" in the textbox
  * Click `Next`
  * Uncheck `Launch the Commit Dialog for the shared resources`
  * Click `Finish`
  * Click `Yes` if a warning message pops up

# Importing the assets #

The 8bitboy comes with its own assets library that is stored in the repository and you have to include manually.

  * Locate your Bitboy project in the Navigator
  * Right click and select `Properties`
  * Go to `ActionScript Build Path`
  * Switch to the `Library path` tab
  * Click `Add SWC...`
  * Enter "assets/assets.swc"
  * Click `Ok`

# Creating a config #

8bitboy needs a configuration XML. We provide a basic XML template. You have create a local copy of that XML in order to run 8bitboy.

  * Locate your Bitboy project in the Navigator
  * Open the "bin" directory
  * Create a copy of "init.8bitboy.xml"
  * Name the copy "8bitboy.xml"

You are able to run and compile the 8bitboy now. But you might want to have a look at suggested settings that we have for you.

# Suggested configuration #

These are just some settings we use during development of the 8bitboy.

  * Locate your PopforgeLibrary project in the Navigator
  * Right click and select `Properties`
  * Go to `ActionScript Compiler`
  * Uncheck `Copy non-embedded files to output directory`
  * Enter "-optimize" in `Additional compiler arguments`
  * Uncheck `Generate HTML wrapper file`
  * Click `Ok`
  * Ignore the warning

If you have some garbage in your "bin" folder just remove it. Now you have a nice and clean working environment.