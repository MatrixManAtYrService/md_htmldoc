#!/usr/bin/env python3

import re
import sys
import errno
import os
from urllib.parse import unquote

pattern = re.compile(r"\[[^\]]+?]\(([^)]+?)\)")

doc_relevant = set()

for arg in sys.argv[1].split('\n'):

    if not os.path.exists(arg):
        raise FileNotFoundError(errno.ENOENT, os.strerror(errno.ENOENT), arg)
    else:
        (dirname, basename) = os.path.split(arg)

    doc_relevant.add(arg)

    for i, line in enumerate(open(arg)):
        for match in re.finditer(pattern, line):
            for group in match.groups():
                ref_file = '{}/{}'.format(dirname, group.rsplit('#page=', 1)[0])
                if os.path.exists(ref_file):
                    doc_relevant.add(ref_file)
                elif os.path.exists(unquote(ref_file)):
                    doc_relevant.add(unquote(ref_file))
                else:
                    sys.stderr.write("ignoring reference to nonlocal file: {}{}".format(ref_file, os.linesep))

for item in doc_relevant:
    print(item)
