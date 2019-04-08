############################
# Cognito Terraform Module #
############################


#Cognito User Pool
resource "aws_cognito_user_pool" "users_pool" {
  name  = "users-pool"

  alias_attributes          = ["email"]
  auto_verified_attributes  = ["email"]

  
  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    name                     = "name"
    required                 = true

    string_attribute_constraints {
      min_length = 1
      max_length = 2048
    }
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    name                     = "email"
    required                 = true

    string_attribute_constraints {
      min_length = 5
      max_length = 2048
    }
  }


  password_policy = {
    minimum_length    = 8
    require_uppercase = true
    require_numbers   = true
    require_symbols   = true
  }

}

#Cognoti User Pool Client - Web 
resource "aws_cognito_user_pool_client" "users_web_client" {
  name = "users-web-client"

  generate_secret = false

  user_pool_id = "${aws_cognito_user_pool.users_pool.id}"

}
