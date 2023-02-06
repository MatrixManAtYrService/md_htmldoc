#!/usr/bin/env python3

# Code by Sergio Correia
# https://stackoverflow.com/questions/40993488/#41005658

import panflute as pf

def action(elem, doc):
    if isinstance(elem, pf.Link):
        if elem.url.endswith('.md'):
            elem.url = elem.url[:-3] + '.html'
            return elem
        elif elem.url.find('.md#'):
            elem.url = elem.url.replace('.md#', '.html#')
            return elem

if __name__ == '__main__':
    pf.run_filter(action)
