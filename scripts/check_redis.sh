#!/bin/bash

# 
# This scripts dumps useful info about our redis-cluster
#

# Let's check if health is OK 
check_status()
{
    _VirtualMachine=$1
    _NetPort=$2

    echo "Checking if port $_NetPort is alive...\n"
    sleep 3s
    nc -zv $_VirtualMachine $_NetPort
    RET=$?
    if [ "${RET}" -ne 0 ]
    then
        echo "Port $_NetPort down on $_VirtualMachine!"
        exit 1
    else
        echo "Port $_NetPort up and running on $_VirtualMachine"
        return 0
    fi
} 

# Get some info
get_redis_info()
{
    _VirtualMachine=$1
    _NetPort=$2

    echo "redis-cli -c -h ${_VirtualMachine} -p ${_NetPort} info:"
    redis-cli -c -h ${_VirtualMachine} -p ${_NetPort} info

    echo "redis-cli -c -h ${_VirtualMachine} -p ${_NetPort} info server:"
    redis-cli -c -h ${_VirtualMachine} -p ${_NetPort} info server

    echo "redis-cli -c -h ${_VirtualMachine} -p ${_NetPort} info clients:"
    redis-cli -c -h ${_VirtualMachine} -p ${_NetPort} info clients

    echo "redis-cli -c -h ${_VirtualMachine} -p ${_NetPort} info memory:"
    redis-cli -c -h ${_VirtualMachine} -p ${_NetPort} info memory

    echo "redis-cli -c -h ${_VirtualMachine} -p ${_NetPort} info persistence:"
    redis-cli -c -h ${_VirtualMachine} -p ${_NetPort} info persistence

    echo "redis-cli -c -h ${_VirtualMachine} -p ${_NetPort} info stats:"
    redis-cli -c -h ${_VirtualMachine} -p ${_NetPort} info stats

    echo "redis-cli -c -h ${_VirtualMachine} -p ${_NetPort} info replication:"
    redis-cli -c -h ${_VirtualMachine} -p ${_NetPort} info replication

    echo "redis-cli -c -h ${_VirtualMachine} -p ${_NetPort} info cpu:"
    redis-cli -c -h ${_VirtualMachine} -p ${_NetPort} info cpu

    echo "redis-cli -c -h ${_VirtualMachine} -p ${_NetPort} info cluster:"
    redis-cli -c -h ${_VirtualMachine} -p ${_NetPort} info cluster

    echo "redis-cli -c -h ${_VirtualMachine} -p ${_NetPort} info keyspace:"
    redis-cli -c -h ${_VirtualMachine} -p ${_NetPort} info keyspace

    return 0
}

###################################################
###############  MAIN   ###########################
###################################################

MASTER_SERVER=$1 
MASTER_PORT=$2 

if (check_status ${MASTER_SERVER} ${MASTER_PORT})
then
    echo "Dumping node info"
    get_redis_info ${MASTER_SERVER} ${MASTER_PORT} > /vagrant/debug/redis_node_${MASTER_SERVER}_${MASTER_PORT}
    exit 0
else 
    exit 1
fi

