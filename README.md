# TensorFlow.js Model Converter

This project provides a Docker-based solution for converting Keras H5 models to TensorFlow.js format. It's designed to handle the conversion process in an isolated environment with all necessary dependencies pre-installed.

## Overview

The converter takes a Keras model saved in H5 format (`model.h5`) and converts it to TensorFlow.js format, which can be used in web browsers and Node.js applications. The conversion process runs inside a Docker container to ensure consistency and avoid dependency conflicts.

## Prerequisites

- Docker installed on your system
- A Keras model saved in H5 format (`model.h5`)

## Project Structure

```
tfjs_converter_project/
├── Dockerfile          # Docker configuration for the converter
├── model.h5            # Input Keras model (H5 format)
├── tfjs_model/         # Output directory for converted model
│   └── tfjs_model/
│       ├── group1-shard1of1.bin  # Model weights
│       └── model.json            # Model architecture
└── README.md           # This file
```

## Usage

### Step 1: Build the Docker Image

Build the Docker image with the converter environment:

```bash
docker build -t tfjs-converter .
```

### Step 2: Convert Your Model

Run the conversion process using the following commands:

```bash
# Create a temporary container
docker create --name temp_tfjs tfjs-converter

# Copy the converted model from the container
docker cp temp_tfjs:/app/tfjs_model ./tfjs_model

# Clean up the temporary container
docker rm temp_tfjs
```

### Alternative: Run Container Interactively

If you need to inspect the conversion process or debug issues:

```bash
# Run the container interactively
docker run -it --rm tfjs-converter /bin/bash

# Inside the container, you can manually run:
tensorflowjs_converter --input_format=keras /app/model.h5 /app/tfjs_model/
```

## What Happens During Conversion

1. **Environment Setup**: The Docker container installs Python 3.10 with TensorFlow CPU, TensorFlow.js, and other required dependencies
2. **Model Conversion**: The `tensorflowjs_converter` tool converts your H5 model to TensorFlow.js format
3. **Output Generation**: The converted model is saved in the `/app/tfjs_model/` directory inside the container

## Output Files

After successful conversion, you'll find the following files in the `tfjs_model/tfjs_model/` directory:

- `model.json`: Contains the model architecture and metadata
- `group1-shard1of1.bin`: Contains the model weights

## Using the Converted Model

The converted TensorFlow.js model can be used in:

- **Web browsers**: Load the model using TensorFlow.js library
- **Node.js applications**: Use the `@tensorflow/tfjs-node` package
- **React Native**: Use the `@tensorflow/tfjs-react-native` package

### Example Web Usage

```html
<script src="https://cdn.jsdelivr.net/npm/@tensorflow/tfjs@latest"></script>
<script>
async function loadModel() {
    const model = await tf.loadLayersModel('tfjs_model/model.json');
    // Use the model for predictions
}
</script>
```

## Troubleshooting

### Common Issues

1. **Memory Issues**: If your model is large, ensure Docker has enough memory allocated
2. **Conversion Errors**: Check that your H5 model is compatible with TensorFlow.js
3. **Permission Issues**: Ensure you have write permissions in the current directory

### Debugging

To debug conversion issues:

```bash
# Run with verbose output
docker run -it --rm tfjs-converter bash -c "tensorflowjs_converter --input_format=keras --verbose /app/model.h5 /app/tfjs_model/"
```

## Dependencies

The Docker container includes:
- Python 3.10
- TensorFlow CPU 2.15.0
- TensorFlow.js 4.6.0
- h5py
- numpy

## License

This project is provided as-is for educational and development purposes.

## Support

For issues related to:
- **TensorFlow.js conversion**: Check the [TensorFlow.js documentation](https://www.tensorflow.org/js)
- **Docker issues**: Refer to the [Docker documentation](https://docs.docker.com/)
- **Model compatibility**: Ensure your Keras model is compatible with TensorFlow.js 