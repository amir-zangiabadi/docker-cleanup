#!/usr/bin/env bash
#
# docker_cleanup.sh
# Automated Docker cleanup script with reporting

#### Configuration ####
# Local log file path
LOG_FILE="/var/log/docker_cleanup.log"
# Recipient email for report (e.g., you@example.com)
REPORT_EMAIL="you@example.com"
# Slack webhook URL for sending report (optional)
SLACK_WEBHOOK_URL=""

#### Helper Functions ####

# Log function with timestamp
log() {
  local level="$1"; shift
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$level] $*" | tee -a "$LOG_FILE"
}

# Function to send email report
send_email_report() {
  local subject="Docker Cleanup Report $(date '+%Y-%m-%d')"
  local body
  body=$(<"$LOG_FILE")
  if command -v mail &>/dev/null; then
    echo "$body" | mail -s "$subject" "$REPORT_EMAIL"
    log "INFO" "Email report sent to $REPORT_EMAIL."
  else
    log "WARNING" "mail command not found; email report skipped."
  fi
}

# Function to send report to Slack
send_slack_report() {
  if [[ -z "$SLACK_WEBHOOK_URL" ]]; then
    log "INFO" "No Slack webhook configured; Slack report skipped."
    return
  fi
  local payload
  payload=$(jq -R -s --arg title "Docker Cleanup Report" '{text: $title, blocks:[{type:"section", text:{type:"mrkdwn", text:.}}]}' <"$LOG_FILE")
  curl -s -X POST -H 'Content-type: application/json' --data "$payload" "$SLACK_WEBHOOK_URL" >/dev/null
  log "INFO" "Slack report sent."
}

#### Prerequisite Checks ####
# Check Docker command availability
if ! command -v docker &>/dev/null; then
  log "ERROR" "docker command not found. Please install Docker or add it to PATH."
  exit 1
fi

# Ensure log directory is writable
if [[ ! -w $(dirname "$LOG_FILE") ]]; then
  echo "Error: Cannot write to $(dirname "$LOG_FILE")."
  exit 1
fi
touch "$LOG_FILE" 2>/dev/null

#### Begin Cleanup ####
log "INFO" "=== Starting Docker cleanup ==="

# 1. Remove exited containers
log "INFO" "Removing exited containers..."
if docker ps -a -f "status=exited" --format '{{.ID}}' | grep -q .; then
  docker rm $(docker ps -a -f "status=exited" -q) >> "$LOG_FILE" 2>&1 \
    && log "INFO" "Exited containers removed." \
    || log "ERROR" "Failed to remove exited containers!"
else
  log "INFO" "No exited containers to remove."
fi

# 2. Remove dangling images
log "INFO" "Removing dangling images..."
if docker images -f "dangling=true" -q | grep -q .; then
  docker rmi $(docker images -f "dangling=true" -q) >> "$LOG_FILE" 2>&1 \
    && log "INFO" "Dangling images removed." \
    || log "ERROR" "Failed to remove dangling images!"
else
  log "INFO" "No dangling images to remove."
fi

# 3. Prune unused images
log "INFO" "Pruning unused images..."
if docker image prune -f >> "$LOG_FILE" 2>&1; then
  log "INFO" "Unused images pruned."
else
  log "ERROR" "Failed to prune unused images!"
fi

# 4. Prune unused volumes
log "INFO" "Pruning unused volumes..."
if docker volume prune -f >> "$LOG_FILE" 2>&1; then
  log "INFO" "Unused volumes pruned."
else
  log "ERROR" "Failed to prune unused volumes!"
fi

# 5. Prune unused networks
log "INFO" "Pruning unused networks..."
if docker network prune -f >> "$LOG_FILE" 2>&1; then
  log "INFO" "Unused networks pruned."
else
  log "ERROR" "Failed to prune unused networks!"
fi

#### End Cleanup ####
log "INFO" "=== Docker cleanup completed ==="

#### Send Reports ####
send_email_report
send_slack_report

exit 0
