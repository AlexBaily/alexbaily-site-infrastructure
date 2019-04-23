resource "aws_dynamodb_table" "ExerciseTable" {
  name           = "ExerciseTable"
  billing_mode   = "PROVISIONED"
  read_capacity  = 2
  write_capacity = 2
  hash_key       = "ExerciseID"
  range_key      = "ExerciseDate"

  attribute {
    name = "UserId"
    type = "S"
  }

  attribute {
    name = "ExerciseId"
    type = "S"
  }

  attribute {
    name = "ExerciseDate"
    type = "S"
  }

  attribute {
    name = "WeightReps"
    type = "S"
  }

  ttl {
    attribute_name = "TimeToExist"
    enabled        = false
  }


  tags = {
    Name        = "exercise-table"
  }
}
