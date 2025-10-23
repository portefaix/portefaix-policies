#!/bin/bash
# SPDX-FileCopyrightText: Copyright (C) Nicolas Lamirault <nicolas.lamirault@gmail.com>
# SPDX-License-Identifier: Apache-2.0


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
            echo "| [${name} - ${title}](${POLICIES_DIR}/${policy}) | \`${severity}\` |" >> ${tmpfile}
        fi
    done
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