#!/usr/bin/env bash
###############################################################################
# Copyright 2016 Intuit
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
###############################################################################

profile_default=${WASABI_PROFILE}
build_default=false
test_default=false

usage() {
  [ "$1" ] && echo "error: ${1}"

  cat << EOF

usage: `basename ${0}` [options]

options:
  -b | --build [ true | false ]  : build; default: ${build_default}
  -p | --profile [profile]       : build profile; default: ${profile_default}
  -t | --test [ true | false ]   : test; default: ${test_default}
  -h | --help                    : help message
EOF

  exit ${2:-0}
}

fromPom() {
  mvn ${WASABI_MAVEN} -f $1/pom.xml -P$2 help:evaluate -Dexpression=$3 -B \
    -Dorg.slf4j.simpleLogger.log.org.apache.maven.cli.transfer.Slf4jMavenTransferListener=error | \
    sed -n -e '/^\[.*\]/ !{ p; }'
}

optspec=":p:b:t:h-:"

while getopts "${optspec}" opt; do
  case "${opt}" in
    -)
      case "${OPTARG}" in
        profile) profile="${!OPTIND}"; OPTIND=$(( ${OPTIND} + 1 ));;
        profile=*) profile="${OPTARG#*=}";;
        build) build="${!OPTIND}"; OPTIND=$(( ${OPTIND} + 1 ));;
        build=*) build="${OPTARG#*=}";;
        test) test="${!OPTIND}"; OPTIND=$(( ${OPTIND} + 1 ));;
        test=*) test="${OPTARG#*=}";;
        help) usage;;
        *) [ "${OPTERR}" = 1 ] && [ "${optspec:0:1}" != ":" ] && echo "unknown option --${OPTARG}";;
      esac;;
    p) profile=${OPTARG};;
    b) build=${OPTARG};;
    t) test=${OPTARG};;
    h) usage;;
    :) usage "option -${OPTARG} requires an argument" 1;;
    \?) [ "${OPTERR}" != 1 ] || [ "${optspec:0:1}" = ":" ] && usage "unknown option -${OPTARG}" 1;;
  esac
done

profile=${profile:=${profile_default}}
test=${test:=${test_default}}
module=main

artifact=$(fromPom ./modules/${module} ${profile} project.artifactId)
version=$(fromPom . ${profile} project.version)
home=./modules/${module}/target
id=${artifact}-${version}-${profile}

/bin/rm -rf ${home}/${id}
mkdir -p ${home}/${id}/bin ${home}/${id}/conf ${home}/${id}/lib ${home}/${id}/logs

content=${home}/${id}/content/ui/dist

mkdir -p ${content}
cp -R ./modules/ui/dist/* ${content}
mkdir -p ${content}/swagger/swaggerjson
cp -R ./modules/swagger-ui/target/swaggerui/ ${content}/swagger
cp -R ./modules/api/target/generated/swagger-ui/swagger.json ${content}/swagger/swaggerjson
exit 0
