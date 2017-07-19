# md_htmldoc
Store markdown documentation in the same folder as code, run this script, get html documentation in a dedicated folder

## What it will do
 
##### Suppose you have some project that looks like this:
    .
    └── foo
        ├── CMakeLists.txt
        ├── include
        │   ├── bar.h
        │   ├── baz.h
        │   └── baz.md
        ├── md_htmldoc
        │   ├── get_references.py
        │   ├── link_filter.py
        │   ├── md_htmldoc.sh
        │   └── README.md
        ├── README.md
        ├── src
        │   ├── bar.cpp
        │   ├── bar_doc.md
        │   └── bar.jpg
        └── test
            └── test_bar.cpp
    
- `foo` is a git repo containing markdown files with hyperlinks to each other
- `md_htmldoc` is this repo (either cloned within `foo` or added as a submodule)
    
##### If you run `md_htmldoc.sh`

  1. `./foo/foo_htmldoc` will be deleted, if it exists
  2. All of the `.md` files under `foo` will be found and deemed "documentation-relevant"
  3. Any files that they reference will be found and deemd "documentation-relevant"
  4. All documentation-relevant files will be copied into `./foo/foo_htmldoc`
  5. All `.md` files will be converted to `.html` files
  6. Hyperlinks will be fixed so that the `.html` files link to each other
  
##### Then you'll have a directory tree like this

    .
    └── foo
        ├── CMakeLists.txt
        ├── foo_htmldoc
        │   ├── include
        │   │   └── baz.html
        │   ├── README.html
        │   └── src
        │       ├── bar_doc.html
        │       └── bar.jpg
        ├── include
        │   ├── bar.h
        │   ├── baz.h
        │   └── baz.md
        ├── md_htmldoc
        │   ├── get_references.py
        │   ├── link_filter.py
        │   ├── md_htmldoc.sh
        │   └── README.md
        ├── README.md
        ├── src
        │   ├── bar.cpp
        │   ├── bar_doc.md
        │   └── bar.jpg
        └── test
            └── test_bar.cpp

 - `foo_htmldoc` has been added
  - it contains just the documentation, and the markdown has been converted to html
     
## Requirements

- Have python installed  
- Install Pandoc: `apt install pandoc`
- Install python requirements: `pip install -r requirements.txt`

## Why?

Maybe you want to share documentation with somebody that doesn't have access to your source repository, but you don't want to separate your documentation from your code.  You can use this script to create documentation builds and then serve them to the wider world, without also providing access to your code.

This makes me sad, but it appeases certain people that I work with
