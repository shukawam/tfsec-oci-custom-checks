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
$ tfsec --var-file variables.tfvars
Result #1 CRITICAL Custom check failed for resource oci_objectstorage_bucket.object-storage-1. Bucket is public 
─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  main.tf:1-6
─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
    1    resource "oci_objectstorage_bucket" "object-storage-1" {
    2      compartment_id = var.compartment_ocid
    3      name           = var.object_storage_bucket_name
    4      namespace      = var.object_storage_namespace
    5      access_type    = "ObjectRead" # OCI-00002
    6    }
─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
          ID custom-custom-oci-00002
      Impact Anonymous access to content is available
  Resolution Set visibility to "NoPublicAccess"

─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────


Result #2 CRITICAL Custom check failed for resource oci_objectstorage_bucket.object-storage-1. Bucket is public 
─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  main.tf:8-13
─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
    8    resource "oci_objectstorage_bucket" "object-storage-1" {
    9      compartment_id = var.compartment_ocid
   10      name           = var.object_storage_bucket_name
   11      namespace      = var.object_storage_namespace
   12      access_type    = "ObjectReadWithoutList" # OCI-00002
   13    }
─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
          ID custom-custom-oci-00002
      Impact Anonymous access to content is available
  Resolution Set visibility to "NoPublicAccess"

─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────


  timings
  ──────────────────────────────────────────
  disk i/o             22.784µs
  parsing              256.274µs
  adaptation           75.753µs
  checks               11.193447ms
  total                11.548258ms

  counts
  ──────────────────────────────────────────
  modules downloaded   0
  modules processed    1
  blocks processed     8
  files read           3

  results
  ──────────────────────────────────────────
  passed               3
  ignored              0
  critical             2
  high                 0
  medium               0
  low                  0

  3 passed, 2 potential problem(s) detected.
```
