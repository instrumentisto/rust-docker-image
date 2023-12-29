Rust Docker Image
=================

[![Docker Pulls](https://img.shields.io/docker/pulls/instrumentisto/rust.svg)](https://hub.docker.com/r/instrumentisto/rust)

[Docker Hub](https://hub.docker.com/r/instrumentisto/rust)
| [GitHub Container Registry](https://github.com/orgs/instrumentisto/packages/container/package/rust)
| [Quay.io](https://quay.io/repository/instrumentisto/rust)




## Supported tags and respective `Dockerfile` links


### stable

Mirrors [official `rust` Docker images][1].

- [`1-buster`, `1.75-buster`, `1.75.0-buster`, `buster`][301]
- [`1-slim-buster`, `1.75-slim-buster`, `1.75.0-slim-buster`, `slim-buster`][302]
- [`1-bullseye`, `1.75-bullseye`, `1.75.0-bullseye`, `bullseye`][303]
- [`1-slim-bullseye`, `1.75-slim-bullseye`, `1.75.0-slim-bullseye`, `slim-bullseye`][304]
- [`1-bookworm`, `1.75-bookworm`, `1.75.0-bookworm`, `bookworm`, `1`, `1.75`, `1.75.0`, `latest`][305]
- [`1-slim-bookworm`, `1.75-slim-bookworm`, `1.75.0-slim-bookworm`, `slim-bookworm`, `1-slim`, `1.75-slim`, `1.75.0-slim`, `slim`][306]
- [`1-alpine3.18`, `1.75-alpine3.18`, `1.75.0-alpine3.18`, `alpine3.18`][309]
- [`1-alpine3.19`, `1.75-alpine3.19`, `1.75.0-alpine3.19`, `alpine3.19`, `1-alpine`, `1.75-alpine`, `1.75.0-alpine`, `alpine`][310]


### beta

- [`beta-buster`, `1.76.0-beta-buster`, `1.76.0-beta.$n-buster`][201]
- [`beta-buster-slim`, `1.76.0-beta-buster-slim`, `1.76.0-beta.$n-buster-slim`][202]
- [`beta-bullseye`, `1.76.0-beta-bullseye`, `1.76.0-beta.$n-bullseye`][203]
- [`beta-bullseye-slim`, `1.76.0-beta-bullseye-slim`, `1.76.0-beta.$n-bullseye-slim`][204]
- [`beta`, `1.76.0-beta`, `1.76.0-beta.$n`, `beta-bookworm`, `1.76.0-beta-bookworm`, `1.76.0-beta.$n-bookworm`][205]
- [`beta-slim`, `1.76.0-beta-slim`, `1.76.0-beta.$n-slim`, `beta-bookworm-slim`, `1.76.0-beta-bookworm-slim`, `1.76.0-beta.$n-bookworm-slim`][206]
- [`beta-alpine`, `1.76.0-beta-alpine`, `1.76.0-beta.$n-alpine`, `beta-alpine3.19`, `1.76.0-beta-alpine3.19`, `1.76.0-beta.$n-alpine3.19`][209]
- [`beta-alpine3.18`, `1.76.0-beta-alpine3.18`, `1.76.0-beta.$n-alpine3.18`][210]


### nightly

Mirrors [official `ghcr.io/rust-lang/rust:nightly` Docker images][2], but preserves versions for each date.

- [`nightly`, `nightly-$date`, `nightly-bullseye`, `nightly-bullseye-$date`][101]
- [`nightly-slim`, `nightly-slim-$date`, `nightly-bullseye-slim`, `nightly-bullseye-slim-$date`][102]
- [`nightly-bookworm`, `nightly-bookworm-$date`][101]
- [`nightly-bookworm-slim`, `nightly-bookworm-slim-$date`][102]
- [`nightly-buster`, `nightly-buster-$date`][101]
- [`nightly-buster-slim`, `nightly-buster-slim-$date`][102]
- [`nightly-alpine`, `nightly-alpine-$date`, `nightly-alpine3.17`, `nightly-alpine3.17-$date`][103]
- [`nightly-alpine3.16`, `nightly-alpine3.16-$date`][103]




## What is Rust?

Rust is a systems programming language sponsored by Mozilla Research. It is designed to be a "safe, concurrent, practical language", supporting functional and imperative-procedural paradigms. Rust is syntactically similar to C++, but is designed for better memory safety while maintaining performance.

> [rust-lang.org](https://rust-lang.org)

> [wikipedia.org/wiki/Rust_(programming_language)](https://wikipedia.org/wiki/Rust_(programming_language))

![Rust Logo](https://raw.githubusercontent.com/docker-library/docs/a11c341c57de07fbccfed7b21ea92d4bc40130a2/rust/logo.png)




## How to use this image


### Start a Rust instance running your app

The most straightforward way to use this image is to use a Rust container as both the build and runtime environment. In your `Dockerfile`, writing something along the lines of the following will compile and run your project:

```Dockerfile
FROM instrumentisto/rust:beta

WORKDIR /usr/src/myapp
COPY . .

RUN cargo install --path .

CMD ["myapp"]
```

Then, build and run the Docker image:

```bash
$ docker build -t my-rust-app .
$ docker run -it --rm --name my-running-app my-rust-app
```


### Compile your app inside the Docker container

There may be occasions where it is not appropriate to run your app inside a container. To compile, but not run your app inside the Docker instance, you can write something like:

```bash
$ docker run --rm --user "$(id -u)":"$(id -g)" -v "$PWD":/usr/src/myapp -w /usr/src/myapp instrumentisto/rust:beta cargo build --release
```

This will add your current directory, as a volume, to the container, set the working directory to the volume, and run the command `cargo build --release`. This tells Cargo, Rust's build system, to compile the crate in `myapp` and output the executable to `target/release/myapp`.




## Image tags

The `instrumentisto/rust` images come in many flavors, each designed for a specific use case.


### `<version>`

This is the defacto image. If you are unsure about what your needs are, you probably want to use this one. It is designed to be used both as a throw away container (mount your source code and start the container to start your app), as well as the base to build other images off of.

Some of these tags may have names like `buster` or `bullseye` in them. These are the suite code names for [releases of Debian][11] and indicate which release the image is based on. If your image needs to install any additional packages beyond what comes with the image, you'll likely want to specify one of these explicitly to minimize breakage when there are new releases of Debian.

This tag is based off of [`buildpack-deps`][12]. `buildpack-deps` is designed for the average user of Docker who has many images on their system. It, by design, has a large number of extremely common Debian packages. This reduces the number of packages that images that derive from it need to install, thus reducing the overall size of all images on your system.


### `<version>-slim`

This image does not contain the common packages contained in the default tag and only contains the minimal packages needed to run `rust`. Unless you are working in an environment where _only_ the `instrumentisto/rust` image will be deployed and you have space constraints, we highly recommend using the default image of this repository.


### `<version>-alpine`

This image is based on the popular [Alpine Linux project][21], available in [the `alpine` official image][22]. Alpine Linux is much smaller than most distribution base images (~5MB), and thus leads to much slimmer images in general.

This variant is highly recommended when final image size being as small as possible is desired. The main caveat to note is that it does use [musl libc][23] instead of [glibc and friends][24], so certain software might run into issues depending on the depth of their libc requirements. However, most software doesn't have an issue with this, so this variant is usually a very safe choice. See [this Hacker News comment thread][25] for more discussion of the issues that might arise and some pro/con comparisons of using Alpine-based images.

To minimize image size, it's uncommon for additional related tools (such as `git` or `bash`) to be included in Alpine-based images. Using this image as a base, add the things you need in your own `Dockerfile` (see the [`alpine` image description][22] for examples of how to install packages if you are unfamiliar).




## License

View [license information][3] for the software contained in this image.

As with all Docker images, these likely also contain other software which may be under other licenses (such as Bash, etc from the base distribution, along with any direct or indirect dependencies of the primary software being contained).

As for any pre-built image usage, it is the image user's responsibility to ensure that any use of this image complies with any relevant licenses for all software contained within.

The [sources][31] for producing `instrumentisto/rust` Docker images are licensed under [Blue Oak Model License 1.0.0][32].




## Issues

We can't notice comments/reviews in the Docker Hub so don't use them for reporting issue or asking question.

If you have any problems with or questions about this image, please contact us through a [GitHub issue][33].





[1]: https://hub.docker.com/_/rust
[2]: https://github.com/rust-lang/docker-rust-nightly/pkgs/container/rust
[3]: https://www.rust-lang.org/en-US/legal.html

[11]: https://wiki.debian.org/DebianReleases
[12]: https://hub.docker.com/_/buildpack-deps

[21]: http://alpinelinux.org
[22]: https://hub.docker.com/_/alpine
[23]: http://www.musl-libc.org
[24]: http://www.etalabs.net/compare_libcs.html
[25]: https://news.ycombinator.com/item?id=10782897

[31]: https://github.com/instrumentisto/rust-docker-image
[32]: https://github.com/instrumentisto/rust-docker-image/blob/main/LICENSE.md
[33]: https://github.com/instrumentisto/rust-docker-image/issues

[101]: https://github.com/rust-lang/docker-rust-nightly/blob/master/debian/Dockerfile
[102]: https://github.com/rust-lang/docker-rust-nightly/blob/master/debian-slim/Dockerfile
[103]: https://github.com/rust-lang/docker-rust-nightly/blob/master/alpine/Dockerfile

[201]: https://github.com/instrumentisto/rust-docker-image/blob/main/beta/buster/Dockerfile
[202]: https://github.com/instrumentisto/rust-docker-image/blob/main/beta/buster-slim/Dockerfile
[203]: https://github.com/instrumentisto/rust-docker-image/blob/main/beta/bullseye/Dockerfile
[204]: https://github.com/instrumentisto/rust-docker-image/blob/main/beta/bullseye-slim/Dockerfile
[205]: https://github.com/instrumentisto/rust-docker-image/blob/main/beta/bookworm/Dockerfile
[206]: https://github.com/instrumentisto/rust-docker-image/blob/main/beta/bookworm-slim/Dockerfile
[209]: https://github.com/instrumentisto/rust-docker-image/blob/main/beta/alpine3.19/Dockerfile
[210]: https://github.com/instrumentisto/rust-docker-image/blob/main/beta/alpine3.18/Dockerfile

[301]: https://github.com/rust-lang/docker-rust/blob/master/1.75.0/buster/Dockerfile
[302]: https://github.com/rust-lang/docker-rust/blob/master/1.75.0/buster/slim/Dockerfile
[303]: https://github.com/rust-lang/docker-rust/blob/master/1.75.0/bullseye/Dockerfile
[304]: https://github.com/rust-lang/docker-rust/blob/master/1.75.0/bullseye/slim/Dockerfile
[305]: https://github.com/rust-lang/docker-rust/blob/master/1.75.0/bookworm/Dockerfile
[306]: https://github.com/rust-lang/docker-rust/blob/master/1.75.0/bookworm/slim/Dockerfile
[309]: https://github.com/rust-lang/docker-rust/blob/master/1.75.0/alpine3.18/Dockerfile
[310]: https://github.com/rust-lang/docker-rust/blob/master/1.75.0/alpine3.19/Dockerfile
