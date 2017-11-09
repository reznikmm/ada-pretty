function linux_before_install()
{
    cp -r packages/travis /tmp/
    cd ..
    tar --exclude=.git \
        -c -z -f /tmp/travis/ada-pretty.tar.gz ada-pretty
    docker build --tag ada-pretty /tmp/travis/
}

function linux_script()
{
    umask og+w
    mkdir upload
    docker run -i -t -v$(pwd)/upload:/upload --user=max ada-pretty \
           /bin/bash -c \
           'rpmbuild -bb /src/ada-pretty.spec --define "_rpmdir /upload"'

}

${TRAVIS_OS_NAME}_$1
