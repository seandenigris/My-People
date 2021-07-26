DEFAULT_DEPS="libx11-6:i386 libgl1-mesa-glx:i386 libfontconfig1:i386 libssl1.0.0:i386"
#Previously working: "libc6:i386 libuuid1:i386 libfreetype6:i386 libssl1.0.0:i386"
PHARO_DEPS="$DEFAULT_DEPS libcairo2:i386"

  # Set 32bit and update apt
  dpkg --add-architecture i386
  apt-get update -yqq

  # Install dependencies
  echo "Installing dependencies"
  apt-get install -y --no-install-recommends $PHARO_DEPS
  apt-get install unzip


  # Load SmalltalkCI
  echo "Loading SmalltalkCI"
  git clone https://github.com/hpi-swa/smalltalkCI.git
  
  echo "Run SmalltalkCI"
  ./smalltalkCI/run.sh -s Pharo-6.1
