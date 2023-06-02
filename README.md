# tfsec-oci-custom-checks

Tfsec custom checks rule for oci based on OCI based on Cloud Guard responder recipe.

## how to use

Set `oci_tfchecks.yaml` to your `.tfsec` directory under Terraform root module.

```bash
.
├── .tfsec
│   └── oci_tfchecks.yaml # here
├── README.md
├── main.tf
├── outputs.tf
├── providers.tf
└── variables.tf
```

Execute tfsec.

```bash
tfsec
```
