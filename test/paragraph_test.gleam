import gleeunit/should
import block_def/doc/document
import gleam/io

pub fn basic_paragraph_test() {
  "This is a paragraph with a line break\nwhere things should be\n\nNew paragraph"
  |> document.parse_document
  |> should.be_ok
  |> io.debug
}
