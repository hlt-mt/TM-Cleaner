FROM  python:3.6.9

# Create sw directory
WORKDIR /sw

# install kenlm

RUN apt update
RUN apt -qy install cmake libboost-all-dev
#
RUN mkdir -p /sw/installed
RUN git clone https://github.com/kpu/kenlm
RUN (cd kenlm ; pip3 install . --install-option="--max_order 7" ; mkdir -p build && cd build ; cmake .. -DKENLM_MAX_ORDER=7 -DCMAKE_INSTALL_PREFIX:PATH=/sw/installed ; make -j all install )

# install bicleaner
RUN git clone https://github.com/bitextor/bicleaner
RUN ( cd bicleaner ; git checkout tags/bicleaner-v0.13 ; pip3 install bicleaner ; pip3 install -r requirements.txt )


# Create app directory
WORKDIR /server

# Copy needed files
COPY webservice-multilang.* /server/
COPY stdio-classify-lite.py /server/
COPY SETENV.sh /server/
RUN mkdir -p /server/models /server/WWW
COPY models/. /server/models/
COPY WWW/. /server/WWW/

# define the port number the container should expose
EXPOSE 8081

# run the command
CMD ["bash", "webservice-multilang.DO.sh"]

