#!/bin/bash
set -e

# Initialize submodules if needed
if [ ! -d "submodules/vcpkg/.git" ]; then
    echo "Initializing submodules..."
    git submodule init
    git submodule update
fi

# Create build directory
mkdir -p build
cd build

# Configure with CMake
echo "Configuring build..."
cmake -G "Unix Makefiles" \
      -DEQEMU_BUILD_LOGIN=ON \
      -DEQEMU_BUILD_TESTS=OFF \
      ..

# Build
echo "Compiling..."
make -j$(nproc)

# Copy binaries
mkdir -p /home/eqemu/code/build/bin/
cp bin/* /home/eqemu/code/build/bin/.

echo "Restarting server..."
cd ~/projects/akk-stack
make restart

