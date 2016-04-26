# Introduction #

This manual will guide you through the process of setting up the Popforge library project. In this example we will use FlexBuilder 3 but theoretically all of our projects can be compiled using the command line.

## Requirements ##
  * FlexBuilder 2 or later
  * [Subversive](http://www.polarion.org/index.php?page=download&project=subversive)

If you do not have Subversive installed make sure to look at the [installation instructions](http://www.polarion.org/projects/subversive/download/Installation_Instructions.pdf).

# Creating the Popforge library project #

Follow these steps to create a library project in FlexBuilder:

  * Go to `File` > `New` and select `Flex Library Project`
  * Name the project "PopforgeLibrary"
  * Click `Next`
  * Enter "src" as the `Main source folder`
  * Click `Finish`

# Sharing the project #

By following these instructions your library project will be connected to our code repository at Google Code.

  * Locate your Popforge project in the Navigator
  * Right click and select `Team` > `Share Project...`
  * Choose `SVN` as the repository type
  * Click `Next`
  * Select `Create a new repository location`
  * Click `Next`
  * Enter "http://popforge.googlecode.com/svn/" in the `URL` textbox
  * Click `Next`
  * Select `Use specified name` in the `Name on Repository` group
  * Enter "flash/PopforgeLibrary" in the textbox
  * Click `Next`
  * Uncheck `Launch the Commit Dialog for the shared resources`
  * Click `Finish`
  * Click `Yes` if a warning message pops up

Now Subversive should download the PopforgeLibrary project into your workspace.

# Selecting the classes to include #

When the download process is finished you have to specify the classes that should be included in the library.

  * Locate your Popforge project in the Navigator
  * Right click and select `Properties`
  * Go to `Flex Library Build Path`
  * Check the "src" folder in the `Classes` tab
  * Click `Ok`

It is important to remember this step. After each update you should make sure to include all classes to the library. They are not added automatically.

Now to make sure everything is working check the "bin" directory of the PopforgeLibrary project. If you see a "PopforgeLibrary.swc" file there you are ready to go.