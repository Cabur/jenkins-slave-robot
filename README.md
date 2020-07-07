# Port
This is a modification from https://github.com/redhat-cop/containers-quickstarts jenkins-slave-python
Just adding the following Packages
`RPMS:
    Chrome
    Chromedriver`
`PIP:
    robotframework
    selenium
    robotframework-seleniumlibrary
    robotframework-selenium2library`


# jenkins-slave-robot
Provides a docker image of the robotframework for use as a Jenkins slave.

## Build local
`docker build -t jenkins-slave-robot .`

## Run local
For local running and experimentation run `docker run -i -t jenkins-slave-robot /bin/bash` and have a play once inside the container.

## Build in OpenShift
This is pulled out of [container_quickstarts](https://github.com/redhat-cop/containers-quickstarts), which is not included in this repo.
```bash
oc process -f ../../.openshift/templates/jenkins-slave-generic-template.yml \
    -p NAME=jenkins-slave-robot \
    -p SOURCE_CONTEXT_DIR=jenkins-slaves/jenkins-slave-robot \
    -p DOCKERFILE_PATH=Dockerfile \
    | oc create -f -
```
For all params see the list in the `../../.openshift/templates/jenkins-slave-generic-template.yml` or run `oc process --parameters -f ../../.openshift/templates/jenkins-slave-generic-template.yml`.

## Jenkins
Add a new Kubernetes Container template called `jenkins-slave-robot` (if you've build and pushed the container image locally) and specify this as the node when running builds. If you're using the template attached; the `role: jenkins-slave` is attached and Jenkins should automatically discover the slave for you. Further instructions can be found [here](https://docs.openshift.com/container-platform/3.7/using_images/other_images/jenkins.html#using-the-jenkins-kubernetes-plug-in-to-run-jobs).

## Test
To run the tests you need to get the .robot files in the container. My simple tests was to curl my included tests into `/tmp/` and run them. I used the following cmds in a Jenkinsfile to accomplish this.
```bash
curl https://raw.githubusercontent.com/Cabur/jenkins-slave-robot/master/test/test-chrome.robot -o /tmp/test.robot
robot /tmp/test.robot
```
