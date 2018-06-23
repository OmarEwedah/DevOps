node {

		stage('Checkout') {
			git url: 'https://github.com/talal-shobaita/hello-world.git'
		}

		stage('build') {
			sh "mvn package"
			}

		stage('test') {
			sh "echo testing"
		}
		stage('Deploy') {
			sh "echo testing"
		}

	}

	def serviceVersion
	def serviceArtifactid
	def devInfra = "10.236.245.245"
	def testingInfra = "10.236.246.30"
	def stagingInfra = "10.236.246.198"
	def testingEndPoint = "10.236.246.207"
	def devEndPoint = "10.236.245.24"

	def exchangeHost = "exchange-lil.corporateint.adrootint.infraint.ftgroupint:10.195.216.215"

	node('Docker') {
		stage('Checkout') {
			git url: repo["gitRepo"], branch: userInput["branch"], credentialsId: 'gitblit' //param
			sh "git rev-parse --short HEAD > .git/commit-id"
			commit_id = readFile('.git/commit-id').trim()
			repo.		"commitId" = commit_id
		}
		stage('docker build') {
			sh "mvn clean install -Dmaven.test.skip=true dockerfile:build"
			sh "mvn -Ddocker.repo.url=localhost:5000 dockerfile:push"
			serviceVersion = sh(script: "mvn org.apache.maven.plugins:maven-help-plugin:2.1.1:evaluate -Dexpression=project.version | grep -v '\\['", returnStdout: true).trim()
			serviceArtifactid = sh(script: "mvn org.apache.maven.plugins:maven-help-plugin:2.1.1:evaluate -Dexpression=project.artifactId | grep -v '\\['", returnStdout: true).trim()

		}
	}

	def imageName = "10.226.225.240:5000/hubme/" + serviceArtifactid + ":" + serviceVersion

	def exposePortOption = ""
	if(repo["exposePort"] != null){
		exposePortOption = "-p " + repo["exposePort"] + ":" + repo["exposePort"]
	}

	if (userInput["branch"] == "develop") {
		node(repo["testingNode"]) {
			stage('Deploy') {
				sh "docker pull ${imageName}"
				sh "docker stop ${serviceArtifactid} || true"
				sh "docker run -d ${exposePortOption} --rm --name ${serviceArtifactid} --add-host ${exchangeHost} -e INFRA_HOST=${testingInfra} -e OAUTH_HOST=${testingEndPoint} -e OAUTH_PORT=80 ${imageName}"
			}
		}
		node(repo["devNode"]) {
			stage('Deploy') {
				sh "docker pull ${imageName}"
				//sh "docker stop ${serviceArtifactid} || true"
				sh "docker stop $(docker ps -a -q --filter ancestor=${imageName} --format=\"{{.ID}}\") || true"
				for(i = 1; i <= repo["numberOfInstances"]; i++){
					sh "docker run -d ${exposePortOption} --rm --name ${serviceArtifactid}${i} --add-host ${exchangeHost} -e INFRA_HOST=${devInfra} -e OAUTH_HOST=${devEndPoint} -e OAUTH_PORT=80 ${imageName}"
				}
			}
		}
	}
}
