import block_def/block.{type PhaseOneBlock, H1, H2, H3, H4, H5, H6, Heading}
import gleam/string
import gleam/bool
import gleam/result
import gleam/list

pub type Document {
  Document(blocks: List(PhaseOneBlock))
}

pub type ParserError {
  ParseError(msg: String)
}

pub fn parse_document(input: String) -> Result(Document, ParserError) {
  let output_doc = Document(blocks: [])
  let input_lines = string.split(input, "\n")
  parse_doc_internal(input_lines, output_doc)
}

fn parse_doc_internal(
  input: List(String),
  doc: Document,
) -> Result(Document, ParserError) {
  case input {
    [line, ..tail] -> {
      let result = parse_line(line, doc)
      use <- bool.guard(when: result.is_error(result), return: result)
      let assert Ok(next_doc) = result
      parse_doc_internal(tail, next_doc)
    }
    [] -> Ok(doc)
  }
}

// big parser...wanted to avoid this
fn parse_line(line: String, doc: Document) -> Result(Document, ParserError) {
  use <- bool.guard(
    when: is_line_heading(line),
    return: parse_heading(line, doc),
  )
  Ok(doc)
}

pub fn parse_heading(
  line: String,
  doc: Document,
) -> Result(Document, ParserError) {
  let heading = case line {
    "# " <> rest -> Ok(Heading(text: rest, level: H1))
    "## " <> rest -> Ok(Heading(text: rest, level: H2))
    "### " <> rest -> Ok(Heading(text: rest, level: H3))
    "#### " <> rest -> Ok(Heading(text: rest, level: H4))
    "##### " <> rest -> Ok(Heading(text: rest, level: H5))
    "###### " <> rest -> Ok(Heading(text: rest, level: H6))
    _ -> Error(ParseError("While parsing heading, no match for input found"))
  }
  use <- bool.guard(
    when: result.is_error(heading),
    return: Error(ParseError("While parsing heading, no match for input found")),
  )
  let assert Ok(output_blocks) = heading
  let output_list = list.reverse([output_blocks, ..doc.blocks])
  Ok(Document(blocks: output_list))
}

pub fn is_line_heading(line: String) -> Bool {
  case line {
    "# " <> rest -> True
    "## " <> rest -> True
    "### " <> rest -> True
    "#### " <> rest -> True
    "##### " <> rest -> True
    "###### " <> rest -> True
    _ -> False
  }
}
