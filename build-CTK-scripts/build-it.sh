#mkdir -p build && cd build && cmake -DCTK_QT_VERSION=5 Qt5_DIR=/home/eton/Qt/5.15.2/gcc_64/lib/cmake/Qt5 ..
echo "01--configure"
mkdir -p build && cd build && cmake -DCTK_QT_VERSION=5 Qt5_DIR=/home/eton/Qt/5.15.2/gcc_64/lib/cmake/Qt5 ..

echo "make..."
cmake --build . -j10
echo "make...finish by --eton"
