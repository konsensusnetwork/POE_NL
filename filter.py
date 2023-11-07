#!/usr/bin/env python3
import panflute as pf
import sys
import re

def debug_log(message):
    print(message, file=sys.stderr)

def prepare(doc):

    pass

def handle_lettrine(elem, doc):
    if isinstance(elem, pf.Span) and 'lettrine' in elem.classes:
        letter = elem.content[0].text if elem.content and isinstance(elem.content[0], pf.Str) else ''
        rest_of_content = elem.content[1:] if len(elem.content) > 1 else []
        return [pf.Str(letter)] + rest_of_content
    elif isinstance(elem, pf.SmallCaps):
        return [pf.Str(content.text) for content in elem.content]

def finalize(doc):
    pass

def main(doc=None):
    return pf.run_filters([handle_lettrine], prepare=prepare, finalize=finalize, doc=doc)

if __name__ == '__main__':
    main()
