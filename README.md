<!--
    This file is part of doxyqbs

    Copyright (c) Romain Ducher
    Zmail: ducher.romain@gmail.com

    For the full copyright and license information, please view the LICENSE
    file that was distributed with this source code.
-->

doxyqbs
======

[QBS](https://doc.qt.io/qbs/) module for generating documentation with [Doxygen](http://www.doxygen.org).

Author: Romain Ducher <[ducher.romain@gmail.com](mailto://ducher.romain@gmail.com)>

1. What are QBS and doxyqbs?
------

[QBS](https://doc.qt.io/qbs/) is a new build tool made by [The Qt Company](https://www.qt.io/). It means **Q**t **B**uilding **S**uite. It aims to replace qmake in the future.

**doxyqbs** is a QBS module for generating documentation with [Doxygen](http://www.doxygen.org). You provide a full path to a Doxygen executable and a Doxygen configuration file and doxyqbs is able to generate the documentation for you.

**doxyqbs do not generate the configuration file.** You have to make it by yourself, using tools like Doxywizard or through `doxygen -g`.

doxyqbs consists in two entities:
* A QBS module whose name is "_doxyqbs_". It provides support for Doxygen.
* A QBS product whose type is `Doxydoc`. It is a basic QBS product which depends on the _doxyqbs_ module.


2. Install doxyqbs:
------

* Get the code of this repo by using GitHub's "_Clone or download_" button.
* Put the folder in your QBS project or in your `preferences.qbsSearchPaths`.
* You can also merge the doxyqbs root folder with other folder containing stuff related to QBS if you want to. Doxyqbs imports will join all your other QBS imports and it will be the same for modules. Assume that you put all your QBS stuff in `<project_root>/path/to/your/qbs/stuff/`. You can merge the doxyqbs folder with `<project_root>/path/to/your/qbs/stuff/`. Doxyqbs imports will be located at `<project_root>/path/to/your/qbs/stuff/imports/doxyqbs/` and doxyqbs modules will be located at `<project_root>/path/to/your/qbs/stuff/modules/doxyqbs/`.

3. Using doxyqbs in your project:
------

Add the doxyqbs location to your `qbsSearchPaths` (if it is not in your `preferences.qbsSearchPaths` of course):
```qml
/// @file yourproject.qbs
// Assuming that doxyqbs is in <project_root>/path/to/doxyqbs/folder/
import qbs

Project {
    // ...
	
    qbsSearchPaths: [ 'path/to/doxyqbs/folder' ]
	
    // ...
}
```

To generate documentation, you need to create a QBS product depending on the doxyqbs module. It is called "_doxyqbs_". The module needs one parameter. It is called `doxyqbs.doxygenExecutable`. It is your doxygen executable. Its default value is `doxygen`.

You also have to tag your Doxygen config file with the `doxyfile` tag.

Example:
```qml
/// @file yourproject.qbs
// Assuming that doxyqbs is in <project root>/path/to/doxyqbs/folder/
import qbs

Project {
    // ...
	
    qbsSearchPaths: [ 'path/to/doxyqbs/folder' ]
	
    // ...
	
    Product {
        name: "gendoc"
        type: [ "doxygen_doc" ]
        // type: [ doxyqbs.GENERATED_DOC_FILETAG ] also works.
		
        Depends { name: "doxyqbs" }
		
        doxyqbs: {
            doxygenExecutable: "doxygen.exe"
            doxygenConfigFile: "doc/Doxyfile.txt"
        }
		
        // ...
    }
    // ...
}
```

That's all! To generate your documentation, execute `qbs build`:
```
<project_root> $> qbs build -f yourproject.qbs -p gendoc profile:your_qbs_profile
# same as doxygen.exe <project_root>/doc/Doxyfile.txt
```

Doxyqbs provides a QBS product for convenience called `Doxydoc`. It is just a QBS product which depends on the _doxyqbs_ QBS module. `Doxydoc` has two properties :
* `doxygenExecutable`: value for `doxyqbs.doxygenExecutable`
* `doxygenConfigFile`: a path to your Doxygen configuration file. Its default value is `Doxyfile`. The path can be absolute or relative.

Same example as before, but using a `Doxydoc` product:
```qml
/// @file yourproject.qbs
// Assuming that doxyqbs is in <project root>/path/to/doxyqbs/folder/
import qbs

Project {
    // ...
	
    qbsSearchPaths: [ 'path/to/doxyqbs/folder' ]
	
    references: [ 'DocProd.qbs' ]
	
    // ...
}
```

```qml
/// @file DocProd.qbs
import qbs
import doxyqbs

doxyqbs.Doxydoc {
    name: "gendoc"
    doxygenExecutable: "doxygen.exe"
    doxygenConfigFile: "doc/Doxyfile.txt"
	
    // ...
}
```

```
# qbs build
<project_root> $> qbs build -f yourproject.qbs -p gendoc profile:your_qbs_profile
# same as doxygen.exe <project_root>/doc/Doxyfile.txt
```

4. doxyqbs documentation:
------

Here is the doxyqbs content:

```
/<project_root>/
    |
    +---/imports/
    |       |
    |       +---/doxyqbs/
    |                |
    |                +---/Doxydoc.qbs : Doxydoc product
    |
    +---/modules/
    |       |
    |       +---/doxyqbs/
    |                |
    |                +---/doxyqbs.qbs : doxyqbs module
    |
    +---/LICENCE : doxyqbs licence (LGPLv3)
    |
    +---/README.md : this README file
```

So you can easily merge it with orther QBS imports and modules in your project (or your "global" QBS stuff).

The documentation generation is made with a QBS Rule. It takes `doxyfile`-tagged files as inputs and outputs `doxygen_doc`-tagged files. `doxyfile`-tagged files are supposed to be your doxygen configuration file only, so put it in a QBS Group with this tag.
