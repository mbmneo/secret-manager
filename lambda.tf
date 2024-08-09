# Créer la fonction Lambda
resource "aws_lambda_function" "my_lambda_function" {
  function_name = "MyLambdaFunction"
  role          = aws_iam_role.lambda_iam_role.arn
  handler       = "lambda_function.lambda_handler"  # Remplacez par le handler de votre code Lambda
  runtime       = "python3.9"  # Remplacez par votre runtime préféré

  # Chemin vers le fichier ZIP du code Lambda
  filename = "lambda_function.zip"  # Assurez-vous que ce fichier est dans le même répertoire ou donnez le chemin complet

  environment {
    variables = {
      SECRETS_MANAGER_ENDPOINT = "https://secretsmanager.us-east-1.amazonaws.com"
    }
  }

  # Paramètres de temps d'exécution
  timeout = 10  # Temps maximum d'exécution en secondes
  memory_size = 128  # Taille mémoire en MB
}

# Allow Secrets Manager to invoke the Lambda function
resource "aws_lambda_permission" "allow_secretsmanager_invoke" {
  statement_id  = "AllowSecretsManagerInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.my_lambda_function.function_name
  principal     = "secretsmanager.amazonaws.com"
}
