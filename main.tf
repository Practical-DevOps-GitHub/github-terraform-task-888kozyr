provider "github" {
  token = var.github_token
}

resource "github_repository" "repo" {
  name        = var.repository_name
  visibility  = "public"
  auto_init   = true
}

resource "github_branch" "develop" {
  repository = github_repository.repo.name
  branch     = "develop"
}

resource "github_branch_default" "default" {
  repository = github_repository.repo.name
  branch     = github_branch.develop.branch
}

resource "github_repository_collaborator" "collaborator" {
  repository = github_repository.repo.name
  username   = "softservedata"
  permission = "push"
}

resource "github_branch_protection" "main" {
  repository_id = github_repository.repo.name
  pattern       = "main"
  required_pull_request_reviews {
    required_approving_review_count = 1
    require_code_owner_reviews      = true
  }
}

resource "github_branch_protection" "develop" {
  repository_id = github_repository.repo.name
  pattern       = "develop"
  required_pull_request_reviews {
    required_approving_review_count = 2
  }
}

resource "github_repository_file" "codeowners" {
  repository = github_repository.repo.name
  file       = ".github/CODEOWNERS"
  content    = "* @softservedata"
}

resource "github_repository_file" "pr_template" {
  repository = github_repository.repo.name
  file       = ".github/pull_request_template.md"
  content    = <<EOT
Describe your changes:

Issue ticket number and link:

Checklist before requesting a review:
- [ ] I have performed a self-review of my code
- [ ] If it is a core feature, I have added thorough tests
- [ ] Do we need to implement analytics?
- [ ] Will this be part of a product update? If yes, please write one phrase about this update
EOT
}

resource "github_repository_deploy_key" "deploy_key" {
  repository = github_repository.repo.name
  title      = "DEPLOY_KEY"
  key        = var.deploy_key
  read_only  = false
}

resource "github_actions_secret" "pat" {
  repository      = github_repository.repo.name
  secret_name     = "PAT"
  plaintext_value = var.pat_secret
}

resource "github_repository_webhook" "discord_webhook" {
  repository = github_repository.repo.name
  active     = true

  events = ["pull_request"]

  configuration {
    url          = "https://discord.com/api/webhooks/1347935810267385970/bUmFEB_Dz0iwabluzMs6_TMKULkf5Dj3dQ2Dl8xNLG4J2HLKw7gtX1kfulxKr4h2xPod"
    content_type = "json"
    insecure_ssl = false
  }
}

output "repository_url" {
  value = github_repository.repo.html_url
}
