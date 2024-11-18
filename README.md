# 🤖 DrippyBot

🐳 Docker container that prevents Epson printer nozzle clogs through scheduled test prints

## 🎯 Why?

Inkjet printers can develop nozzle clogs when not used regularly. DrippyBot automatically prints a test page at scheduled intervals to keep your print heads healthy.

## 📌 Usage

First, get your printer model string:
```bash
docker run -it --rm ghcr.io/vittee/drippybot model
```

Type your printer model to search, select it, and use the output string as the `MODEL` environment variable in your compose file.

Find your printer's IPP URI:

1. Open your Epson printer's web interface by entering its IP address in a browser
2. Look for "Web Config" or "Printer Information" page
3. Find the IPP endpoint - usually in one of these formats:

```
http://<printer-ip>:631/ipp/print
https://<printer-ip>:631/ipp/print
```

Replace `<printer-ip>` with your Epson printer's IP address.

The protocol (`http` or `https`) depends on your printer model and settings.

Use the one that works with your printer's web interface and use it as the `URI` environment variable.

Set your timezone in the compose file. Use TZ identifier from: https://en.wikipedia.org/wiki/List_of_tz_database_time_zones

`docker-compose.yml`:
```yaml
x-timezone: &tz
  # Set your local timezone
  TZ: Asia/Bangkok

services:
  drippybot:
    image: ghcr.io/vittee/drippybot:latest
    restart: always
    environment:
      <<: *tz
      # Required: Your printer's IPP URI
      URI: https://192.168.1.100:631/ipp/print
      # Required: Copy and paste the output string from 'model' command here
      MODEL: escpr:0/cups/model/epson-inkjet-printer-escpr/Epson-L3250_Series-epson-escpr-en.ppd
    labels:
      ofelia.enabled: "true"
      # Run at 10:30:00 every Tuesday - good time for home printers
      ofelia.job-exec.datecron.schedule: "0 30 10 * * 2"
      ofelia.job-exec.datecron.command: "/entrypoint.sh print"

  scheduler:
    image: mcuadros/ofelia:latest
    restart: always
    environment:
      <<: *tz
    command: daemon --docker
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
```

The schedule format is: `second` `minute` `hour` `day_of_month` `month` `day_of_week`

Examples:

`0 30 10 * * 2` - Run at 10:30 AM every Tuesday (recommended for home printers)

`0 30 10 * * 1,4` - Run at 10:30 AM Monday and Thursday (for more frequent use)

`0 30 10 * * *` - Run at 10:30 AM every day (for frequently used printers)

See [cron](https://pkg.go.dev/github.com/robfig/cron) documentation for more details

## 🏃🏼‍♂️ Running

You can run this compose file using one of these methods:

#### CLI
```
docker compose up -d
```

#### Portainer

Go to "Stacks"

1. Click "Add stack"
2. Upload or paste the `docker-compose.yml` file content
3. Deploy the stack

## Author
Wittawas Nakkasem
