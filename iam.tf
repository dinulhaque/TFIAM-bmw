resource "aws_iam_user" "newemployees" {
  count = length(var.iam_names)
  name  = element(var.iam_names,count.index)
  path = "/system/"

  tags = {
    tag-key = "new hire"
  }
}

resource "aws_iam_access_key" "newhirekeys" {
  count = length(var.iam_names)
  user  = element(var.iam_names, count.index)

  depends_on = [
    #aws_iam_user_policy.newhire_policy
    aws_iam_user.newemployees
  ]
}

resource "aws_iam_account_password_policy" "strict" {
  minimum_password_length        = 8
  require_lowercase_characters   = true
  require_numbers                = true
  require_uppercase_characters   = true
  require_symbols                = false
  allow_users_to_change_password = true
}


resource "aws_iam_user_policy" "newhire_policy" {
  count = length(var.iam_names)
  name = "new"
  user = element(var.iam_names,count.index)
  
  depends_on = [
    #aws_iam_user_policy.newhire_policy
    aws_iam_user.newemployees
  ]
 
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:Describe*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}
