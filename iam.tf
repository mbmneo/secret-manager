
# Créer la politique IAM
resource "aws_iam_policy" "lambda_secrets_manager_policy" {
  name        = "LambdaSecretsManagerPolicy"
  description = "Politique IAM pour permettre à Lambda d'accéder à Secrets Manager, gérer les interfaces réseau, et pousser des logs dans CloudWatch"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "secretsmanager:DescribeSecret",
                "secretsmanager:GetSecretValue",
                "secretsmanager:PutSecretValue",
                "secretsmanager:UpdateSecretVersionStage"
            ],
            "Resource": "${aws_secretsmanager_secret.rds_pg_secret.arn}"
        },
        {
            "Effect": "Allow",
            "Action": [
                "secretsmanager:GetRandomPassword"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:CreateNetworkInterface",
                "ec2:DeleteNetworkInterface",
                "ec2:DescribeNetworkInterfaces",
                "ec2:DetachNetworkInterface"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

# Créer le rôle IAM pour la fonction Lambda
resource "aws_iam_role" "lambda_iam_role" {
  name = "LambdaExecutionRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# Associer la politique IAM au rôle IAM
resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.lambda_iam_role.name
  policy_arn = aws_iam_policy.lambda_secrets_manager_policy.arn
}

# Output (facultatif) pour afficher l'ARN du rôle IAM
output "lambda_iam_role_arn" {
  value = aws_iam_role.lambda_iam_role.arn
}

