FROM us-central1-docker.pkg.dev/ucb-datahub-2018/base-images-repo/base-r-image:9ebd323

# ------------------------------------------------------------
# System packages
# ------------------------------------------------------------
USER root
COPY apt.txt /tmp/apt.txt
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends $(grep -v '^#' /tmp/apt.txt) && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/apt.txt

# google-chrome is for pagedown; chromium doesn't work nicely with it (snap?)
RUN wget --quiet -O /tmp/chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    apt-get update -qq && \
    apt-get install -y --no-install-recommends /tmp/chrome.deb && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/chrome.deb

# ------------------------------------------------------------
# Conda / Python packages
# ------------------------------------------------------------
USER ${NB_USER}
COPY --chown=${NB_USER}:${NB_USER} environment.yml /tmp/environment.yml
RUN mamba env update -n notebook -f /tmp/environment.yml && \
    mamba clean -afy && rm -rf /tmp/environment.yml

# ------------------------------------------------------------
# VS Code extensions
# ------------------------------------------------------------
USER root
ENV VSCODE_EXTENSIONS=${CONDA_DIR}/envs/notebook/share/code-server/extensions
RUN install -d -o ${NB_USER} -g ${NB_USER} ${VSCODE_EXTENSIONS}

USER ${NB_USER}
RUN code-server --extensions-dir ${VSCODE_EXTENSIONS} --install-extension ms-toolsai.jupyter && \
    code-server --extensions-dir ${VSCODE_EXTENSIONS} --install-extension ms-python.python && \
    code-server --extensions-dir ${VSCODE_EXTENSIONS} --install-extension quarto.quarto

# ------------------------------------------------------------
# R packages
# ------------------------------------------------------------
WORKDIR /home/${NB_USER}
COPY --chown=${NB_USER}:${NB_USER} install.r /tmp/install.r
RUN Rscript /tmp/install.r && rm -rf /tmp/install.r /tmp/downloaded_packages/ /tmp/*.rds

# ------------------------------------------------------------
# Positron Server
# ------------------------------------------------------------
USER root
RUN wget --quiet -O /tmp/positron-server.tar.gz \
      https://cdn.posit.co/positron/releases/server/x86_64/positron-server-linux-x64-2026.07.0-365.tar.gz && \
    mkdir -p /opt/positron-server && \
    tar -xzf /tmp/positron-server.tar.gz -C /opt/positron-server --strip-components=1 && \
    rm /tmp/positron-server.tar.gz && \
    ln -s /opt/positron-server/bin/positron-server ${CONDA_DIR}/envs/notebook/bin/positron-server

USER ${NB_USER}

EXPOSE 8888
ENTRYPOINT ["tini", "--"]
