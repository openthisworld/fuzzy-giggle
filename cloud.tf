terraform {
  backend "remote" {
    organization = "example-org-627f89"

    workspaces {
      name = "fuzzy-giggle"
    }
  }
}