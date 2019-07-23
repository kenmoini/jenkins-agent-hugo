# jenkins-agent-hugo

A simple Jenkins Agent that is prepared to build Hugo Static Sites

Yeah, I don't know how else to break it to ya.  This is a Jenkins Build Agent that is based on the NodeJS Agent except that I also stuffed the latest [Hugo](https://gohugo.io/) binary in there too.

This way you can quickly pull in your source, build your site, run your tests, and deploy in a Jenkins pipeline.

Is this overkill for a static site generator like Hugo?  Arguably, but I think everything should be in a build pipeline - probably because I'm the modern day Philip Brainard of technical over-engineering (not really, those shoes could never be filled...)

## How to use

- Have Kubernetes Cluster, or Docker Swarm I guess if you're into that sorta thing
- Deploy Jenkins onto cluster/swarm of big fat daemons
- Configure your Kubernetes Service Account Credentials in your Jenkins server (important step most forget after that helm chart...)
- Create pipeline targeting this container
- Run pipeline, give it a few minutes to pull in the container maybe

**Don't have have a pipeline?**

No problem, here's an example, with the agent and pod definition and everything:

```
pipeline {
  agent {
    kubernetes {
      defaultContainer 'jnlp'
      yaml """
apiVersion: v1
kind: Pod
metadata:
  labels:
    some-label: some-label-value
spec:
  containers:
  - name: hugo
    image: kenmoini/jenkins-agent-hugo:latest
    command:
    - cat
    tty: true
  - name: busybox
    image: busybox
    command:
    - cat
    tty: true
"""
    }
  }
  stages {
    stage('Run Hugo') {
      steps {
        container('hugo') {
          sh 'hugo version'
        }
        container('busybox') {
          sh '/bin/busybox'
        }
      }
    }
  }
}
```

Otherwise you can use the agent container in any other fashion by pulling from Docker Hub with a quick ``docker pull kenmoini/jenkins-agent-hugo``

Oh yeah, I guess you can ``docker build`` this Dockerfile too if you're into that sorta thing.  It'd be cooler if you hung out with my ``buildah bud``...
