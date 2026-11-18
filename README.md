# practiquescloud

Repositori de pràctiques del mòdul **OPT: Cloud Computing** (ASIX2 · INS Provençana).
Aquest repositori conté la pràctica **Pt1.4**, formada per dos exercicis de
desplegament a AWS amb **Terraform**, i la pràctica **Pt2.2** (infraestructura bàsica
amb VPC, subxarxes públiques i dues instàncies EC2).

## Índex de pràctiques

| Pràctica | Exercici | Contingut |
|---|---|---|
| Pt1.4 | [Exercici 1](pt1-4-ex1/) | 2 instàncies EC2 `t3.micro` amb Amazon Linux 2023 a `us-east-1` |
| Pt1.4 | [Exercici 2](pt1-4-ex2/) | VPC `10.0.0.0/16`, 3 subxarxes a `us-east-1a` i 6 instàncies EC2 (consola + Terraform) |
| Pt2.2 | [Pràctica 2.2](pt2-2/) | VPC `VPC-03`, 2 subxarxes públiques a `us-east-1a/b`, IGW, SG i 2 instàncies `ec2-a`/`ec2-b` |

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
├── pt1-4-ex2/
│   ├── assets/
│   │   ├── topologia.png
│   │   ├── topologia.drawio
│   │   ├── vpc_subnets.png
│   │   ├── vpc_resum.png
│   │   ├── ec2_instances.png
│   │   ├── terraform_output.png
│   │   └── terraform_validate.png
│   ├── modules/
│   │   ├── network/
│   │   └── compute/
│   ├── README.md
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── terraform.tfvars.example
└── pt2-2/
    ├── assets/                 # instal·lació, CLI i captures de la consola AWS
    ├── README.md
    ├── main.tf
    ├── variables.tf
    ├── outputs.tf
    ├── terraform.tfvars.example
    └── .terraform.lock.hcl
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

# Pràctica 2.2
cd ../pt2-2
terraform init
terraform validate
terraform plan
terraform apply
terraform output

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
- `pt2-2/assets/instalacion.png` — versions de Terraform, AWS CLI i Git
- `pt2-2/assets/vpc_resum.png` — detall de `VPC-03` amb subxarxes, IGW i rutes
- `pt2-2/assets/vpc_subnets.png` — les dues subxarxes públiques
- `pt2-2/assets/route_table_routes.png` — ruta `0.0.0.0/0 → IGW`
- `pt2-2/assets/route_table_subnets.png` — associacions de les dues subxarxes
- `pt2-2/assets/security_group_inbound.png` / `security_group_outbound.png` — regles
- `pt2-2/assets/ec2_instances.png` — `ec2-a` i `ec2-b` en execució
- `pt2-2/assets/terraform_apply.png`, `terraform_output.png`, `terraform_state.png` — sortides reals

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
| Pt2.2 | 10 recursos (VPC, 2 subnets, IGW, RT + 2 associacions, SG, 2 EC2) | 2/2 `running` verificades i destruïdes el 18/11/2026 |

- Terraform `1.9.8` (Pt1.4) i `1.17.2` (Pt2.2)
- Provider `hashicorp/aws` `5.100.0` (Pt1.4) i `~> 5.0` (Pt2.2)
- Regió: `us-east-1`

Un cop capturades les evidències, tots els recursos es van **destruir** amb
`terraform destroy` (Pt1.4 el 05/11/2026 i Pt2.2 el 18/11/2026) per no consumir
crèdits del Learner Lab. Les captures dels README conserven la verificació del
desplegament real.
Els fitxers `terraform.tfstate` queden en local i no es pugen al repositori.

## Autor

**Aran Casals** · ASIX2 · INS Provençana · Curs 2026-2027
