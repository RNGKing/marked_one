pub type EmphasisType {
  Bold
  Italic
  Striked
}

pub type Row {
  List(columns: List(Column))
}

pub type TableHeader {
  TableHeader(value: String)
}

pub type Column {
  Column(value: String)
}

pub type HeadingLevel {
  H1
  H2
  H3
  H4
  H5
  H6
}

pub type PhaseOneBlock {
  Heading(text: String, level: HeadingLevel)
  Blockquote
  Image
  Paragraph
  ReferenceLink
  CodeBlock
  OrderedList
  UnorderedList
  Table
  TaskList
  Footnote
  JumpTo
  HorizontalLine
  OpenParagraph(text: String)
  CompleteParagraph(text: String)
}

pub type TextLike {
  Plain(value: String, emphasis: List(EmphasisType))
  Link(value: String, url: String, emphasis: List(EmphasisType))
}
