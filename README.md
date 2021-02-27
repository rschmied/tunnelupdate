# TunnelUpdate Script

## What it does

This reads credentials from the file and updates both the DynDNS record and the
Hurricane Electric IPv6 tunnel endpoint, if a change is detected.

This "works-for-me". It was put on GitHub to have it in a save place.  It's not
necessarily meant to be useful for others.  YMMV.

## What it expects

This works specifically with a combination of DynDNS and HE TunnelBroker.  Could
probably be adapted to other provides...

In addition, the variables in `credentials` need to be changed so that they
match your accounts.

- `HE_USER` your Hurricane Electric/Tunnelbroker username
- `HE_PASS` the associated password
- `HE_HOST` the tunnel ID (a number)
- `DDNS_USER` your DynDNS account username
- `DDNS_PASS` your DynDNS account password
- `DDNS_HOST` the DNS record / FQDN you want to update

## Additional Documentation

- DynDNS update API: <https://help.dyn.com/remote-access-api/perform-update/>
- TunnelBroker update API: <https://forums.he.net/index.php?topic=1994.0>
- Tunnel Details: <https://www.tunnelbroker.net/tunnel_detail.php?tid=your-id-here>
