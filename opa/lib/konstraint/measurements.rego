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

package lib.measurements

# 10 ** 21
mem_multiple("E") = 1000000000000000000000

# 10 ** 18
mem_multiple("P") = 1000000000000000000

# 10 ** 15
mem_multiple("T") = 1000000000000000

# 10 ** 12
mem_multiple("G") = 1000000000000

# 10 ** 9
mem_multiple("M") = 1000000000

# 10 ** 6
mem_multiple("k") = 1000000

# 10 ** 3
mem_multiple("") = 1000

# Kubernetes accepts millibyte precision when it probably shouldn't.
# https://github.com/kubernetes/kubernetes/issues/28741
# 10 ** 0
mem_multiple("m") = 1

# 1000 * 2 ** 10
mem_multiple("Ki") = 1024000

# 1000 * 2 ** 20
mem_multiple("Mi") = 1048576000

# 1000 * 2 ** 30
mem_multiple("Gi") = 1073741824000

# 1000 * 2 ** 40
mem_multiple("Ti") = 1099511627776000

# 1000 * 2 ** 50
mem_multiple("Pi") = 1125899906842624000

# 1000 * 2 ** 60
mem_multiple("Ei") = 1152921504606846976000

get_suffix(mem) = suffix {
	not is_string(mem)
	suffix := ""
}

get_suffix(mem) = suffix {
	is_string(mem)
	count(mem) > 0
	suffix := substring(mem, count(mem) - 1, -1)
	mem_multiple(suffix)
}

get_suffix(mem) = suffix {
	is_string(mem)
	count(mem) > 1
	suffix := substring(mem, count(mem) - 2, -1)
	mem_multiple(suffix)
}

get_suffix(mem) = suffix {
	is_string(mem)
	count(mem) > 1
	not mem_multiple(substring(mem, count(mem) - 1, -1))
	not mem_multiple(substring(mem, count(mem) - 2, -1))
	suffix := ""
}

get_suffix(mem) = suffix {
	is_string(mem)
	count(mem) == 1
	not mem_multiple(substring(mem, count(mem) - 1, -1))
	suffix := ""
}

get_suffix(mem) = suffix {
	is_string(mem)
	count(mem) == 0
	suffix := ""
}

canonify_mem(orig) = new {
	is_number(orig)
	new := orig * 1000
}

canonify_mem(orig) = new {
	not is_number(orig)
	suffix := get_suffix(orig)
	raw := replace(orig, suffix, "")
	re_match("^[0-9]+$", raw)
	new := to_number(raw) * mem_multiple(suffix)
}

canonify_storage(orig) = new {
	is_number(orig)
	new := orig
}

canonify_storage(orig) = new {
	not is_number(orig)
	suffix := get_suffix(orig)
	raw := replace(orig, suffix, "")
	re_match("^[0-9]+$", raw)
	new := to_number(raw) * mem_multiple(suffix)
}

canonify_cpu(orig) = new {
	is_number(orig)
	new := orig * 1000
}

canonify_cpu(orig) = new {
	not is_number(orig)
	endswith(orig, "m")
	new := to_number(replace(orig, "m", ""))
}

canonify_cpu(orig) = new {
	not is_number(orig)
	not endswith(orig, "m")
	re_match("^[0-9]+$", orig)
	new := to_number(orig) * 1000
}
