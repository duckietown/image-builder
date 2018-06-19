# DuckieOS image-builder

This Docker image contains all of the dependencies necessary to flash DuckieOS to an external USB drive.

To flash the image, insert an external drive and run `docker run -it --privileged duckietown/image-builder bash`, then follow the installation instructions.

# Optional

To build the image-builder on your local machine, run `docker build . -t duckietown/image-builder`.
