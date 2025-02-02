
#!/usr/bin/env bash

# This script assumes you already have the required ssh keys and proxy (if needed) all set up.
# Also assumes you have the necessary fortran compilers
# xcode-select -install
# brew install cmake
# brew install gfortran

# Update brew packages
brew upgrade

# Install julia
brew install --cask julia

# Install openfast coupled libraries !NOTE!: if you change the location of the compiled libraries, you may need to update the rpath variable, or recompile.
cd ../../../
git clone --depth 1 https://github.com/OpenFAST/openfast.git
mkdir openfast/build
cd openfast/build
cmake -DBUILD_SHARED_LIBS=ON -DOPENMP=ON ..
make ifw_c_binding
make moordyn_c_binding
make hydrodyn_c_binding
make aerodyn_inflow_c_binding
make aerodyn_driver
make turbsim
cd ../../

# Install OWENS and non-registered dependencies as a regular user
julia -e 'using Pkg; Pkg.add(PackageSpec(url="git@github.com:kevmoor/GXBeam.jl.git"))'
julia -e 'using Pkg; Pkg.add(PackageSpec(url="https://github.com/byuflowlab/Composites.jl.git")); Pkg.add(PackageSpec(url="git@github.com:sandialabs/OWENSPreComp.jl.git")); Pkg.add(PackageSpec(url="git@github.com:sandialabs/OWENSOpenFASTWrappers.jl.git")); Pkg.add(PackageSpec(url="git@github.com:sandialabs/OWENSAero.jl.git")); Pkg.add(PackageSpec(url="git@github.com:sandialabs/OWENSFEA.jl.git")); Pkg.add(PackageSpec(url="git@github.com:sandialabs/OWENS.jl.git"))'

# Add other registered packages for running the example scripts
julia -e 'using Pkg; Pkg.add("PyPlot");Pkg.add("Statistics");Pkg.add("DelimitedFiles");Pkg.add("Dierckx");Pkg.add("QuadGK");Pkg.add("FLOWMath");Pkg.add("HDF5")'

# Run the example script
julia ExampleSNL5MW_turbulent.jl

# Install Paraview
brew install --cask paraview

# Install visual studio
brew install --cask visual-studio-code