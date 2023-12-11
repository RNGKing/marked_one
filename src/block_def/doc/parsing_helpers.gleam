pub fn is_line_heading(line: String) -> Bool {
  case line {
    "# " <> _ -> True
    "## " <> _ -> True
    "### " <> _ -> True
    "#### " <> _ -> True
    "##### " <> _ -> True
    "###### " <> _ -> True
    _ -> False
  }
}
