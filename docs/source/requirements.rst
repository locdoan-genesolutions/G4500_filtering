.. _requirements-page:

Requirements
============



The G4500_workflow requires `Nextflow` and `Docker`. `Nextflow` can be used on any POSIX compatible system (Linux, OS X, etc). It requires BASH and `Java 8 (or higher) <http://www.oracle.com/technetwork/java/javase/downloads/index.html>`_ to be installed. Third-party software tools used by individual pipelines will be installed and managed through Docker.

Testing Nextflow
----------------
Before continuing, test to make sure your environment is compatible with a Nextflow executable. 

.. note:: You will download another one later when you clone the repository

Make sure your Java installation is version 8 or higher::

   java -version

Create a new directory and install/test `Nextflow`::

   mkdir test
   cd test
   curl -s https://get.nextflow.io | bash
   ./nextflow run hello

Output::

   N E X T F L O W  ~  version 0.31.0
   Launching `nextflow-io/hello` [sad_curran] - revision: d4c9ea84de [master]
   [warm up] executor > local
   [4d/479eec] Submitted process > sayHello (4)
   [a8/4bc038] Submitted process > sayHello (2)
   [17/5be64e] Submitted process > sayHello (3)
   [ee/0d879f] Submitted process > sayHello (1)
   Hola world!
   Ciao world!
   Hello world!
   Bonjour world!
   
Known compilation problems
---------------------------

Nextflow required JDK 8 to be compiled. The Java compiler used by the build process can be choose by setting the
`JAVA_HOME` environment variable accordingly.


If the compilation stops reporting the error: `java.lang.VerifyError: Bad <init> method call from inside of a branch`,
this is due to a bug affecting the following Java JDK:

- 1.8.0 update 11
- 1.8.0 update 20

Upgrade to a newer JDK to avoid to this issue. Alternatively a possible workaround is to define the following variable
in your environment:

```bash
_JAVA_OPTIONS='-Xverify:none'
```

Read more at these links:

- https://bugs.openjdk.java.net/browse/JDK-8051012
- https://jira.codehaus.org/browse/GROOVY-6951

Installing Docker
-------------------

G4500_workflow uses Docker which provides a way to run applications securely isolated in a container, packaged with all its dependencies and libraries, which is available through `Docker <https://docs.docker.com/docker-for-mac/install/>`_. 



