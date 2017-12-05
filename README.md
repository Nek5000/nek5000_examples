# NekExamples

This repository contains number of examples illustrating different features
of Nek5000 CFD solver. All examples are stored in separate sub-directories
containing case description (README.md) and all the files necessary to run
the simulation. They are as well implemented in the NekTests.py module allowing
for using them as verification tests.

## Example overview

Some examples provide additional pdf files for more complere description.

* `annulus_2d`
  * __Test name__ : Annulus2d
  * __Purpose__ : Natural convection between the two concentric cylinders with Boussinesq approximation.
  * __Features__ : 
  	* `cyl2.box` builds 2D annulus with genbox
* `benard`
  * __Test name__ : Benard_Ray9
  * __Purpose__ : Rayleigh-Benard convection.
  * __Features__ :
* `blasius`
  * __Test name__ : Blasius
  * __Purpose__ : Blasius boundary layer test case in 2D.
  * __Features__ :
  	* example of the "ON " boundary condition (Outflow, Normal only)
  	* provides set of routines to calculate Blasius profile
* `CMT/inv_vort`
  * __Test name__ : CmtInviscidVortex
  * __Purpose__ : Steady isentropic vortex.
  * __Features__ :
   * example of DG compressible-flow solver
* `cone/cone016`, `cone/cone064`, `cone/cone256`
  * __Test name__ : Cone16,  Cone64, Cone256
  * __Purpose__ : Convecting cone problem
  * __Features__ :
* `conj_ht`
  * __Test name__ :  ConjHt
  * __Purpose__ : 2D conjugate heat transfer in Poiseiulle flow
  * __Features__ :
   * `conj_ht.box` builds mesh consisting of 3 boxes: fluid domain and 2 solid walls
* `cyl_restart`
  * __Test name__ : CylRestart_C, CylRestart_P
  * __Purpose__ : Full restart capabilities for Nek5000.
  * __Features__ :
  	* routine `set_obj` defines objects for surface integrals
* `eddy_neknek`
  * __Test name__ : Eddy_Neknek
  * __Purpose__ : Eddy solutions in doubly-periodic domain with the multidomain version of Nek5000.
  * __Features__ :
* `eddy_psi_omega`
  * __Test name__ : Eddy_PsiOmega
  * __Purpose__ : Eddy solutions in doubly-periodic domain using the streamfunction-vorticity (psi-omega) formulation.
  * __Features__ :
* `eddy_rich`
  * __Test name__ : Eddy_Rich
  * __Purpose__ : Eddy solutions with moving boundary conditions.
  * __Features__ :
* `eddy_uv`
  * __Test name__ : Eddy_Uv
  * __Purpose__ : Eddy solutions in doubly-periodic domain with an additional translational velocity.
  * __Features__ :
* `expansion`
  * __Test name__ : Expansion
  * __Purpose__ : 3D expanding pipe.
  * __Features__ :
  	* `mkmesh` provides script for building expanding pipe mesh
* `ext_cyl`
  * __Test name__ : ExtCyl
  * __Purpose__ : Flow past a cylinder in 2D.
  * __Features__ :
  	* `mkmesh` provides script for building the box and combining it with the existing circle mesh
  	* routine `set_obj` defines objects for surface integrals
  	* routine `estimate_strouhal` calculates Strouhal number
* `fs_2`
  * __Test name__ : Fs2_St1, Fs2_St2, Fs2_StdWv
  * __Purpose__ : Free-Surface Channel Flow.
  * __Features__ :
* `hemi`
  * __Test name__ : Hemi
  * __Purpose__ : Particle tracking in flow past a hemispherical roughness.
  * __Features__ :
* `lin_channel2D`
  * __Test name__ : LinCav_Adj, LinCav_Dir
  * __Purpose__ : Linear direct and adjoint simulation of 2D differentially heated square cavity.
  * __Features__ :
* `lin_dfh_cav`
  * __Test name__ : LinChn_Adj, LinChn_Dir
  * __Purpose__ : Linear direct and adjoint simulation of 2D Poiseuille flow.
  * __Features__ :
* `lowMach_test`
  * __Test name__ : LowMachTest
  * __Purpose__ : Low-Mach number example.
  * __Features__ :
* `mhd`
  * __Test name__ : Mhd_Gpf, Mhd_GpfB, Mhd_GpfM
  * __Purpose__ : Helical Forcing Dynamo.
  * __Features__ :
* `moffatt`
  * __Test name__ : Moffatt, MoffCirc
  * __Purpose__ : Moffatt eddies - Viscous Flow in a Wedge.
  * __Features__ :
* `mv_cyl`
  * __Test name__ : MvCylCvode
  * __Purpose__ : Moving cylinder example using CVODE
  * __Features__ :
* `mv_wall`
  * __Test name__ : MvWall
  * __Purpose__ : 2D channel with a moving indentation (ALE implementation).
  * __Features__ :
* `ocyl`
  * __Test name__ : Ocyl, Ocyl2
  * __Purpose__ : Oscillating cylinder usiing ALE.
  * __Features__ :
* `os7000`
  * __Test name__ : Os7000
  * __Purpose__ : TS waves in plane Poiseuille flow.
  * __Features__ :
* `peris`
  * __Test name__ : Peris
  * __Purpose__ : Peristaltic flow.
  * __Features__ :
  	* moving mesh example with ALE
  	* special outflow treatment with user defined divergence (usrdiv) in routine `fill_div`
* `pipe`
  * __Test name__ : Pipe_Helix, Pipe_Stenosis
  * __Purpose__ : Pipe flow.
  * __Features__ :
  	* mesh geometry altered by routine `usrdat2`
* `rayleigh`
  * __Test name__ : Rayleigh_Ray1, Rayleigh_Ray2
  * __Purpose__ : Rayleigh-Benard convection.
  * __Features__ :
* `robin`
  * __Test name__ : Robin
  * __Purpose__ : Unsteady conduction with Robin boundary conditions.
  * __Features__ :
* `shear4`
  * __Test name__ : Shear4_Shear4, Shear4_Thin
  * __Purpose__ : Double shear-layer rol-up
  * __Features__ :
  	* this example illustrates transport of multiple passive scalars
* `smoother`
  * __Test name__ : Smooth
  * __Purpose__ : Mesh smoothing in Nek5000.
  * __Features__ :
* `solid`
  * __Test name__ : Solid
  * __Purpose__ : Thick-wall hollow sphere under an internal pressure.
  * __Features__ :
  	* steady elastic solver
* `strat`
  * __Test name__ : Strat_P0001, Strat_P1000
  * __Purpose__ : Stratified 2D flow.
  * __Features__ :
* `taylor`
  * __Test name__ : Taylor
  * __Purpose__ : Taylor-Couette flow.
  * __Features__ :
* `turbChannel`
  * __Test name__ : TurbChannel
  * __Purpose__ : LES of a turbulent channel flow.
  * __Features__ :
  	* this example uses AMG based coarse grid solver
* `vortex`
  * __Test name__ : Vortex
  * __Purpose__ : Vortex breakdown in a container with a rotating lid.
  * __Features__ :
* `vortex2`
  * __Test name__ : Vortex2
  * __Purpose__ : Vortex breakdown in a container with a rotating lid (axisymmetric case).
  * __Features__ :


## NekExamples unittest

The NekTests.py module contains all the examples defined as separate classes,
where each class can contain four methods for different formulations and
parallelisation modes:
* test_PnPn_Serial,
* test_PnPn_Parallel,
* test_PnPn2_Serial
* test_PnPn2_Parallel.
However, most cases contains only 'Parallel' methods, and for some examples only
PnPn or PnPn2 methods are defined, depending on the way given feature is implemented
in Nek5000. Main files of this library are shared with Nek5000 short verification
tests framework, that uses the Python standard-library unittest. It requires
Python 2.7 or higher for execution but has no other dependencies.

Before running the tests, several environment variables should be defined.

* `SOURCE_ROOT`: Points to the top-level Nek5000 repository (default: none).
* `FC`: The Fortran 77 compiler (default mpif77).
* `CC`: The C compiler (default: mpicc).
* `PPLIST`: List of pre-processor symbols (default: none)
* `USR_LFLAGS`: Linking flags (default: none)
* `MPI=[0|1]`: If 1, run tests with MPI. (default: 1)

Setting the following in your enviroment will affect the execution

* `PARALLEL_PROCS`: The number of processes to use when running with MPI
  (default: 2)
* `LOG_ROOT`: If defined, move complted logs into this directory.  If not defined,
  leave logs in the case folders.  (default: undefined)
* `VERBOSE_TESTS=[true|false]`: If true, display standard output from compiler and
   Nek5000 to terminal window.  Standard output will always be recorded in
   logfiles, whether VERBOSE_TESTS is true or false.  (default: false)

To run all the tests, first `cd` into this directory and then run:
`$ python -m 'unittest' NekTests > log`

If you wish to run tests for just one example problem (for example, "TurbChannel"), run:
`$ python -m 'unittest' NekTests.TurbChannel`

If you wish to run tests for just one example problem and one
formulation/parallelization (for example, test_PnPn_Parallel), run:
`$ python -m 'unittest' NekTests.TurbChannel.test_PnPn_Parallel`