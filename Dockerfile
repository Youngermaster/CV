# XeLaTeX build image for the Awesome-CV based résumés in this repo.
# Improves on the Chucho-CV image: adds the LaTeX packages awesome-cv.cls needs
# (tcolorbox, enumitem, unicode-math via latex-extra), uses latexmk for reliable
# multi-pass builds, sets a WORKDIR, cleans apt caches, and ships a default CMD
# so `docker run` compiles both cv.tex and coverletter.tex non-interactively.
FROM ubuntu:24.04

ENV LANG=C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive

# * texlive-xetex            -> XeLaTeX engine + fontspec (local .otf/.ttf fonts)
# * texlive-latex-extra      -> tcolorbox, enumitem, unicode-math (required by awesome-cv.cls)
# * texlive-fonts-recommended-> base font support
# * latexmk                  -> automatic multi-pass compilation
# * fonts-font-awesome, make -> icons + convenience
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        texlive-xetex \
        texlive-latex-extra \
        texlive-fonts-recommended \
        latexmk \
        fonts-font-awesome \
        make && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /project

# Compile both documents; fonts resolve from the mounted project (\fontdir[fonts/]).
CMD ["bash", "-c", "latexmk -xelatex -interaction=nonstopmode -halt-on-error cv.tex && latexmk -xelatex -interaction=nonstopmode -halt-on-error coverletter.tex && latexmk -c cv.tex coverletter.tex"]
