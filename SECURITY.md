# Security

This repo builds, signs and publishes PhoneCanDo. If something here could
let anyone ship a file that isn't ours, we want to hear about it first.

## Reporting a vulnerability

Please report privately, never in public:

- **Here**, for anything about releases: a workflow that could be tricked,
  a secret it could leak, a release file that fails
  `gh attestation verify ... --repo phonecando/distribution`, or an APK
  that isn't signed by our key. Use **Security → Report a vulnerability**
  (<https://github.com/phonecando/distribution/security/advisories/new>).
- **The app**: report privately on
  [phonecando/feedback](https://github.com/phonecando/feedback/security/advisories/new).
- **Phone control's code**: report privately on
  [phonecando/phone-control](https://github.com/phonecando/phone-control/security/advisories/new).
- Can't use GitHub? Write to hi@phonecando.app with "Security" in the
  subject.

Not sure which one? Pick any; we'll move it.

Tell us what you found, which release or file, and the steps to show it.
Please test only against your own phone, accounts and forks.

We reply within 7 days, keep you posted while we fix it, and credit you when
we publish the advisory, unless you'd rather we didn't.

Got a PhoneCanDo APK from anywhere but [phonecando.app](https://phonecando.app)
or this repo's releases? Don't install it, and tell us where you found it.
