################
#Lambda Policy #
################
resource "aws_iam_policy" "lambda_policy" {
  policy      = data.aws_iam_policy_document.lambda_policy_document.json
  name        = var.policy_name
  path        = "/"
  description = "lambda s3 credentials generator policy"
}

data "aws_iam_policy_document" "lambda_iam_policy_doc" {
  statement {
    sid = "s3Access"
    actions = [
                "s3:Get*",
                "s3:List*",
                "s3:Put*"
            ]
    resources = [
    "arn:aws:s3:::*/",
    "arn:aws:s3:::*/*",
    ]
  }
}

############
# ECS ROLE #
############

data "aws_iam_policy_document" "lambda_policy_document" {
  
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      identifiers = ["lambda.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_iam_role" "lambda_role" {
  assume_role_policy = data.aws_iam_policy_document.lambda_policy_document.json
  name = var.role_name

  tags = {
    Name = "dev"
  }
}

#######################
# Policy attachement #
#######################
resource "aws_iam_role_policy_attachment" "attach_lambda_policy_attach" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}
