node {

		stage('Checkout') {
			git url: 'https://github.com/OmarEwedah/DevOps.git'
		}

		stage('build') {
			sh "mvn package"
			}

		stage('test') {
			sh "echo testing"
		}
		stage('Deploy') {
			sh "docker build -t hello-world ."
			sh "docker run -d -p 8080:8080 hello-world"
		}

	}
