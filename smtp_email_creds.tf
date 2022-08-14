# Provides an SES email identity resource
resource "aws_ses_email_identity" "jobnav2022_email_identity" {
  email = "ehtisham.m7@gmail.com"
}

# Provides an IAM access key. This is a set of credentials that allow API requests to be made as an IAM user.
resource "aws_iam_user" "jobnav2022_ses_iam" {
  name = "SignUpNotifierJobnav2022"
}

# Provides an IAM access key. This is a set of credentials that allow API requests to be made as an IAM user.
resource "aws_iam_access_key" "jobnav2022_ses_access_key" {
  user = aws_iam_user.jobnav2022_ses_iam.name
}

# Attaches a Managed IAM Policy to SES Email Identity resource
data "aws_iam_policy_document" "jobnav2022_ses_policy_document" {
  statement {
    actions   = ["ses:SendEmail", "ses:SendRawEmail"]
    resources = [ "*" ]
    //[data.aws_ses_email_identity.jobnav2022_email_identity.arn]
  }
}

# Provides an IAM policy attached to a user.
resource "aws_iam_policy" "jobnav2022_ses_policy" {
  name   = var.ses_iam_policy
  policy = data.aws_iam_policy_document.jobnav2022_ses_policy_document.json
}

# Attaches a Managed IAM Policy to an IAM user
resource "aws_iam_user_policy_attachment" "jobnav2022_ses_user_policy" {
  user       = aws_iam_user.jobnav2022_ses_iam.name
  policy_arn = aws_iam_policy.jobnav2022_ses_policy.arn
}


# IAM user credentials output
output "smtp_username" {
  value = aws_iam_access_key.jobnav2022_ses_access_key.id
}

output "smtp_password" {
  value     = aws_iam_access_key.jobnav2022_ses_access_key.ses_smtp_password_v4
  sensitive = true
}