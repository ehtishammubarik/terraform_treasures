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
# locals {
#   user_description = "1 We will send emails for confirmation of user everytime they sign-up. 2 To maintain our recepient list we will use rds service the one we created in our private subnet. 3 To handle bounce, complaints and subscription problems we are providing contact details to users and they will get a un-sub link as well. 4 sample Content body -> Hey user-name congratulations on your new account sign-up with avantlabs.io please visit your account at account-url-here"
# }
# locals {
#   aws_command = "aws sesv2 --profile  jobnav2022 put-account-details --production-access-enabled --mail-type TRANSACTIONAL --website-url https://www.eprecisio.com/ --use-case-description '${local.user_description}' --additional-contact-email-addresses ehtisham.m7@gmail.com --contact-language EN"
# }
# Attaches a Managed IAM Policy to an IAM user
resource "aws_iam_user_policy_attachment" "jobnav2022_ses_user_policy" {
  user       = aws_iam_user.jobnav2022_ses_iam.name
  policy_arn = aws_iam_policy.jobnav2022_ses_policy.arn
  	
#   provisioner "local-exec" {
# 		command = "${local.aws_command}"
#   }
#   depends_on = [
# 	  aws_ses_email_identity.jobnav2022_email_identity
#   ]
}