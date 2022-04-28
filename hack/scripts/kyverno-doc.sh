#!/bin/bash

# Copyright (C) 2021 Nicolas Lamirault <nicolas.lamirault@gmail.com>
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

set -euo pipefail

reset_color="\\e[0m"
color_red="\\e[31m"
color_green="\\e[32m"
color_blue="\\e[36m";

function echo_fail { echo -e "${color_red}✖ $*${reset_color}"; }
function echo_success { echo -e "${color_green}✔ $*${reset_color}"; }
function echo_info { echo -e "${color_blue}$*${reset_color}"; }

POLICIES_DIR="kyverno"
DOC="kyverno-policies.md"

STARTFLAG="<!-- BEGIN_POLICIES_DOC -->"
ENDFLAG="<!-- END_POLICIES_DOC -->"

IFS="
"

function usage() {
    echo "usage: $0"
}

function policy_doc() {
    local policy=$1
    local tmpfile=$2

    # echo ${policy}
    for file in $(ls "${POLICIES_DIR}/${policy}"); do
        if [[ "${file}" =~ "policy" ]]; then
            name=$(yq '.metadata.name' < "${POLICIES_DIR}/${policy}/${file}")
            title=$(yq '.metadata.annotations["policies.kyverno.io/title"]' < "${POLICIES_DIR}/${policy}/${file}")
            severity=$(yq '.metadata.annotations["policies.kyverno.io/severity"]' < "${POLICIES_DIR}/${policy}/${file}")
            # description=$(yq '.metadata.annotations["policies.kyverno.io/title"]' < "${POLICIES_DIR}/${policy}/${file}")
            echo "| [${name} - ${title}](${POLICIES_DIR}/${policy}) | **${severity}** |" >> ${tmpfile}
        fi
    done
    # jsonnetfile="${MIXINS_DIR}/${mixin}/jsonnetfile.json"
    # if [ ! -f "${jsonnetfile}" ]; then
    #     echo -e "${KO_COLOR}[monitoring-mixins] Jsonnet not found: ${jsonnetfile} ${NO_COLOR}"
    # else
    #     echo -e "${INFO_COLOR}[monitoring-mixins] ${mixin} ${NO_COLOR}"
    #     deps=$(jq '.dependencies[] | "\(.source.git.remote) \(.version)"' ${jsonnetfile} | tr '\n' ';')
    #     IFS=';'
    #     read -ra data <<< "${deps}"
    #     echo -n "| ${mixin} | " >> ${tmpfile}
    #     for i in "${data[@]}"; do
    #         git=$(echo ${i} | sed -e 's/"//g' | awk -F" " '{ print $1 }')
    #         version=$(echo ${i} | sed -e 's/"//g' | awk -F" " '{ print $2 }')
    #         echo -n "${git} - \`${version}\` <br> " >> ${tmpfile}
    #     done
    #     echo "|" >> ${tmpfile}
    # fi
}

echo_info "[kyverno-policies] Extract documentation"

tmpfile=$(mktemp)
START=false

while read LINE; do
    if [ "${START}" == "true" ]; then
        for policy in $(ls "${POLICIES_DIR}" | sort ); do
            policy_doc "${policy}" "${tmpfile}"
        done
        break
    elif [ "${LINE}" == "${STARTFLAG}" ]; then
            START="true"
            echo "${STARTFLAG}" >> "${tmpfile}"
            echo "| Policy | Severity |" >> ${tmpfile}
            echo "|--------|:--------:|" >> ${tmpfile}
            continue
    else
        echo "${LINE}" >> "${tmpfile}"
    fi
done < ${DOC}

echo "${ENDFLAG}" >> "${tmpfile}"
cat "${tmpfile}"
mv "${tmpfile}" "${DOC}"