# stat-user-image

This is the repository for the stat datahub local user image.

This image builds on top of Berkeley DSEP's shared base images —
[base-r-image](https://github.com/berkeley-dsep-infra/base-r-image), which
itself builds on
[base-python-image](https://github.com/berkeley-dsep-infra/base-python-image).
Python, conda, R, and RStudio all come from those base images; this repo only
adds what's specific to the stat courses (`apt.txt`, `environment.yml`,
`install.r`).

See the [Curriculum Guide's documentation](https://curriculum-guide.datahub.berkeley.edu/workflows/develop-docker-images) for development instructions.
