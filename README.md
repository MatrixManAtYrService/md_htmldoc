# md_htmldoc
Store markdown documentation in the same folder as code, run this script, get html documentation in a dedicated folder

## What it will do

Suppose you have some project that looks like this:

    foo
    ├── bar.md
    ├── baz
    │   ├── image.png
    │   ├── qux.md
    │   └── some.other.file
    ├── grault
    │   └── file
    ├── README.md
    └── some.file

where `foo` is a git repo containing markdown files with hyperlinks to each other

If you [add this repo as a submodule](https://git-scm.com/book/en/v2/Git-Tools-Submodules#_starting_submodules) and run `md_htmldoc.sh`

  1. `./foo/foo_htmldoc` will be deleted, if it exists
  2. All of the `.md` files under `foo` will be found and deemed "documentation-relevant"
  3. Any files that they reference will be found and deemd "documentation-relevant"
  4. All documentation-relevant files will be copied into `./foo/foo_htmldoc`
  5. All `.md` files will be converted to `.html` files
  6. Hyperlinks will be fixed so that the `.html` files link to each other

Then you'll have a directory tree like this

    foo
    ├── bar.md
    ├── baz
    │   ├── image.png
    │   ├── qux.md
    │   └── some.other.file
    ├── foo_htmldoc
    │   ├── bar.html
    │   ├── baz
    │   │   ├── image.png
    │   │   └── qux.html
    │   └── README.html
    ├── grault
    │   └── file
    ├── md_htmldoc
    │   └── ...
    ├── README.md
    └── some.file
    test.txt


 - `foo_htmldoc` has been added
  - it contains just the documentation, and the markdown has been converted to html

## Requirements

- Have python installed
- Install Pandoc: `apt install pandoc`
- Install panflute: `pip install panflute`

## Why?

Maybe you want to share documentation with somebody that doesn't have access to your source repository, but you don't want to separate your documentation from your code.  You can use this script to create documentation builds and then serve them to the wider world, without also providing access to your code.

This makes me sad, but it appeases certain people that I work with

## Troubleshooting

- If you get `cp: cannot create regular file` errors, make sure that all of the documentation-relevant files in the parent repo are checked in.  md_htmldoc uses `git ls-tree` to discover the directory tree of the parent repo, and it will fail to mimic the directory structure if there are pending changes
