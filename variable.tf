variable "region" {
  description = "The AWS region to deploy resources in."
  type        = string
  default = "us-east-2"
}

variable "SOURCE_GMAIL_ID"{
  description = "Source GMAIl Id"
  type = string
}
variable "SOURCE_AUTH_PASSWORD"{
  description = "Source Auth Password"
  type = string
}
variable "DESTINATION_GMAIL_ID"{
  description = "Destinal GMAIl Id"
  type = string
}