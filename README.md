# Coding-lab_Group-epsilon

This repository contains a small hospital-sensor log simulator and tooling for archiving and analyzing the generated logs. It was created as part of a group coding lab and contains simple Python-based loggers and shell scripts to rotate/archive and analyze logs.

## Project overview

- Three Python scripts simulate sensors and continuously append timestamped readings to log files:
  - `heart_monitor.py` -> writes to `hospital_data/active_logs/heart_rate_log.log`
  - `temp_sensor.py` -> writes to `hospital_data/active_logs/temperature_log.log`
  - `water_meter.py` -> writes to `hospital_data/active_logs/water_usage_log.log`
- Shell utilities:
  - `archive_logs.sh` — interactive script to archive an active log into `hospital_data/archived_logs/<type>/` and recreate an empty active log
  - `analyze_logs.sh` — interactive script to produce a simple analysis report saved to `hospital_data/reports/analysis_report.txt`

## Repository layout

Top-level files you'll use:

- `heart_monitor.py`, `temp_sensor.py`, `water_meter.py` — Python loggers
- `archive_logs.sh` — Move an active log into the archive folder (rotates logs)
- `analyze_logs.sh` — Produce a brief analysis report (device counts and first/last timestamps)
- `hospital_data/` — data folder created by the scripts (contains `active_logs`, `archived_logs`, and `reports`)

Existing data (examples) may be present under `hospital_data/` (check `hospital_data/active_logs` and `hospital_data/archived_logs`).

## Requirements

- Python 3.x (tested with Python 3.10+)
- Bash (POSIX shell)

No external Python packages are required.

## Quick start - run the loggers

Each logger writes one or more device readings per second to its log file. Run them in separate terminals or background jobs.

Start a logger (example: heart monitor):

```sh
python3 heart_monitor.py start
```

Stop it with:

```sh
python3 heart_monitor.py stop
```

Repeat for `temp_sensor.py` and `water_meter.py`.

Log files are placed in `hospital_data/active_logs/`:

- `heart_rate_log.log`
- `temperature_log.log`
- `water_usage_log.log`

Notes about the logger implementation:

- They are simple fork-based daemons that write a PID file to `/tmp/` (e.g. `/tmp/heart_rate_monitor.pid`).
- Stopping uses `os.kill(pid, 9)` (SIGKILL). Consider changing that to SIGTERM for graceful shutdown.

## Archive logs (rotate)

Use the interactive `archive_logs.sh` script to archive a specific active log into `hospital_data/archived_logs/<type>/`.

Example (interactive):

```sh
bash archive_logs.sh
# Choose 1/2/3 when prompted
```

Example (non-interactive with echo):

```sh
echo 1 | bash archive_logs.sh     # archive heart rate log
```

The script will create the archive subdirectory if missing, move the active log to a timestamped file, and recreate an empty active log file.

## Analyze logs

`analyze_logs.sh` analyzes a selected active log and appends a short report to `hospital_data/reports/analysis_report.txt`.

Example:

```sh
echo 1 | bash analyze_logs.sh     # analyze heart_rate_log.log
tail -n 60 hospital_data/reports/analysis_report.txt
```

What the analysis includes:

- Per-device counts (counts lines per device name found in the 3rd field)
- First and last timestamps (derived from the first two fields of the log lines)

The script handles empty log files and will write "No entries found." when applicable.


## Troubleshooting

- If a script reports a missing file, ensure `hospital_data/active_logs/` contains the expected `*_log.log` files.
- Permissions: make sure the user running the scripts can create files under `hospital_data/`.

