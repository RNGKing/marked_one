import block_def/doc/document
import block_def/block
import gleeunit/should
import gleam/io
import simplifile as file

pub fn heading_1_test() {
  "# foo\n"
  |> document.parse_document
  |> should.be_ok
  |> should.equal(document.Document(blocks: [block.Heading("foo", block.H1)]))
}

pub fn heading_2_test() {
  "## foo\n"
  |> document.parse_document
  |> should.be_ok
  |> should.equal(document.Document(blocks: [block.Heading("foo", block.H2)]))
}

pub fn heading_3_test() {
  "### foo\n"
  |> document.parse_document
  |> should.be_ok
  |> should.equal(document.Document(blocks: [block.Heading("foo", block.H3)]))
}

pub fn heading_4_test() {
  "#### foo\n"
  |> document.parse_document
  |> should.be_ok
  |> should.equal(document.Document(blocks: [block.Heading("foo", block.H4)]))
}

pub fn heading_5_test() {
  "##### foo\n"
  |> document.parse_document
  |> should.be_ok
  |> should.equal(document.Document(blocks: [block.Heading("foo", block.H5)]))
}

pub fn heading_6_test() {
  "###### foo\n"
  |> document.parse_document
  |> should.be_ok
  |> should.equal(document.Document(blocks: [block.Heading("foo", block.H6)]))
}

pub fn heading_muliline_test() {
  "# foo\n## foo 2\n"
  |> document.parse_document
  |> should.be_ok
  |> should.equal(document.Document(blocks: [
    block.Heading("foo", block.H1),
    block.Heading("foo 2", block.H2),
  ]))
}

pub fn heading_muliline_2_test() {
  "# foo\n\n\n## foo 2\n"
  |> document.parse_document
  |> should.be_ok
  |> should.equal(document.Document(blocks: [
    block.Heading("foo", block.H1),
    block.Heading("foo 2", block.H2),
  ]))
}

pub fn heading_muliline_3_test() {
  1
  //"# foo\n## foo \n2\n"
  // |> document.parse_document
  // |> should.be_ok
  // |> should.equal(document.Document(blocks: [
  //    block.Heading("foo", block.H1),
  //  block.Heading("foo ", block.H2),
  //]))
}

pub fn heading_muliline_4_test() {
  1
  // "# foo\n## foo 2\n"
  // |> document.parse_document
  // |> should.be_ok
  // |> should.equal(document.Document(blocks: [
  //   block.Heading("foo", block.H1),
  //   block.Heading("foo 2", block.H2),
  //  ]))
}

pub fn heading_test_multiline_file_io_test() {
  file.read("./test/test_data.mkd")
  |> should.be_ok
  |> document.parse_document
  |> should.be_ok
}
