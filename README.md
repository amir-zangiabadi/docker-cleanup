# 🚀 docker-cleanup

🧹 **Automated Docker cleanup script with reporting**

---
[![Bash](https://img.shields.io/badge/Language-Bash-blue?logo=gnu-bash)](https://github.com/amir-zangiabadi/docker-cleanup)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![GitHub issues](https://img.shields.io/github/issues/amir-zangiabadi/ansible-create-playbook-project.svg)](https://github.com/amir-zangiabadi/docker-cleanup/issues)
[![GitHub last commit](https://img.shields.io/github/last-commit/amir-zangiabadi/ansible-create-playbook-project.svg)](https://github.com/amir-zangiabadi/docker-cleanup/commits/main)

## About

This repository contains a Bash script that automates the cleanup of your Docker environment by:

* Removing **exited containers** 🚮
* Deleting **dangling** and **unused images** 🖼️
* Pruning **unused volumes** 📦
* Pruning **unused networks** 🌐
* Generating **detailed logs** 🗒️
* Sending **email** and/or **Slack** reports 📧🔔

This helps keep your Docker host lean and tidy, freeing up disk space and reducing clutter.

---

## Features

* ✅ **Container cleanup**: Removes all stopped containers
* ✅ **Image cleanup**: Removes dangling images and prunes unused images
* ✅ **Volume & Network pruning**: Frees unused volumes and networks
* ✅ **Local logging**: Saves a timestamped log file
* ✅ **Email reporting**: Sends log summary via email
* ✅ **Slack reporting**: Posts log summary to a Slack channel
* ✅ **Easy scheduling**: Can be run manually or via cron

---

## Prerequisites

* 🐳 **Docker** installed and running.
* 📬 **mail** command (e.g., `mailutils`) for email reports (optional).
* 🌐 **curl** and **jq** for Slack integration (optional).
* 🔐 Permissions to execute the script and write logs to `/var/log`.

---

## Installation

1. **Clone** this repository:

   ```bash
   git clone https://github.com/amir-zangiabadi/docker-cleanup.git
   cd docker-cleanup
   ```
2. **Make** the script executable:

   ```bash
   chmod +x docker_cleanup.sh
   ```

---

## Configuration

Edit the **top** of `docker_cleanup.sh` to set:

* `LOG_FILE`: Path to the log file (default: `/var/log/docker_cleanup.log`)
* `REPORT_EMAIL`: Recipient email address for reports
* `SLACK_WEBHOOK_URL`: Your Slack Incoming Webhook URL (optional)

Example snippet:

```bash
LOG_FILE="/var/log/docker_cleanup.log"
REPORT_EMAIL="you@example.com"
SLACK_WEBHOOK_URL="https://hooks.slack.com/services/XXX/YYY/ZZZ"
```

---

## Usage

Run the script manually:

```bash
sudo ./docker_cleanup.sh
```

You should see log entries on the console and in the log file.

---

## Scheduling via Cron

To automate cleanup daily at 2:00 AM, add a cron job:

```bash
sudo crontab -e
# Add the following line:
0 2 * * * /path/to/docker_cleanup.sh
```

---

## Logging

All actions are logged to the file specified by `LOG_FILE`, including timestamps and status levels:

```
[2025-07-06 02:00:01] [INFO] === Starting Docker cleanup ===
[2025-07-06 02:00:02] [INFO] Removing exited containers...
[2025-07-06 02:00:05] [INFO] Exited containers removed.
...etc.
```

---

## Reporting

* **Email**: Sends the entire log as the email body. Requires `mail`.
* **Slack**: Posts a message block with the log contents. Requires `curl` & `jq`.

If you omit `REPORT_EMAIL` or `SLACK_WEBHOOK_URL`, the corresponding report is skipped.

---

## Contributing

1. Fork the repository 🍴
2. Create a feature branch ✨ (`git checkout -b feature/YourFeature`)
3. Commit your changes 💾 (`git commit -m "Add awesome feature"`)
4. Push to your branch 📤 (`git push origin feature/YourFeature`)
5. Open a Pull Request 📝

Please follow the existing code style and include descriptive commit messages.

---

## License

Distributed under the [MIT License](LICENSE). See `LICENSE` for more information.

---

## Contact

Project Link: [https://github.com/yourusername/docker-cleanup](https://github.com/amir-zangiabadi/docker-cleanup)
