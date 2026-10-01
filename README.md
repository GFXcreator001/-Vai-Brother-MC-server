FD Minecraft Server Setup — Final ZIP

FD-এর PC-তে প্রথমবার যা করবে

Git install করবে
Git for Windows install করতে হবে।

তোমার private repo clone করবে
PowerShell-এ:

git clone https://github.com/GFXcreator001/Vai-Brother-MC-server.git "D:\MC Server"

⚠️ D:\MC Server আগে থেকে থাকা empty folder হতে হবে।

ZIP-এর files D:\MC Server-এ রাখবে

Package থেকে:

START SERVER.bat
STOP SERVER.bat
auto_backup.bat
.gitignore

আর তোমার repo-তে mcrcon.exe থাকলে সেটা clone-এর সাথেই চলে আসবে।

rcon_password.txt নিজে তৈরি করবে

D:\MC Server\rcon_password.txt

ভেতরে শুধু RCON password:

MyStrongPassword2026

এবং server.properties-এ:

rcon.password=MyStrongPassword2026
এরপর থেকে FD-এর কাজ শুধু

খেলা শুরু → START SERVER.bat

এটা automatically:

git pull → latest world → server start → RCON ready হওয়া পর্যন্ত wait → auto backup start

খেলা শেষ → STOP SERVER.bat

এটা:

save → server stop → final GitHub backup → done ✅

সবচেয়ে গুরুত্বপূর্ণ নিয়ম

একসাথে তোমার PC আর FD-এর PC-তে server চালাবে না।

FD-এর STOP SERVER.bat পুরোপুরি শেষ হওয়ার পর তুমি START SERVER.bat চালাবে।

তাহলেই একই world পালা করে, আর manual git pull করার ঝামেলা থাকবে না।

----------------------------------------------------------------------------------------------------------------------

FD / SECOND-PC SETUP

1. Install Git for Windows.
2. Clone the private repository into an EMPTY Minecraft server folder.
3. Put these files in the same server folder:
   - START SERVER.bat
   - STOP SERVER.bat
   - auto_backup.bat
   - mcrcon.exe
4. Create rcon_password.txt and put ONLY the RCON password inside.
5. server.properties must contain:
   enable-rcon=true
   rcon.port=25575
   rcon.password=<same password>
6. .gitignore must contain:
   rcon_password.txt
   world/session.lock

NORMAL USE
- Start: double-click START SERVER.bat
- Stop: double-click STOP SERVER.bat

IMPORTANT
- Only ONE PC should run the Minecraft server at a time.
- The previous player must finish STOP SERVER.bat successfully before the next PC starts.
- Keep the GitHub repository private.
- Never commit rcon_password.txt.

