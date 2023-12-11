# Marked One

[![Package Version](https://img.shields.io/hexpm/v/parser)](https://hex.pm/packages/parser)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/parser/)

Hey there Gleamlin, ready to start your markup journey?

## What is Marked One?

Marked One is a pure Gleam implementation of the [GitHub Markdown Specification](https://github.github.com/gfm/)
The goal is to create a library that consumes strings and outputs a queryable data source that you can
use whenever you need to build your own output specification. 

[We are basing the parsing off of the work done here](https://github.github.com/gfm/)

```
import block_def/document
import gleam/io

fn write_html(doc: Document){
    ...
}

pub fn main(){
    let data = "# foo\nThis is a test paragraph\n\n"
    case document.parse_document(data){
        Ok(doc) -> write_html(doc)
        Err(err) -> io.debug(err.Message)
    }
}
```

__PRs open!__

## Support the other Gleam markup processors
- [Jot](https://github.com/lpil/jot)

## TO-DO LIST

## References


### Overall Tasks

### Leaf Blocks

Leaf blocks contain no other blocks

- [ ] Thematic Breaks
- [ ] ATX Heading __IN PROGRESS__
- [ ] ~~Setext Heading~~ (This is kind of a pain to parse atm)
- [ ] Indented code blocks
- [ ] Fenced code blocks
- [ ] HTML Blocks
- [ ] Link reference definitions
- [ ] Paragraphs
- [ ] Blank Lines
- [ ] Tables

### Container Blocks

- [ ] Block quotes
- [ ] List items
- [ ] Task list items
- [ ] Lists

## Quick start

```sh
gleam run   # Run the project
gleam test  # Run the tests
```

## Installation

Not available on Hex just yet, but we're trying to get there.

When we do please add marked_one to your project using:

```sh
gleam add marked_one
```

and its documentation can be found at <https://hexdocs.pm/marked_one>.