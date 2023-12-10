import gleam/set
import gleam/list
import gleam/regex
import gleam/option
import gleam/string

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

pub type Block {
  Heading(value: List(TextLike), level: HeadingLevel)
  Blockquote(id: option.Option(String), children: List(Block))
  Image(id: option.Option(String), url: String)
  Paragraph(id: option.Option(String), children: List(Block))
  ReferenceLink(id: option.Option(String), name: String, url: String)
  CodeBlock(id: option.Option(String), value: String)
  OrderedList(id: option.Option(String), order_id: Int, children: List(Block))
  UnorderedList(id: option.Option(String), children: List(Block))
  Table(id: option.Option(String), headers: List(TableHeader), rows: List(Row))
  TaskList(id: option.Option(String), complete: Bool)
  Footnote(id: option.Option(String), target_id: String)
  JumpTo(id: option.Option(String), target_id: String)
  HorizontalLine(id: option.Option(String))
}

pub type TextLike {
  Plain(value: String, emphasis: List(EmphasisType))
  Link(value: String, url: String, emphasis: List(EmphasisType))
}

import gleam/io

pub fn main() {
  parse_block("## [google](https://google.com)\n")
  |> io.debug
}

pub fn parse_block(input: String) {
  case input {
    "# " <> rest ->
      case consume_till_new_line(rest, "") {
        Ok(#(line, rest)) -> Ok(#(Heading(parse_text_like(line, []), H1), rest))
        Error(Nil) -> Error(Nil)
      }

    "## " <> rest ->
      case consume_till_new_line(rest, "") {
        Ok(#(line, rest)) -> Ok(#(Heading(parse_text_like(line, []), H2), rest))
        Error(Nil) -> Error(Nil)
      }

    "### " <> rest ->
      case consume_till_new_line(rest, "") {
        Ok(#(line, rest)) -> Ok(#(Heading(parse_text_like(line, []), H3), rest))
        Error(Nil) -> Error(Nil)
      }

    "#### " <> rest ->
      case consume_till_new_line(rest, "") {
        Ok(#(line, rest)) -> Ok(#(Heading(parse_text_like(line, []), H4), rest))
        Error(Nil) -> Error(Nil)
      }

    "##### " <> rest ->
      case consume_till_new_line(rest, "") {
        Ok(#(line, rest)) -> Ok(#(Heading(parse_text_like(line, []), H5), rest))
        Error(Nil) -> Error(Nil)
      }

    "###### " <> rest ->
      case consume_till_new_line(rest, "") {
        Ok(#(line, rest)) -> Ok(#(Heading(parse_text_like(line, []), H6), rest))
        Error(Nil) -> Error(Nil)
      }

    _ -> Error(Nil)
  }
}

fn parse_text_like(input: String, storage: List(TextLike)) {
  case input {
    "" -> storage
    _ ->
      case parse_link(input) {
        Ok(#(link, rest)) -> parse_text_like(rest, list.append(storage, [link]))
        Error(Nil) ->
          case parse_plain_text(input, set.new()) {
            #(value, emphasis) -> list.append(storage, [Plain(value, emphasis)])
          }
      }
  }
}

fn extract_bold(input: String) {
  case
    [extract_enclosed(input, "**", "**"), extract_enclosed(input, "__", "__")]
  {
    [Ok(enclosed), _] | [_, Ok(enclosed)] -> Ok(enclosed)
    _ -> Error(Nil)
  }
}

fn extract_italic(input: String) {
  case [extract_enclosed(input, "*", "*"), extract_enclosed(input, "_", "_")] {
    [Ok(enclosed), _] | [_, Ok(enclosed)] -> Ok(enclosed)
    _ -> Error(Nil)
  }
}

fn extract_striked(input: String) {
  case extract_enclosed(input, "~~", "~~") {
    Ok(enclosed) -> Ok(enclosed)
    _ -> Error(Nil)
  }
}

fn parse_plain_text(input: String, emphasis: set.Set(EmphasisType)) {
  let recurse = False
  let #(input, emphasis, recurse) = case extract_bold(input) {
    Ok(bold) -> #(bold, set.insert(emphasis, Bold), True)
    _ -> #(input, emphasis, recurse)
  }
  let #(input, emphasis, recurse) = case extract_italic(input) {
    Ok(italic) -> #(italic, set.insert(emphasis, Italic), True)
    _ -> #(input, emphasis, recurse)
  }
  let #(input, emphasis, recurse) = case extract_striked(input) {
    Ok(bold) -> #(bold, set.insert(emphasis, Striked), True)
    _ -> #(input, emphasis, recurse)
  }
  case recurse {
    True -> parse_plain_text(input, emphasis)
    False -> #(input, set.to_list(emphasis))
  }
}

fn parse_link(input: String) {
  case parse_plain_text(input, set.new()) {
    #(input, emphasis) ->
      case input {
        "[" <> rest ->
          case consume_till_closing(rest, "]", "") {
            Ok(#(value, rest)) ->
              case rest {
                "(" <> rest ->
                  case consume_till_closing(rest, ")", "") {
                    Ok(#(url, rest)) ->
                      case parse_plain_text(value, set.from_list(emphasis)) {
                        #(value, emphasis) ->
                          Ok(#(Link(value, url, emphasis), rest))
                      }
                    Error(Nil) -> Error(Nil)
                  }
                _ -> Error(Nil)
              }
            Error(Nil) -> Error(Nil)
          }
        _ -> Error(Nil)
      }
  }
}

fn consume_till_new_line(
  input: String,
  storage: String,
) -> Result(#(String, String), Nil) {
  case string.pop_grapheme(input) {
    Ok(#("\n", rest)) -> Ok(#(storage, rest))
    Ok(#(ch, rest)) -> consume_till_new_line(rest, string.append(storage, ch))
    Error(Nil) -> Error(Nil)
  }
}

fn extract_enclosed(input: String, opening: String, closing: String) {
  let opening =
    opening
    |> string.to_graphemes
    |> list.map(fn(char) { "\\" <> char })
    |> string.join("")
  let closing =
    closing
    |> string.to_graphemes
    |> list.map(fn(char) { "\\" <> char })
    |> string.join("")
  case regex.from_string("^" <> opening <> "(.*)" <> closing <> "$") {
    Ok(pattern) ->
      case regex.scan(pattern, input) {
        [regex.Match(_, [option.Some(enclosed)])] -> Ok(enclosed)
        _ -> Error(Nil)
      }
    Error(_) -> Error(Nil)
  }
}

fn consume_till_closing(
  input: String,
  delimiter: String,
  storage: String,
) -> Result(#(String, String), Nil) {
  let input_length = string.length(input)
  let delimiter_length = string.length(delimiter)
  case string.slice(input, 0, delimiter_length) {
    candidate if candidate == delimiter -> {
      Ok(#(
        storage,
        string.slice(input, delimiter_length, input_length - delimiter_length),
      ))
    }

    _ -> {
      case string.pop_grapheme(input) {
        Ok(#(ch, rest)) ->
          consume_till_closing(rest, delimiter, string.append(storage, ch))
        Error(Nil) -> Error(Nil)
      }
    }
  }
}
