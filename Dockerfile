FROM mainehaskell/helm

WORKDIR /app/helmsnake

# this is necessary because although helm is globally available,
# it still gets "built" when building helmsnake - that was not
# expected.
COPY stack.yaml .
COPY helmsnake.cabal .
RUN stack build --only-dependencies

COPY . .
RUN stack build
