package main

import (
	"log"

	"github.com/aws/aws-lambda-go/lambda"
)

func Handler() {
	log.Println("Hello World")
}

func main() {
	lambda.Start(Handler)
}
