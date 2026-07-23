# DevOps + AIOps Playbook

> An end-to-end DevOps project with AIOps integration, built as a hands-on portfolio piece connecting how AI assists modern DevOps workflows.

---

## About this project

This is my own DevOps/Cloud engineering portfolio project — an end-to-end system I built to practice and demonstrate:

- Building microservices locally
- Using Claude and AI tools to assist development
- Deploying everything step by step
- Migrating the system to the cloud on AWS EKS
- Setting up a full CI/CD pipeline with GitHub Actions
- Implementing GitOps workflows with ArgoCD
- Integrating AIOps capabilities with AWS Bedrock

The goal isn't just knowing the tools — it's understanding how real DevOps systems are designed, deployed, and debugged when they inevitably break.

---

## Repository Structure

```
devops-ai-playbook/
├── docs/
│   ├── part1-system-design.md     # System design foundations (Part 1)
│   ├── part2-workflow.md          # Full workflow with AIOps (Part 2)
│   └── claude-setup.md            # Claude Code + MCP server setup
├── projects/
│   ├── README.md                  # EKS deployment guide (Part 3)
│   ├── boutique-microservices/    # The application (7 services)
│   ├── Infrastructure/            # Terraform for AWS provisioning
│   └── aiops-assistant/           # Bedrock Agent — Kira (Part 4)
├── gitops/
│   ├── argo-cd.yml                # ArgoCD Application manifest
│   ├── kustomization.yml          # Kustomize entry point
│   └── k8s/                       # All Kubernetes manifests
└── .github/
    └── workflows/ci.yml           # GitHub Actions CI pipeline
```

---

## Project Structure Walkthrough

### Claude Setup — AI Assistant Configuration
[`docs/claude-setup.md`](docs/claude-setup.md)

Before jumping into the project, this step walks through how Claude Code is configured as the AI assistant throughout this project.

Three things are set up:

**CLAUDE.md** — a project instruction file at the repo root that Claude reads automatically at the start of every session. It puts Claude in safe execution mode: explain what you're about to do and why before taking any action. This is important when working with live AWS infrastructure where silent commands can have real consequences.

**MCP Servers** — background processes that extend Claude's built-in capabilities. Four servers are configured in `~/.claude/settings.json`:

| Server | What it unlocks |
|--------|----------------|
| `awslabs.eks-mcp-server` | Query EKS clusters, inspect pods, stream logs, apply manifests |
| `awslabs.terraform-mcp-server` | Run Terraform commands, search provider docs, run Checkov scans |
| `awslabs.aws-pricing-mcp-server` | Live AWS pricing lookups and cost analysis reports |
| `awslabs.core-mcp-server` | MCP orchestration layer (deprecated, kept for compatibility) |

**Skills** — domain-specific knowledge packs that improve how Claude reasons about certain topics. The `terraform-skill` is installed, giving Claude deeper context for Terraform module patterns, testing strategies, security scanning, and CI/CD workflows specific to infrastructure-as-code.

---

### Part 1 — System Design Foundations
[`docs/part1-system-design.md`](docs/part1-system-design.md)

We start with system design concepts specifically for cloud and DevOps. This is important whether you're a beginner, intermediate, or senior engineer — because companies don't choose tools randomly. They think about architecture patterns, deployment strategies, scalability, reliability, and cost tradeoffs.

We cover 12 core system design pillars used in modern DevOps architectures, and connect each one directly to something running in this project.

---

### Part 2 — Understanding the Workflow
[`docs/part2-workflow.md`](docs/part2-workflow.md)

Before writing any code or deployment configs, you need to understand how the entire system flows:

- What services we're building and how they communicate
- How the pipeline works
- How code moves from developer → CI → deployment → production → AIOps

This is where the full picture comes together — including how AI fits into the workflow.

---

### Part 3 — DevOps Project Implementation
[`projects/README.md`](projects/README.md)

Then we actually build the project. You'll see:

- Docker containers and Docker Compose
- Kubernetes deployments on EKS
- CI/CD pipelines with GitHub Actions
- GitOps automation with ArgoCD
- Infrastructure provisioning with Terraform
- Observability with Prometheus and Grafana

---

### Part 4 — AIOps Integration
[`projects/aiops-assistant/README.md`](projects/aiops-assistant/README.md)

Finally, this part explores how AI helps with:

- Monitoring and anomaly detection
- Log analysis at scale
- Incident response automation
- DevOps troubleshooting

Because modern DevOps is no longer just automation — it's **automation + intelligence**.

---

## Deliberate Troubleshooting Practice

Part of the point of this project is to not just have it work on the first try. A number of intentional issues and gaps were left in along the way — broken CI credentials, unfilled config placeholders, misconfigured trust policies, missing GitOps sync settings — specifically so that debugging them (reading logs, checking CloudTrail, tracing root causes) is part of the exercise, not something to route around with AI. Real DevOps skill comes from breaking systems, debugging systems, and fixing systems, not just following steps that already work.

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Application | React, Node.js, PostgreSQL |
| Containers | Docker, Docker Compose |
| Orchestration | Kubernetes (AWS EKS) |
| Infrastructure | Terraform |
| CI/CD | GitHub Actions |
| GitOps | ArgoCD + Kustomize |
| Monitoring | Prometheus + Grafana |
| Log Forwarding | AWS Fluent Bit → CloudWatch |
| AIOps | AWS Bedrock Agent (Kira) |
| AI Assistant | Claude Code + MCP Servers |
