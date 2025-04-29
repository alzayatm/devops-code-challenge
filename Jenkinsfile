pipeline {
  agent any

  environment {
    AWS_REGION = 'us-east-2'
    BACKEND_IMAGE = "406902142567.dkr.ecr.us-east-2.amazonaws.com/express-backend:latest"
    FRONTEND_IMAGE = "406902142567.dkr.ecr.us-east-2.amazonaws.com/react-frontend:latest"
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build Backend Docker Image') {
      steps {
        dir('backend') {
          sh 'docker build -f ../Docker/Dockerfile.backend -t $BACKEND_IMAGE .'        
        }
      }
    }

    stage('Build Frontend Docker Image') {
      steps {
        dir('frontend') {
          sh 'docker build -f ../Docker/Dockerfile.frontend -t $FRONTEND_IMAGE .'
        }
      }
    }

    stage('Provision Infrastructure via Terraform') {
      steps {
        dir('terraform') {
          sh '''
            terraform init
            terraform apply -auto-approve
          '''
        }
      }
    }

    stage('Login to ECR') {
      steps {
        sh '''
          aws ecr get-login-password --region $AWS_REGION | \
          docker login --username AWS --password-stdin 406902142567.dkr.ecr.$AWS_REGION.amazonaws.com
        '''
      }
    }

    stage('Push Images to ECR') {
      steps {
        sh '''
          docker push $BACKEND_IMAGE
          docker push $FRONTEND_IMAGE
        '''
      }
    }

    stage('Deploy to ECS') {
      steps {
        sh '''
          aws ecs update-service \
            --cluster devops-challenge-cluster \
            --service backend-service \
            --force-new-deployment

          aws ecs update-service \
            --cluster devops-challenge-cluster \
            --service frontend-service \
            --force-new-deployment
        '''
      }
    }
  }

  post {
    failure {
      echo 'Build failed!'
    }
  }
}
