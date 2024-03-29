# Copyright (C) Nicolas Lamirault <nicolas.lamirault@gmail.com>
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
#
# SPDX-License-Identifier: Apache-2.0

package pod_host_network

test_hostnetwork_false {
	pod := {
		"kind": "Pod",
		"metadata": {"name": "test-pod"},
		"spec": {"hostNetwork": false},
	}

	not pod_host_network(pod)
}

test_hostnetwork_true {
	pod := {
		"kind": "Pod",
		"metadata": {"name": "test-pod"},
		"spec": {"hostNetwork": true},
	}

	pod_host_network(pod)
}
