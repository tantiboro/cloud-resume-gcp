# Google Cloud Resume Challenge 🚀
### Tantiboro Ouattara, Ph.D. | Scientist & Data Engineer

This project is a full-stack, serverless implementation of the Cloud Resume Challenge, hosted on **Google Cloud Platform (GCP)**. It demonstrates the intersection of **Materials Science**, **Advanced Analytics**, and **Cloud Infrastructure**.

## 🏗️ Architecture
* **Frontend**: Hosted on GCS, served via **Global HTTPS Load Balancer** & **Cloud CDN**.
* **Backend**: **Cloud Function (2nd Gen)** built with Python.
* **Database**: **Cloud Firestore** for atomic visitor tracking.
* **IaC/DevOps**: **Terraform** for provisioning and **Cloud Build** for CI/CD.

## 🔬 Featured Projects
* **Electro-Insight**: Chemometrics dashboard using LSTM/CNN to predict battery cycle life.
* **Kiva Analysis**: Geospatial clustering and poverty score estimation for global microloans.
* **Data Analytics Dashboard**: Full-stack personal finance tracker with automated ingestion.

## 🧬 Skills Matrix: Research to Engineering
| Scientific Domain | Core Skill | Cloud Alignment |
| :--- | :--- | :--- |
| Data Acquisition | FTIR & Polymer Analytics | Automated Ingestion & Data Lakes |
| Modeling | Performance Forecasting | MLOps & Machine Learning Pipelines |
| System Design | Experimental Design | Infrastructure as Code (Terraform) |

## 🚦 CI/CD Logic
1. **Unit Testing**: Pytest validates backend logic using mocks.
2. **IaC**: Terraform synchronizes cloud state.
3. **Deployment**: Automatic sync to GCS and Cloud Run (Functions) upon successful test completion.

---
**Live Site**: [tantiboro.com](https://tantiboro.com)

