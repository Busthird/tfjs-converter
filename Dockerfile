FROM python:3.10-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential && rm -rf /var/lib/apt/lists/*

RUN pip install --upgrade pip
RUN pip install tensorflow-cpu==2.15.0 tensorflowjs==4.6.0 h5py numpy

# JAX içeren dosyayı temizle
RUN rm -f /usr/local/lib/python3.10/site-packages/tensorflowjs/converters/jax_conversion.py || true

# JAX importunu yorum satırı yap
RUN sed -i '/from tensorflowjs.converters.jax_conversion import convert_jax/c\# from tensorflowjs.converters.jax_conversion import convert_jax' \
    /usr/local/lib/python3.10/site-packages/tensorflowjs/converters/__init__.py || true

WORKDIR /app
COPY model.h5 /app/model.h5

RUN tensorflowjs_converter \
    --input_format=keras \
    /app/model.h5 \
    /app/tfjs_model/

RUN ls -la /app/tfjs_model/

CMD ["tail", "-f", "/dev/null"]
