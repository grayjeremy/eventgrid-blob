resource "random_shuffle" "rs" {
  input        = ["us-west-1a", "us-west-1b", "us-west-1c"] /*["${var.raw_string_list}"]*/
  result_count = "${var.permutation_count}"
}
