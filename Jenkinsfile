node {
    checkout scm
    /*
     * In order to communicate with the MySQL server, this Pipeline explicitly
     * maps the port (`3306`) to a known port on the host machine.
     */
    docker.image('centos:7').inside(){
    stage("Gradle Clean & Build") {
      sh '''
        echo "Hellow-World"
        '''
        }
    }
}
