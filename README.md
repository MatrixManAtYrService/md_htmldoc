# md_htmldoc
Store markdown documentation in the same folder as code, run this script, get html documentation in a dedicated folder

## What it will do
 
Suppose you have a directory tree like this:

    .
    └── foo
        ├── bar.md
        ├── baz
        │   ├── qux.md
        │   └── qux.png
        └── md_htmldoc
            ├── md_htmldoc.sh
            ├── fixlinks.py
            ├── requirements.txt
            └── README.md

When you run `md_htmldoc.sh`

  1. `./foo/foo_htmldoc` will be deleted, if it exists
  2. All of the `.md` files under `foo` will be found and deemed "documentation-relevant"
  3. Any files that they reference will be found and deemd "documentation-relevant"
  4. All documentation-relevant files will be copied into `./foo/foo_htmldoc`
  5. All `.md` files will be converted to `.html` files
  6. Hyperlinks will be fixed so that the `.html` files link to each other
  
## Requirements

- Have python installed  
- Install Pandoc: `apt install pandoc`
- Install python requirements: `pip install -r requirements.txt`
