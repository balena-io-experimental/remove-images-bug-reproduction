# Remove-image-bug reproduction

JF Link:  https://jel.ly.fish/81f483e7-e8e3-41c0-b0b1-bb549eddbe20

# Usage

## Setup

- Clone the repo.
- Create an application & get your device working.  The script
  `create_release.sh` (used below) assumes the app is called `Pi4App`; edit the
  file if yours is called something different.

## Master branch: Happy case: multiple deploys do not cause images to pile up.

The _master_ branch has the _happy_ case:  multiple deploys with this
do *not* cause a problem.  Create an app, and deploy it like so:

```
git checkout -b master
balena push Pi4App
```

Now, run `create_release.sh`.  This will add a placeholder commit, and create a
new release by running `balena push`:

```
./create_release.sh
```

SSH to your device.

Push out a few more releases by running `create_release.sh`.  After each release:

- watch the dashboard to see that the release has made it do the
device
- run these commands on a `balena ssh` session to your device:

```
date ; \
	balena ps -a ; \
	echo '------------------'; \
	balena images --digests ; \
	echo '------------------'; \
	echo -n 'Total images: ' ; \
	balena images | wc -l ; \
	echo '------------------'; \
	df /mnt/data
```

What you should see is that the total number of images is *not*
changing.  On my device, it's 5 images:  1 for the healthcheck, 1 for
the supervisor, and 3 for the 3 services in `docker-compose.yml`.

## `sad_case-images_pile_up` branch: Sad case: multiple deploys *do* cause images to pile up

Check out the sad case branch, and push out a new release:

```
git checkout -b sad_case-images_pile_up
./create_release.sh
```

Now, push out a few more releases by running `create_release`.  After
each release:

- watch the dashboard to see that the release has made it do the
device
- run these commands on a `balena ssh` session to your device:

```
date ; \
	balena ps -a ; \
	echo '------------------'; \
	balena images --digests ; \
	echo '------------------'; \
	echo -n 'Total images: ' ; \
	balena images | wc -l ; \
	echo '------------------'; \
	df /mnt/data
```

What you should see is that the total number of images *is
increasing*, and *disk space is slowly decreasing*.  On my device,
I get 3 more images (for each of the 3 services in
`docker-compose.yml`) each iteration:  15, then 18, then 21, then....

You could probably accelerate this problem by having more services
(the customer, for example, has 13), and by adding more cruft to the
image to fill it up (big file of random data, say).

# License

Apache v2; see `LICENSE`.
