# Portefaix Policies

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![](https://gitpolicies.com/portefaix-policies/charts/workflows/Release%20Charts/badge.svg?branch=master)](https://gitpolicies.com/portefaix-policies/charts/actions)
[![Artifact HUB](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/portefaix-policies)](https://artifacthub.io/packages/search?repo=portefaix-policies)

Policies for Portefaix project using :

* [Kubernetes Validating Admission Policies](https://kubernetes.io/docs/reference/access-authn-authz/validating-admission-policy/)
* [Open Policy Agent](https://www.openpolicyagent.org/)
* [Kyverno](https://kyverno.io/)
* [Kubewarden](https://www.kubewarden.io/)

| Policy | Kyverno | OPA | Kubewarden | Kubernetes (CEL) |
|--------|:-------:|:---:|:----------:|:-----------------------------:|
| `portefaix-C0001 - Container must not use latest image tag` | :white_check_mark: | :white_check_mark: | :x: | :white_check_mark: |
| `portefaix-C0002 - Container must set liveness probe` | :white_check_mark: | :white_check_mark: | :x: | :white_check_mark: |
| `portefaix-C0003 - Container must set readiness probe` | :white_check_mark: | :white_check_mark: | :x: | :white_check_mark: |
| `portefaix-C0004 - Container must mount secrets as volumes, not enviroment variables` | :white_check_mark: | :white_check_mark: | :x: | :x: |
| `portefaix-C0008 - Container resource constraints must be specified` | :white_check_mark: | :white_check_mark: | :x: | :white_check_mark: |
| `portefaix-M0001 - Metadata must set recommanded Kubernetes labels` | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |
| `portefaix-M0002 - Metadata should have a8r.io annotations` | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |
| `portefaix-M0003 - Metadata should have portefaix.xyz labels` | :white_check_mark: | :white_check_mark: | :x: | :white_check_mark: |
| `portefaix-N0001 - Disallow Default Namespace` | :white_check_mark: | :x: | :x: | :white_check_mark: |

## Documentation

* [OPA policies](https://github.com/nlamirault/portefaix-policies/tree/master/opa)
* [Kyverno policies](https://github.com/nlamirault/portefaix-policies/tree/master/kyverno)
* [Kubewarden policies](https://github.com/nlamirault/portefaix-policies/tree/master/kubewarden)
* [Kubernetes Validating Admission Policies](https://github.com/nlamirault/portefaix-policies/tree/master/cel)

## Contributing

See [CONTRIBUTING.md](./CONTRIBUTING.md)

## License

[Apache 2.0 License](./LICENSE)
