FROM quay.io/openshift/origin-jenkins-agent-base:4.2

EXPOSE 8080

ENV PYTHON_VERSION=3.6 \
    PATH=$HOME/.local/bin/:$PATH \
    PYTHONUNBUFFERED=1 \
    PYTHONIOENCODING=UTF-8 \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    PIP_NO_CACHE_DIR=off \
    GECKO_VERSION=v0.26.0

ADD ubi.repo /etc/yum.repos.d/ubi.repo
ADD scl_enable /usr/share/container-scripts/

RUN INSTALL_PKGS=" \
      rh-python36 rh-python36-python-devel rh-python36-python-setuptools rh-python36-python-wheel \
      rh-python36-python-pip nss_wrapper \
      httpd24 httpd24-httpd-devel httpd24-mod_ssl httpd24-mod_auth_kerb httpd24-mod_ldap \
      httpd24-mod_session atlas-devel gcc-gfortran libffi-devel libtool-ltdl enchant" && \
    TEST_PKGS="chromedriver https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm firefox" && \
    DISABLE_REPOS=--disablerepo='rhel-*' && \
    yum $DISABLE_REPOS install -y yum-utils && \
    yum -y --setopt=tsflags=nodocs $DISABLE_REPOS install $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum -y --setopt=tsflags=nodocs $DISABLE_REPOS install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
    yum-config-manager --add-repo http://mirror.centos.org/centos/7.7.1908/os/x86_64/ && \
    yum -y --setopt=tsflags=nodocs $DISABLE_REPOS --nogpgcheck install $TEST_PKGS && \
    wget https://github.com/mozilla/geckodriver/releases/download/$GECKO_VERSION/geckodriver-$GECKO_VERSION-linux64.tar.gz && \
    tar -xf geckodriver-$GECKO_VERSION-linux64.tar.gz && \
    mv geckodriver /usr/local/bin && \
    rm -f geckodriver-$GECKO_VERSION-linux64.tar.gz && \
    echo 'test 1' && \
    yum -y erase epel-release && \
    echo 'test 2' && \
    rm -f /etc/yum.repos.d/mirror* && \
    echo 'test 3' && \
    yum -y clean all --enablerepo='*' && \
    echo 'test 4' && \
    source scl_source enable rh-python36 && \
    echo 'test 5' && \
    python3 -m pip install twine robotframework selenium robotframework-seleniumlibrary robotframework-selenium2library && \
    echo 'test 6' && \
    scl enable rh-python36 bash

ENV BASH_ENV=/usr/share/container-scripts/scl_enable \
    ENV=/usr/share/container-scripts/scl_enable \
    PROMPT_COMMAND=". /usr/share/container-scripts/scl_enable"

USER 1001
