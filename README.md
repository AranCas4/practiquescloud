# practiquescloud

Repositori de pràctiques del mòdul **OPT: Cloud Computing** (ASIX2 · INS Provençana).
Aquest repositori conté la pràctica **Pt1.4**, formada per dos exercicis de
desplegament a AWS amb **Terraform**.

## Índex de pràctiques

| Pràctica | Exercici | Contingut |
|---|---|---|
| Pt1.4 | [Exercici 1](pt1-4-ex1/) | 2 instàncies EC2 `t3.micro` amb Amazon Linux 2023 a `us-east-1` |
| Pt1.4 | [Exercici 2](pt1-4-ex2/) | VPC `10.0.0.0/16`, 3 subxarxes a `us-east-1a` i 6 instàncies EC2 (consola + Terraform) |

## Estructura del repositori

```
practiquescloud/
├── README.md
├── .gitignore
├── pt1-4-ex1/
│   ├── assets/
│   │   ├── topologia.png
│   │   ├── topologia.drawio
│   │   ├── terraform_output.png
│   │   └── terraform_validate.png
│   ├── README.md
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── terraform.tfvars.example
└── pt1-4-ex2/
    ├── assets/
    │   ├── topologia.png
    │   ├── topologia.drawio
    │   ├── vpc_subnets.png
    │   ├── vpc_resum.png
    │   ├── ec2_instances.png
    │   ├── terraform_output.png
    │   └── terraform_validate.png
    ├── modules/
    │   ├── network/
    │   └── compute/
    ├── README.md
    ├── main.tf
    ├── variables.tf
    ├── outputs.tf
    └── terraform.tfvars.example
```

## Requisits

- [Terraform](https://developer.hashicorp.com/terraform/downloads) >= 1.5
- Compte AWS o **AWS Academy Learner Lab** amb accés a `us-east-1`
- Key Pair `vockey` (inclòs a AWS Academy) o un altre Key Pair propi
- (Opcional) draw.io per editar els fitxers `.drawio`

## Credencials

Les credencials **no es guarden mai** al repositori. Amb AWS Academy:

```bash
export AWS_ACCESS_KEY_ID="ASIA..."
export AWS_SECRET_ACCESS_KEY="..."
export AWS_SESSION_TOKEN="..."
export AWS_DEFAULT_REGION="us-east-1"
```

Pots consultar-les a **AWS Academy → Learner Lab → AWS Details → AWS CLI → Show**.
Caduca aproximadament al cap de 4 hores; si veus `ExpiredToken`, torna a copiar-les.

## Execució ràpida

```bash
# Exercici 1
cd pt1-4-ex1
terraform init
terraform validate
terraform plan
terraform apply

# Exercici 2
cd ../pt1-4-ex2
terraform init
terraform validate
terraform plan
terraform apply

# Neteja (sempre en acabar)
terraform destroy
```

Cada exercici té el seu propi `README.md` amb el pas a pas, la topologia i les
instruccions detallades.

## Diagrames i captures

Els diagrames de topologia s'han dissenyat amb **draw.io** (icones oficials
AWS4) i s'exporten a PNG:

- `pt1-4-ex1/assets/topologia.png`
- `pt1-4-ex2/assets/topologia.png`
- `pt1-4-ex2/assets/vpc_subnets.png` — captura real de VPC → Subnets
- `pt1-4-ex2/assets/vpc_resum.png` — resum real de VPC, IGW i route table
- `pt1-4-ex2/assets/ec2_instances.png` — captura real de la consola AWS
- `pt1-4-ex1/assets/terraform_output.png` — sortida real de Terraform
- `pt1-4-ex2/assets/terraform_output.png` — sortida real de Terraform

Els fitxers `.drawio` es poden obrir i editar amb [draw.io](https://app.diagrams.net/).

## Estat de validació i desplegament

```text
$ terraform fmt -check -recursive     # OK
$ terraform validate                  # Success! The configuration is valid.
```

Desplegament real a `us-east-1` (05/11/2026):

| Exercici | Recursos | Estat verificat |
|---|---|---|
| Ex1 | 2 EC2 `t3.micro` + SG | `running`, `us-east-1a` |
| Ex2 | 16 recursos (VPC, 3 subnets, IGW, RT, SG, 6 EC2) | 6/6 `running`, `us-east-1a` |

- Terraform `1.9.8`
- Provider `hashicorp/aws` `5.100.0`
- Regió: `us-east-1`

Un cop capturades les evidències, els recursos es van **destruir** amb
`terraform destroy` (05/11/2026) per no consumir crèdits del Learner Lab.
Els fitxers `terraform.tfstate` queden en local i no es pugen al repositori.

## Autor

**Aran Casals** · ASIX2 · INS Provençana · Curs 2026-2027
