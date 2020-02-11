# To Do
## Missing Features

* There's no option to provide additional commands to pandoc, e.g. path to KaTeX scripts or CSS files

## Refactoring

* script ``get_references.py`` uses a Regex to find links in files. As pointed out [by hoijui at stackoverflow.com](https://stackoverflow.com/questions/40993488/#45182692), this is not a perfect solution (but it works for now).
  * this regex might not find all references
  * ``[link](url)`` get's found as reference, despite it isn't a link, because it's surrounded by backticks


## Known Bugs

* whitespaces in filenames get blown up in shell output which doesn't look pretty
