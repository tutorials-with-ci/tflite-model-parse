all:  build/tflite_model_parse

build/tflite_model_parse: src/tflite_model_parse.cpp
	make include_files
	g++ -I./include src/tflite_model_parse.cpp -std=c++11 -O2 -o build/tflite_model_parse

run: build/tflite_model_parse
	./build/tflite_model_parse

include_files: include/flatbuffers/ include/schema_generated.h

include/:
	mkdir -p include

include/flatbuffers/: include/ flatbuffers/
	mkdir -p include/flatbuffers
	cp flatbuffers/include/flatbuffers/base.h include/flatbuffers
	cp flatbuffers/include/flatbuffers/flatbuffers.h include/flatbuffers
	cp flatbuffers/include/flatbuffers/stl_emulation.h include/flatbuffers

include/schema_generated.h: include/ build/flatc
	wget https://github.com/tensorflow/tensorflow/raw/master/tensorflow/contrib/lite/schema/schema.fbs -P build
	cd build && ./flatc -c ./schema.fbs
	mv build/schema_generated.h include

build/flatc: flatbuffers/
	mkdir -p build
	cd build && cmake ../flatbuffers && make -j8

flatbuffers/:
	git clone https://github.com/google/flatbuffers.git --depth 1
