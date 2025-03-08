variable "github_token" {
  description = "GitHub Personal Access Token"
  type        = string
  sensitive   = true
}

variable "repository_name" {
  description = "GitHub Repository Name"
  type        = string
}

variable "deploy_key" {
  description = "SSH Deploy Key for the Repository"
  type        = string
  sensitive   = true
}

variable "pat_secret" {
  description = "Personal Access Token (PAT) for GitHub Actions"
  type        = string
  sensitive   = true
}