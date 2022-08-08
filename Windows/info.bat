@echo off
echo All done! Connect your VM using RDP. When RDP expired and VM shutdown, Re-run jobs to get a new RDP.
echo IP:
tasklist | find /i "ngrok.exe" >Nul && curl -s localhost:4040/api/tunnels | jq -r .tunnels[0].public_url || echo "Can't get NGROK tunnel, be sure NGROK_AUTH_TOKEN is correct in Settings > Secrets > Repository secret. Maybe your previous VM still running: https://dashboard.ngrok.com/status/tunnels"
echo.
echo User: Administrator
echo Pass: Pass@!1270
echo.
echo Maximum VM Time: 6 hours
