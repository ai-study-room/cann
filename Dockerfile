From python:3.8.18

WORKDIR /app

RUN pip3 config set global.index-url 'https://pypi.tuna.tsinghua.edu.cn/simple'

RUN mkdir -p /app/pkgs

COPY ./Ascend-cann-toolkit_7.0.RC1.3_linux-aarch64.run /app/pkgs/
RUN chmod +x /app/pkgs/Ascend-cann-toolkit_7.0.RC1.3_linux-aarch64.run
RUN /app/pkgs/Ascend-cann-toolkit_7.0.RC1.3_linux-aarch64.run --install --quiet
RUN echo "source /usr/local/Ascend/ascend-toolkit/set_env.sh" >> ~/.bashrc

COPY ./Ascend-cann-kernels-910b_7.0.RC1.3_linux.run /app/pkgs/
RUN chmod +x /app/pkgs/Ascend-cann-kernels-910b_7.0.RC1.3_linux.run
RUN /app/pkgs/Ascend-cann-kernels-910b_7.0.RC1.3_linux.run --install --quiet

RUN pip3 install torch==2.1.0
RUN pip3 install torch-npu==2.1.0

COPY ./apex-0.1_ascend-cp38-cp38-linux_aarch64.whl /app/pkgs/
RUN pip3 install /app/pkgs/apex-0.1_ascend-cp38-cp38-linux_aarch64.whl

RUN pip3 install --no-use-pep517 -e git+https://github.com/NVIDIA/Megatron-LM.git@23.05#egg=megatron-core

RUN pip3 install deepspeed==0.9.2
RUN git clone https://gitee.com/ascend/DeepSpeed.git -b v0.9.2 deepspeed_npu
RUN pip3 install -e /app/deepspeed_npu/

RUN git clone https://gitee.com/ascend/AscendSpeed
RUN mkdir -p /app/AscendSpeed/logs & mkdir -p /app/AscendSpeed/ckpt
RUN pip3 install -r /app/AscendSpeed/requirements.txt

RUN pip3 install protobuf==3.20

ENV PYTHONPATH=/app/AscendSpeed:$PYTHONPATH
ENV LD_LIBRARY_PATH=/usr/local/Ascend/nnae/6.3.RC2/runtime/lib64:$LD_LIBRARY_PATH




