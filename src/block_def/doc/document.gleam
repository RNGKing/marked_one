import block_def/block.{type PhaseOneBlock, H1, H2, H3, H4, H5, H6, Heading}
import gleam/string
import gleam/bool
import gleam/result
import gleam/list
import block_def/doc/parsing_helpers as helper
import gleam/io

pub type Document {
  Document(blocks: List(PhaseOneBlock))
}

pub type ParserError {
  ParseError(msg: String)
}

pub fn parse_document(input: String) -> Result(Document, ParserError) {
  let output_doc = Document(blocks: [])
  let input_lines = string.split(input, "\n")
  case parse_doc_internal(input_lines, output_doc) {
    Ok(doc) -> Ok(Document(blocks: list.reverse(doc.blocks)))
    Error(err) -> Error(err)
  }
}

fn parse_doc_internal(
  input: List(String),
  doc: Document,
) -> Result(Document, ParserError) {
  case list.filter(input, fn(item) { !string.is_empty(item) }) {
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
  // Parse types in this big function
  use <- bool.guard(
    when: helper.is_line_heading(line),
    return: parse_heading(line, doc),
  )
  // finally parse out a paragraph
  parse_paragraph(line, doc)
}

fn parse_heading(line: String, doc: Document) -> Result(Document, ParserError) {
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
  let assert Ok(output_block) = heading
  Ok(Document(blocks: [output_block, ..doc.blocks]))
}

fn parse_paragraph(line: String, doc: Document) -> Result(Document, ParserError) {
  io.debug(line)
  case line {
    "\n" -> {
      case list.first(doc.blocks) {
        Ok(val) -> {
          case val {
            block.OpenParagraph(text) -> {
              let [_, ..tail] = doc.blocks
              Ok(Document(blocks: [block.CompleteParagraph(text: text), ..tail]))
            }
            _ -> Ok(doc)
          }
        }
        _ -> Ok(doc)
      }
    }
    "\eof" -> {
      case list.first(doc.blocks) {
        Ok(val) -> {
          case val {
            block.OpenParagraph(text) -> {
              let [_, ..tail] = doc.blocks
              Ok(Document(blocks: [block.CompleteParagraph(text: text), ..tail]))
            }
            _ -> Ok(doc)
          }
        }
        _ -> Ok(doc)
      }
    }
    text_value -> {
      case list.first(doc.blocks) {
        Ok(block_type) -> {
          case block_type {
            block.OpenParagraph(text) -> {
              let [_, ..tail] = doc.blocks
              Ok(Document(blocks: [
                block.OpenParagraph(text: text <> " " <> text_value),
                ..tail
              ]))
            }
            _ -> {
              Ok(Document(blocks: [
                block.OpenParagraph(text: text_value),
                ..doc.blocks
              ]))
            }
          }
        }
        _ -> Ok(doc)
      }
    }
    _ -> Ok(doc)
  }
}
