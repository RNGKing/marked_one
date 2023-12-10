import gleeunit
import gleeunit/should
import marked_one.{
  Bold, H2, H4, Heading, Italic, Link, Plain, Striked, parse_block,
}

pub fn main() {
  gleeunit.main()
}

pub fn h1_text_test() {
  parse_block("## _title_\n")
  |> should.be_ok
  |> should.equal(#(Heading([Plain("title", [Italic])], H2), ""))
}

pub fn h4_link_test() {
  parse_block("#### **[~~google~~](https://google.com)**\n")
  |> should.be_ok
  |> should.equal(#(
    Heading([Link("google", "https://google.com", [Striked, Bold])], H4),
    "",
  ))
}
