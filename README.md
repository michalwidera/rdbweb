# RetractorDB website source code
Source code for the RetractorDB website.

## Local development (WSL2)

The site is a Jekyll project (compiled by GitHub Pages). To run it locally
inside WSL2 (Ubuntu):

1. Install Ruby and the native build tools Jekyll's gems need to compile:

   ```bash
   sudo apt update
   sudo apt install -y ruby-full build-essential zlib1g-dev
   ```

2. Install Bundler:

   ```bash
   gem install bundler
   ```

3. From the project root, install the project's gems (installed into
   `vendor/bundle`, per `.bundle/config` — no `sudo` needed):

   ```bash
   bundle install
   ```

4. Start the dev server:

   ```bash
   bundle exec jekyll serve --host 0.0.0.0
   ```

   Then open [http://localhost:4000](http://localhost:4000) in the Windows
   browser (WSL2 forwards `localhost`; use `--host 0.0.0.0` if that doesn't
   work on your setup). Auto-regeneration is on, so edits are picked up
   without restarting the server.
