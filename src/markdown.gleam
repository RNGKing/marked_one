import gleam/option
import gleam/list
import gleam/string

pub type EmphasisType {
  Bold
  Underscore
  Italic
  Strikethrough
}

pub type Row {
  List(column_vals: Column)
}

pub type TableHeader {
  TableHeader(value: String)
}

pub type Column {
  Column(value: String)
}

pub type HeaderType {
  H1
  H2
  H3
  H4
  H5
  H6
}

pub type Element {
  Element(children: List(Element))
  Header(value: String, header_type: HeaderType)
  Blockquote(id: option.Option(String), children: List(Element))
  Image(id: option.Option(String), url: String)
  Emphasis(id: option.Option(String), value: String, types: List(EmphasisType))
  Paragraph(id: option.Option(String), children: List(Element))
  Text(id: option.Option(String), value: String)
  ReferenceLink(id: option.Option(String), name: String, url: String)
  Link(id: option.Option(String), value: String, url: String)
  CodeBlock(id: option.Option(String), value: String)
  OrderedList(id: option.Option(String), order_id: Int, children: List(Element))
  UnorderedList(id: option.Option(String), children: List(Element))
  Table(id: option.Option(String), headers: List(TableHeader), rows: List(Row))
  TaskList(id: option.Option(String), complete: Bool)
  Footnote(id: option.Option(String), target_id: String)
  JumpTo(id: option.Option(String), target_id: String)
  HorizontalLine(id: option.Option(String))
}

pub fn new() -> Element {
  Element([])
}

pub fn parse(input: String, ast: Element) -> Element {
  case input {
    "# " <> rest -> {
      let #(remaining, new_ast) = append_header(rest, ast, H1)
      parse(remaining, new_ast)
    }

    _ -> ast
  }
}

fn append_header(
  input: String,
  ast: Element,
  header_type: HeaderType,
) -> #(String, Element) {
  case input {
    val -> {
      let #(header_val, rest) = read_string_till_double_newline(val)
      let output: Element = Header(value: header_val, header_type: header_type)
      let new_ast: Element =
        Element(children: list.append(ast.children, [output]))
      #(rest, new_ast)
    }
    _ -> #("", Text(id: option.None, value: "#"))
  }
}

pub fn read_string_till_double_newline(input: String) -> #(String, String) {
  let #(out, rest) = read_graphemes(string.to_graphemes(input), [])
  #(string.join(out, ""), string.join(rest, ""))
}

fn read_graphemes(
  input: List(String),
  output: List(String),
) -> #(List(String), List(String)) {
  case input {
    [char, ..rest] -> read_graphemes(list.append(output, [char]), rest)
    ["\n", "\n", ..rest] -> #(output, rest)
    _ -> #(output, [])
  }
}
