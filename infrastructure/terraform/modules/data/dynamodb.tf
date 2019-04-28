resource "aws_dynamodb_table" "ExerciseTable" {
  name           = "ExerciseTable"
  billing_mode   = "PROVISIONED"
  read_capacity  = 2
  write_capacity = 2
  hash_key       = "UserID"
  range_key      = "ExerciseDate"

  attribute {
    name = "UserID"
    type = "S"
  }

#  attribute {
#    name = "ExerciseName"
#    type = "S"
#  }

  attribute {
    name = "ExerciseDate"
    type = "S"
  }

#  attribute {
#    name = "Reps"
#    type = "N"
#  }

#  attribute {
#    name = "Weight"
#    type = "N"
#  }


  ttl {
    attribute_name = "TimeToExist"
    enabled        = false
  }


  tags = {
    Name        = "exercise-table"
  }
}
