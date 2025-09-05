
FROM rocker/geospatial:4.4

# Éviter les prompts interactifs
ENV DEBIAN_FRONTEND=noninteractive 
ENV R_CRAN_WEB="https://cran.rstudio.com/"

RUN apt-get -y update && \
    apt-get install -y --no-install-recommends pandoc
# Installation de packages R
RUN R -e "install.packages(c('remotes', 'microbenchmark', 'purrr', 'cowplot'))"

# Installation de bibliothèques système nécessaires
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    mercurial gdal-bin libgdal-dev gsl-bin libgsl-dev libc6-i386 \
    unzip python3-pip dvipng wget git make python3-dev  python3-venv build-essential gfortran libatlas-base-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*


# Installation de packages R additionnels
RUN R -e "install.packages(c('reticulate', 'inlabru', 'lme4', 'ggpolypath', 'RColorBrewer', 'geoR'))"

# Créer un venv et activer pip dans ce venv
ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Installer des paquets Python dans le venv
RUN pip install --no-cache-dir numpy scipy pandas seaborn scikit-learn statsmodels matplotlib jupyter jupyter-cache 

RUN R  -e "install.packages(c('Factoshiny', 'RefManageR', 'wesanderson', 'palmerpenguins', 'plotly'))"
RUN R  -e "install.packages(c('ggpubr', 'GGally',  'ggrepel'))"
          
# Nettoyage de TeX docs si nécessaire
RUN apt-get purge -y 'texlive.*-doc' && apt-get autoremove -y && apt-get clean

