
pipeline {
    agent any
    
    environment {
        // Docker configuration
        DOCKER_IMAGE = "yourdockerhub/abode-webapp"
        DOCKER_TAG = "${BUILD_NUMBER}"
        
        // Application configuration
        APP_DIR = "/var/www/html"
    }
    
    stages {
        stage('1️⃣ Build') {
            steps {
                echo '========================================='
                echo '🚀 Starting Build Stage'
                echo '========================================='
                
                // Checkout code from GitHub
                echo '📥 Checking out code from GitHub...'
                checkout scm
                
                // Build Docker image
                echo '🐳 Building Docker image...'
                script {
                    docker.build("${DOCKER_IMAGE}:${DOCKER_TAG}")
                    docker.build("${DOCKER_IMAGE}:latest")
                }
                
                echo '✅ Build completed successfully!'
            }
        }
        
        stage('2️⃣ Test') {
            steps {
                echo '========================================='
                echo '🧪 Starting Test Stage'
                echo '========================================='
                
                // Run tests inside container
                echo '🔍 Running automated tests...'
                script {
                    // Run the container and execute tests
                    sh '''
                        docker run --rm ${DOCKER_IMAGE}:${DOCKER_TAG} \
                        /bin/bash -c "cd ${APP_DIR} && bash /tests/run-tests.sh"
                    '''
                }
                
                echo '✅ All tests passed!'
            }
        }
        
        stage('3️⃣ Deploy to Production') {
            when {
                // Only run this stage for master branch
                branch 'master'
            }
            steps {
                echo '========================================='
                echo '🚀 Starting Production Deployment'
                echo '========================================='
                
                echo '⚠️  This is MASTER branch - Deploying to PRODUCTION'
                
                script {
                    // Push Docker image to registry
                    echo '📤 Pushing Docker image to Docker Hub...'
                    docker.withRegistry('https://registry.hub.docker.com', 'dockerhub-credentials') {
                        docker.image("${DOCKER_IMAGE}:${DOCKER_TAG}").push()
                        docker.image("${DOCKER_IMAGE}:latest").push()
                    }
                    
                    // Deploy to production server
                    echo '🎯 Deploying to production server...'
                    sh '''
                        # Stop old container if running
                        docker stop abode-webapp || true
                        docker rm abode-webapp || true
                        
                        # Run new container
                        docker run -d \
                            --name abode-webapp \
                            -p 80:80 \
                            -v ${APP_DIR}:${APP_DIR} \
                            ${DOCKER_IMAGE}:${DOCKER_TAG}
                        
                        # Wait for application to start
                        sleep 10
                        
                        # Health check
                        curl -f http://localhost:80 || exit 1
                    '''
                }
                
                echo '✅ Production deployment successful!'
                echo '🌐 Application is live at: http://your-server-ip'
            }
        }
        
        stage('🔍 Post-Deployment Check') {
            when {
                branch 'master'
            }
            steps {
                echo '========================================='
                echo '✔️  Running Post-Deployment Checks'
                echo '========================================='
                
                script {
                    // Verify deployment
                    sh '''
                        echo "Checking if container is running..."
                        docker ps | grep abode-webapp
                        
                        echo "Checking application health..."
                        curl -I http://localhost:80
                        
                        echo "Deployment verification complete!"
                    '''
                }
            }
        }
    }
    
    post {
        success {
            echo '========================================='
            echo '✅ Pipeline Completed Successfully!'
            echo '========================================='
            script {
                if (env.BRANCH_NAME == 'master') {
                    echo '🎉 Application deployed to PRODUCTION'
                } else {
                    echo '✅ Tests passed (develop branch - no deployment)'
                }
            }
        }
        
        failure {
            echo '========================================='
            echo '❌ Pipeline Failed!'
            echo '========================================='
            echo '🔍 Check logs above for error details'
        }
        
        always {
            // Clean up
            echo 'Cleaning up Docker images...'
            sh 'docker image prune -f || true'
        }
    }
}

/* 
 * PIPELINE EXPLANATION:
 * 
 * This pipeline has 3 main jobs:
 * 
 * 1. BUILD (Job 1):
 *    - Pulls code from GitHub
 *    - Builds Docker image with the application
 *    - Tags image with build number
 * 
 * 2. TEST (Job 2):
 *    - Runs automated tests in container
 *    - Validates application works correctly
 *    - Blocks deployment if tests fail
 * 
 * 3. DEPLOY TO PROD (Job 3):
 *    - ONLY runs if branch is 'master'
 *    - Pushes Docker image to registry
 *    - Deploys to production server
 *    - Runs health checks
 * 
 * BRANCH LOGIC:
 * - develop branch: Runs Build + Test only
 * - master branch: Runs Build + Test + Production Deployment
 */
