#!/bin/bash

docker kill openldap 2>/dev/null
docker run --rm --name openldap -d -p 389:389 osixia/openldap:1.2.2
if [ $? -ne 0 ]; then
    echo "Error on running the OpenLDAP Docker image."
    exit 1
fi

until ldapsearch -x -b dc=example,dc=org -D cn=admin,dc=example,dc=org -w admin | grep "dn: dc=example,dc=org"
do
    echo "OpenLDAP is not ready yet - sleeping 2s"
    sleep 2
done

ansible-playbook test.yml -e "ansible_python_interpreter=$(which python3)"

./validate.sh
