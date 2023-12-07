import gleam/option
import gleam/list

pub type EmphasisType {
  Bold
  Underscore
  Italic
  Strikethrough
}

pub type Element {
  Element(List(Element))
  H1(id: option.Option(String), List(Element))
  H2(id: option.Option(String), List(Element))
  H3(id: option.Option(String), List(Element))
  H4(id: option.Option(String), List(Element))
  H5(id: option.Option(String), List(Element))
  H6(id: option.Option(String), List(Element))
  Blockquote(id: option.Option(String), List(Element))
  Image(id: option.Option(String), url: String)
  Emphasis(id: option.Option(String), value: String, types: List(EmphasisType))
  Paragraph(id: option.Option(String), List(Element))
  Text(id: option.Option(String), value: String)
  ReferenceLink(id: option.Option(String), name: String, url: String)
  Link(id: option.Option(String), value: String, url: String)
  CodeBlock(id: option.Option(String), value: String)
  OrderedList(id: option.Option(String))
  UnorderedList(id: option.Option(String))
  Table(id: option.Option(String))
  TaskList(id: option.Option(String))
  Footnote(id: option.Option(String))
  JumpTo(id: option.Option(String), target_id: String)
  HorizontalLine(id: option.Option(String))
}

pub fn new() -> Element {
  Element([])
}
