FROM quay.io/openshift/origin-jenkins-agent-base:4.1

EXPOSE 8080

ENV PYTHON_VERSION=3.6 \
    PATH=$HOME/.local/bin/:$PATH \
    PYTHONUNBUFFERED=1 \
    PYTHONIOENCODING=UTF-8 \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    PIP_NO_CACHE_DIR=off

ADD ubi.repo /etc/yum.repos.d/ubi.repo

RUN INSTALL_PKGS=" \
      rh-python36 rh-python36-python-devel rh-python36-python-setuptools rh-python36-python-wheel \
      rh-python36-python-pip nss_wrapper \
      httpd24 httpd24-httpd-devel httpd24-mod_ssl httpd24-mod_auth_kerb httpd24-mod_ldap \
      httpd24-mod_session atlas-devel gcc-gfortran libffi-devel libtool-ltdl enchant" && \
    TEST_PKGS="chromedriver https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm" && \
    DISABLE_REPOS=--disablerepo='rhel-*' && \
    yum $DISABLE_REPOS install -y yum-utils && \
    yum -y --setopt=tsflags=nodocs $DISABLE_REPOS install $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum -y --setopt=tsflags=nodocs $DISABLE_REPOS install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
    yum-config-manager --add-repo http://mirror.centos.org/centos/7.7.1908/os/x86_64/ && \
    yum -y --setopt=tsflags=nodocs $DISABLE_REPOS --nogpgcheck install $TEST_PKGS && \
    yum -y erase epel-release && \
    rm -f /etc/yum.repos.d/mirror* && \
    yum -y clean all --enablerepo='*' && \
    source scl_source enable rh-python36 && \
    scl enable rh-python36 bash && \
    python3 -m pip install twine robotframework selenium robotframework-seleniumlibrary robotframework-selenium2library 

ADD scl_enable /usr/share/container-scripts/
ENV BASH_ENV=/usr/share/container-scripts/scl_enable \
    ENV=/usr/share/container-scripts/scl_enable \
    PROMPT_COMMAND=". /usr/share/container-scripts/scl_enable"

USER 1001
