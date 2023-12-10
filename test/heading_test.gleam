// This file contains the basic definition for ATX Headings, 
// Need to figure out if we want to even think of support SETX Headings
import gleeunit/should
import gleam/io
import marked_one.{
  Bold, H1, H2, H3, H4, H5, H6, Heading, Italic, Link, Plain, Striked,
  parse_block,
}

// Basic Parsing Tests

// H1: # foo\n
// H3: ### foo\n 
// H4: #### foo\n
// H5: ##### foo\n
// H6: ###### foo\n

pub fn header_h1_test() {
  "# foo\n"
  |> parse_block
  |> should.be_ok
  |> should.equal(#(Heading([Plain("foo", [])], H1), ""))
}

pub fn header_h2_test() {
  "## foo\n"
  |> parse_block
  |> should.be_ok
  |> should.equal(#(Heading([Plain("foo", [])], H2), ""))
}

pub fn header_h3_test() {
  "### foo\n"
  |> parse_block
  |> should.be_ok
  |> should.equal(#(Heading([Plain("foo", [])], H3), ""))
}

pub fn header_h4_test() {
  "#### foo\n"
  |> parse_block
  |> should.be_ok
  |> should.equal(#(Heading([Plain("foo", [])], H4), ""))
}

pub fn header_h5_test() {
  "##### foo\n"
  |> parse_block
  |> should.be_ok
  |> should.equal(#(Heading([Plain("foo", [])], H5), ""))
}

pub fn header_h6_test() {
  "###### foo\n"
  |> parse_block
  |> should.be_ok
  |> should.equal(#(Heading([Plain("foo", [])], H6), ""))
}

pub fn header_multiline_test() {
  "# foo\n## foo\n### foo\n#### foo\n##### foo\n###### foo\n"
  |> marked_one.parse_block
  |> io.debug
}
