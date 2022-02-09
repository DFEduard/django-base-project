#!/usr/bin/env bash

# SETTINGS
DOCKER_VERSION_REQUIRED="20.10.8"
DOCKER_COMPOSE_VERSION_REQUIRED="1.29.2"
PYTHON_VERSION="3.8.2"
PIPENV_VERSION="2021.5.29"


# TEXT COLOR
T_RED="\e[1;31m"
T_GREEN="\e[1;32m"
T_YELLOW="\e[1;33m"
T_BLUE="\e[1;34m"
T_MAGENTA="\e[1;35m"
T_CYAN="\e[1;36m"
T_END="\e[0m"

# FORMAT TEXT
T_BOLD="\e[1m"
INFO="${T_BOLD}[INFO]😉: ${T_END}"
WARN="${T_YELLOW}[WARN]😱: ${T_END}"
INFO_LINE="======>"

printf "${T_BLUE}|==============================================|${T_END}\n"
printf "${T_BLUE}|${T_END}${T_BOLD}               DOCKER SETUP                   ${T_END}${T_BLUE}|${T_END}\n"
printf "${T_BLUE}|==============================================|${T_END}\n"

# This is used for the IF1-START 
DOCKER_INSTALLED=$(docker -v)

# IF1-START
if [[ $? -eq 0 ]]; then

    printf "${INFO}Docker is installed\n"

    # Get docker version installed
    DOCKER_VERSION=$(docker version --format '{{.Server.Version}}' | egrep -o "^[0-9]+\.[0-9]+\.[0-9]+" )

    # IF2-START
    # Check if docker version installed is less than the version required 
    if [[ ${DOCKER_VERSION} < ${DOCKER_VERSION_REQUIRED} ]]; then
        printf "${WARN}Version of Docker installed ${T_RED}(${DOCKER_VERSION}) ${T_END}is out of date\n"
        printf "${INFO_LINE} Please upgrade docker to a version bigger than ${T_GREEN}(${DOCKER_VERSION_REQUIRED})${T_END}\n"
        printf "${INFO_LINE} After you finish upgrading the docker version, run again this script!👌\n"
        exit 1
    else
        # Get docker-compose version installed
        DOCKER_COMPOSE_INSTALLED=$(docker-compose -v)
        # IF3-START
        # Check response - 0 means that docker-compose exists in the system
        if [[ $? -eq 0 ]]; then
            printf "${INFO}Docker-compose is installed\n"

            #Get docker-compose version number
            DOCKER_COMPOSE_VERSION=$(docker-compose version --short | egrep -o "^[0-9]+\.[0-9]+\.[0-9]+" )
            # IF4-START
            # Check if current docker-compose installed is less that the version required
            if [[ ${DOCKER_COMPOSE_VERSION} < ${DOCKER_COMPOSE_VERSION_REQUIRED} ]]; then
                printf "${WARN}Version of Docker-compose installed ${T_RED}(${DOCKER_COMPOSE_VERSION}) ${T_END}is out of date\n"
                printf "${INFO_LINE} Please upgrade docker-compose to a version bigger than ${T_GREEN}(${DOCKER_COMPOSE_VERSION_REQUIRED})${T_END}\n"
                printf "${INFO_LINE} After you finish upgrading the docker-compose version, run again this script!\n"
            fi 
            # IF4-END

        else
            printf "${WARN}Docker-compose is not installed\n"
            printf "${WARN}Install docker-compose on your machine\n"
        fi 
        # IF3-END 
    fi 
    # IF2-END
else
    printf "${WARN}Docker is not installed\n"
    printf "${WARN}Install docker on your machine\n"
fi 
# IF1-END

printf "${T_CYAN}|==============================================|${T_END}\n"
printf "${T_CYAN}|${T_END}${T_BOLD}               PROJECT SETUP                  ${T_END}${T_CYAN}|${T_END}\n"
printf "${T_CYAN}|==============================================|${T_END}\n"

printf "${INFO_LINE}${BOLD}Give a name to your project${T_END}\n"

# Placeholder in files
FILE_PLACEHOLDER="replacewithprojectname"

# files/directories to be checked
DOCKER_DIR="docker"
DJANGO_DIR="django"
NGINX_DIR="nginx"
DOCKERFILE="Dockerfile"
ENTRYPOINT_FILE="entrypoint.sh"
NGINX_CONF="default.conf"
DOCKER_COMPOSE="docker-compose.yml"
DO_DJ_DIR="${DOCKER_DIR}/${DJANGO_DIR}"
DO_NG_DIR="${DOCKER_DIR}/${NGINX_DIR}"

# Check docker files

# IFD1-START
if [[ -d ${DOCKER_DIR} ]]; then
    printf "${INFO}${T_GREEN}${DOCKER_DIR}${T_END} directory found! ${T_END}\n"
    # IFDJ1-START
    if [[ -d ${DO_DJ_DIR} ]]; then 
        printf "${INFO}${T_GREEN}${DJANGO_DIR}${T_END} directory found in ${T_GREEN}${DOCKER_DIR}${T_END} directory! ${T_END}\n"

        # IFDJ2-START
        if [[ -f "${DO_DJ_DIR}/${DOCKERFILE}" ]]; then
            printf "${INFO}${T_GREEN}${DOCKERFILE}${T_END} found in ${T_GREEN}${DO_DJ_DIR}!${T_END}\n"
        else
            printf "${WARN}${DOCKERFILE} could not be found in ${DO_DJ_DIR}!${T_END}\n"
            exit 1
        fi # IFDJ2-END

        # IFDJ3-START
        if [[ -f "${DO_DJ_DIR}/${ENTRYPOINT_FILE}" ]]; then
            printf "${INFO}${T_GREEN}${ENTRYPOINT_FILE}${T_END} found in ${T_GREEN}${DO_DJ_DIR}!${T_END}\n"
        else
            printf "${WARN}${ENTRYPOINT_FILE} could not be found!.${T_END}\n"
            exit 1
        fi # IFDJ3-END

    else
        printf "${WARN}${DOCKER_FOLDER} doesn't exist.${T_END}\n"
        exit 1
    fi # IFDJ1-END

    # IFDN1-START
    if [[ -d ${DO_NG_DIR} ]]; then
        printf "${INFO}${T_GREEN}${NGINX_DIR}${T_END} directory found in ${T_GREEN}${DOCKER_DIR} directory! ${T_END}\n"

        # IFDN2-START
        if [[ -f "${DO_NG_DIR}/${DOCKERFILE}" ]]; then
            printf "${INFO}${T_GREEN}${DOCKERFILE}${T_END} found in ${T_GREEN}${DO_NG_DIR}!${T_END}\n"
        else
            printf "${WARN}${DOCKERFILE} could not be found in ${DO_NG_DIR}/${DOCKERFILE}!${T_END}\n"
            exit 1
        fi # IFDN2-END

        # IFDN3-START
        if [[ -f "${DO_NG_DIR}/${NGINX_CONF}" ]]; then
            printf "${INFO}${T_GREEN}${NGINX_CONF}${T_END} found in ${T_GREEN}${DO_NG_DIR}!${T_END}\n"
        else
            printf "${WARN}${NGINX_CONF} could not be found in ${DO_NG_DIR}/${DOCKERFILE}!${T_END}\n"
            exit 1
        fi # IFDN3-END

    else
        printf "${WARN}${DO_NG_DIR} doesn't exist.${T_END}\n"
        exit 1
    fi # IFDN1-END

else
    printf "${WARN}${DOCKER_FOLDER} doesn't exist. You must run this script from the same place where docker folder is 
    or add docker folder${T_END}\n"
    exit 1
fi # IFD1-END

if [[ -f ${DOCKER_COMPOSE} ]]; then
    printf "${INFO}${T_GREEN}${DOCKER_COMPOSE}${T_END} file found in current directory! ${T_END}\n"
else
    printf "${WARN}${DOCKER_COMPOSE} file doesn't exist. You need ${DOCKER_COMPOSE} file to build up the base project${T_END}\n"
    exit 1
fi


# User input to give the project a name
read -p 'Project name: ' project_name

function replace_placeholder() {
    # parameters
    file_path=$1
    placeholder=$FILE_PLACEHOLDER

    if ! [[ -z $file_path ]]; then
        printf "${INFO_LINE} Replace placeholders in ${T_MAGENTA}(${file_path})${T_END} with project name ${T_MAGENTA}(${project_name})${T_END}\n"
        find ${file_path} -type f | xargs sed -i "" "s/${placeholder}/${project_name}/g"
    else
        printf "${WARN} File path is missing ${T_END}\n"
    fi

}

# replace_placeholder "${DO_DJ_DIR}/${DOCKERFILE}"
# replace_placeholder "${DO_DJ_DIR}/${ENTRYPOINT_FILE}"


printf "${T_CYAN}|==============================================|${T_END}\n"
printf "${T_CYAN}|${T_END}${T_BOLD}           CREATING .env FILES                ${T_END}${T_CYAN}|${T_END}\n"
printf "${T_CYAN}|==============================================|${T_END}\n"

# Function that creat secret key for django project 
# $1 is first param. e.g. django_secret_key 50 where 50 is $1
function django_secret_key() {
    length=40
    if ! [[ -z $1 ]]; then
        length=$1
    fi
    # Run python commands to create and print the random string 
    # The result can be saved into a variable and used for other purposes
    python -c "import string,random; r_code=string.ascii_lowercase+string.digits+string.punctuation; print(''.join(random.choice(r_code) for i in range(${length})) )"
}

# Function that creats random strings 
# $1 is first param. e.g. random_strings 20 where 20 is $1
function random_strings() {
    length=20
    if ! [[ -z $1 ]]; then
        length=$1
    fi
    # Run python commands to create and print the random string 
    # The result can be saved into a variable and used for other purposes
    python -c "import string,random; r_code=string.ascii_lowercase+string.digits; print(''.join(random.choice(r_code) for i in range(${length})) )"
}



REPLACING_PLACEHOLDER="replaceprojectname"
PROJECT_FOLDER="src"
PROJECT_DIR="${PROJECT_FOLDER}/${project_name}"

PGDB_PASSWORD=$(random_strings 10)
DJANGO_SU_PASSWORD=$(random_strings 15)
DJANGO_SECRET_KEY=$(django_secret_key)

printf "${INFO_LINE}Creating ${T_GREEN}.env${T_END} file\n"
echo "
PROJECT=${project_name}
PGDB_NAME=postgresdb
PGDB_USERNAME=postgresdb
PGDB_PASSWORD=${PGDB_PASSWORD}
DJANGO_SU_EMAIL=admin@example.com
DJANGO_SU_NAME=admin
DJANGO_SU_PASSWORD=${DJANGO_SU_PASSWORD}
DJANGO_DEBUG=True
DJANGO_SECRET_KEY=${DJANGO_SECRET_KEY}
" > .env
printf "${INFO_LINE}${T_GREEN}.env${T_END} file created!\n"

printf "${INFO_LINE}Creating ${T_GREEN}.database.env${T_END} file\n"
echo "
POSTGRES_USER=django
POSTGRES_PASSWORD=${PGDB_PASSWORD}
POSTGRES_DB=${project_name}
" > .database.env
printf "${INFO_LINE}${T_GREEN}.database.env${T_END} file created!\n"

printf "${INFO_LINE}Checking project src directory${T_END}\n"

if [[ -d ${PROJECT_FOLDER}/${REPLACING_PLACEHOLDER} ]]; then

    printf "${INFO}${T_GREEN}${PROJECT_FOLDER}${T_END} directory found! ${T_END}\n"
    printf "${INFO_LINE}Rename the project folder${T_END}\n"
    mv ${PROJECT_FOLDER}/${REPLACING_PLACEHOLDER} ${PROJECT_FOLDER}/${project_name}
    printf "${INFO_LINE} Replacing ${REPLACING_PLACEHOLDER} with ${project_name} in ${PROJECT_DIR}/asgi.py\n"
    replace_placeholder "${PROJECT_DIR}/asgi.py"
    printf "${INFO_LINE} Replacing ${REPLACING_PLACEHOLDER} with ${project_name} in ${PROJECT_DIR}/settings.py\n"
    replace_placeholder "${PROJECT_DIR}/settings.py"
    printf "${INFO_LINE} Replacing ${REPLACING_PLACEHOLDER} with ${project_name} in ${PROJECT_DIR}/wsgi.py\n"
    replace_placeholder "${PROJECT_DIR}/wsgi.py"
    printf "${INFO_LINE} Replacing ${REPLACING_PLACEHOLDER} with ${project_name} in ${PROJECT_DIR}/celery.py\n"
    replace_placeholder "${PROJECT_DIR}/celery.py"
    printf "${INFO_LINE} Replacing ${REPLACING_PLACEHOLDER} with ${project_name} in ${PROJECT_FOLDER}/tasks.py\n"
    replace_placeholder "${PROJECT_FOLDER}/tasks.py"

    if [[ -f ${PROJECT_FOLDER}/manage.py ]]; then
        replace_placeholder "${PROJECT_FOLDER}/manage.py"
    else
        printf "${INFO_LINE} manage.py couldn't be found!"
        exit 1
    fi
else
    printf "${WARN}${PROJECT_FOLDER}/${REPLACING_PLACEHOLDER} directory doesn't exist. You need ${PROJECT_FOLDER}/${REPLACING_PLACEHOLDER}  to build up the base project${T_END}\n"
fi




