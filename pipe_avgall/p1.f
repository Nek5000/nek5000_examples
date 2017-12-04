c-----------------------------------------------------------------------
c
c     This usr file calls avg_all in userchk.
c     param(68) is set to 1, so avg,rms and rm2 files are output at
c     the end of every timestep
c
c
c-----------------------------------------------------------------------
      subroutine uservp (ix,iy,iz,eg)
      include 'SIZE'
      include 'TOTAL'
      include 'NEKUSE'
      integer e,f,eg

      udiff =0.
      utrans=0.
      return
      end
c-----------------------------------------------------------------------
      subroutine userf  (ix,iy,iz,eg)
      include 'SIZE'
      include 'TOTAL'
      include 'NEKUSE'

      integer e,f,eg
c     e = gllel(eg)


c     Note: this is an acceleration term, NOT a force!
c     Thus, ffx will subsequently be multiplied by rho(x,t).


      ffx = 0.0
      ffy = 0.0
      ffz = 0.0

      return
      end
c-----------------------------------------------------------------------
      subroutine userq  (ix,iy,iz,eg)
      include 'SIZE'
      include 'TOTAL'
      include 'NEKUSE'

      integer e,f,eg
      qvol   = 0.0

      return
      end
c-----------------------------------------------------------------------
      subroutine userchk
      include 'SIZE'
      include 'TOTAL'
      common /myoutflow/ d(lx1,ly1,lz1,lelt),m1(lx1*ly1*lz1,lelt)
      real dx,dy,dz,ubar,m1
      integer f,e

      dx=0.
      dy=0.
      dz=3.
      ubar = 1.0
      call set_inflow_fpt(dx,dy,dz,ubar) !recirculation bc

      call avg_all 

      if (istep.gt.0) call outpost(vx,vy,vz,pr,t,'   ')

      return
      end
c-----------------------------------------------------------------------
      subroutine userbc (ix,iy,iz,iside,ieg)
      include 'SIZE'
      include 'TOTAL'
      include 'NEKUSE'
      integer e,eg

      common /cvelbc/ uin(lx1,ly1,lz1,lelv)
     $              , vin(lx1,ly1,lz1,lelv)
     $              , win(lx1,ly1,lz1,lelv)

      e = gllel(ieg)
      ux=uin(ix,iy,iz,e)
      uy=vin(ix,iy,iz,e)
      uz=win(ix,iy,iz,e)
      temp=0.0
      pa=0.0

      return
      end
c-----------------------------------------------------------------------
      subroutine useric (ix,iy,iz,eg)
      include 'SIZE'
      include 'TOTAL'
      include 'NEKUSE'
      integer e,eg
      common /mydomain/ zlength,radius

      xr = x/radius
      yr = y/radius
      rr = xr*xr + yr*yr
      if (rr.gt.0) rr=sqrt(rr)

      th = atan2(y,x)
      zo = 2*pi*z/zlength

      ux=0.0
      uy=0.0
      uz=6.*(1-rr**6)/5.

      temp=0

c     Assign a wiggly shear layer near the wall

      amp_z    = 0.35  ! Fraction of 2pi for z-based phase modification
      freq_z   = 4     ! Number of wiggles in axial- (z-) direction
      freq_t   = 9     ! Frequency of wiggles in azimuthal-direction

      amp_tht  = 5     ! Amplification factor for clipped sine function
      amp_clip = 0.2   ! Clipped amplitude

      blt      = 0.07  ! Fraction of boundary layer with momentum deficit

      phase_z = amp_z*(2*pi)*sin(freq_z*zo)

      arg_tht = freq_t*th + phase_z
      amp_sin = 5*sin(arg_tht)
      if (amp_sin.gt. amp_clip) amp_sin =  amp_clip
      if (amp_sin.lt.-amp_clip) amp_sin = -amp_clip

      if (rr.gt.(1-blt)) uz = uz + amp_sin

c     Quick P-independent randomizer

      big  = 1.e7*eg + 1.e6*ix + 1.e5*iy + 1.e4*iz
      rand = sin(big)
      uz   = uz + .01*rand
      ux   = ux + .05*rand*rand
      uy   = uy + .10*rand*rand*rand

      return
      end
c-----------------------------------------------------------------------
      subroutine usrdat
      include 'SIZE'
      include 'TOTAL'
      integer e,eg,f

      return
      end
c-----------------------------------------------------------------------
      subroutine usrdat2
      include 'SIZE'
      include 'TOTAL'
      common /mydomain/ zlength,radius

      integer e,f

      n = nx1*ny1*nz1*nelt

      call domain_size(xmin,xmax,ymin,ymax,zmin,zmax)
      zlength = zmax - zmin
      radius  = 0.5

      call fix_geom

      return
      end
c-----------------------------------------------------------------------
      subroutine usrdat3
      include 'SIZE'
      include 'TOTAL'
c
      return
      end
c-----------------------------------------------------------------------
      subroutine field_copy_si(fieldout,fieldin,idlist,nptsi)
      include 'SIZE'
      include 'TOTAL'

      real    fieldin(1),fieldout(1)
      integer idlist(1)

      do i=1,nptsi
        idx = idlist(i)
        fieldout(idx) = fieldin(i)
      enddo

      return
      end
C--------------------------------------------------------------------------
      subroutine field_eval_si(fieldout,fieldstride,fieldin)
      include 'SIZE'
      include 'TOTAL'

      real fieldout(1),fieldin(1)

      integer fieldstride,nptsi

      parameter (lt=lelv*lx1*lz1)

      integer elid_si(lt),proc_si(lt),ptid(lt),rcode_si(lt)
      common /ptlist_int/ elid_si,proc_si,ptid,rcode_si,nptsi

      real    rst_si(lt*ldim)
      common /ptlist_real/ rst_si

      integer inth_si
      common / fpt_h_si/ inth_si

c     Used for fgslib_findpts_eval of various fields
      call fgslib_findpts_eval(inth_si,fieldout,fieldstride,
     &                     rcode_si,1,
     &                     proc_si,1,
     &                     elid_si,1,
     &                     rst_si,ndim,nptsi,
     &                     fieldin)

      return
      end
c-----------------------------------------------------------------------
      subroutine rescale_inflow_fpt(ubar_in)  ! rescale inflow
      include 'SIZE'
      include 'TOTAL'

      integer icalld,e,eg,f
      save    icalld
      data    icalld /0/
      common /cvelbc/ uin(lx1,ly1,lz1,lelv)
     $              , vin(lx1,ly1,lz1,lelv)
     $              , win(lx1,ly1,lz1,lelv)

      call get_flux_and_area(ubar,abar)
      ubar  = ubar/abar        ! Ubar
      scale = ubar_in/ubar     ! Scale factor

      if (nid.eq.0.and.(istep.le.100.or.mod(istep,100).eq.0))
     $  write(6,1) istep,time,scale,ubar,abar
    1   format(1i8,1p4e14.6,' rescale')

c     Rescale the flow to match ubar_in
      do e=1,nelv
      do f=1,2*ldim
        if (cbc(f,e,1).eq.'v  ') then
           call facind (kx1,kx2,ky1,ky2,kz1,kz2,nx1,ny1,nz1,f)
           do iz=kz1,kz2
           do iy=ky1,ky2
           do ix=kx1,kx2
              uin(ix,iy,iz,e) =  scale*uin(ix,iy,iz,e)
              vin(ix,iy,iz,e) =  scale*vin(ix,iy,iz,e)
              win(ix,iy,iz,e) =  scale*win(ix,iy,iz,e)
           enddo
           enddo
           enddo
        endif
      enddo
      enddo

      ifield = 1       ! Project into H1, just to be sure....
      call dsavg(uin)
      call dsavg(vin)
      if (ldim.eq.3) call dsavg(win)

      return
      end
c-----------------------------------------------------------------------
      subroutine get_flux_and_area(vvflux,vvarea)
      include 'SIZE'
      include 'TOTAL'
      common /cvelbc/ uin(lx1,ly1,lz1,lelv)
     $              , vin(lx1,ly1,lz1,lelv)
     $              , win(lx1,ly1,lz1,lelv)
      real vvflux,vvarea
      real work(lx1*ly1*lz1)
      integer e,f

      nxz   = nx1*nz1
      nface = 2*ndim

      vvflux = 0.
      vvarea = 0.

      do e=1,nelv
      do f=1,nface
         if (cbc(f,e,1).eq.'v  ') then
            call surface_flux(dq,uin,vin,win,e,f,work)
            vvflux = vvflux + dq
            vvarea = vvarea + vlsum(area(1,1,f,e),nxz)
         endif
      enddo
      enddo
      vvflux = glsum(vvflux,1)
      vvarea = glsum(vvarea,1)
      vvflux = -vvflux !flux in is negative

      return
      end
c-----------------------------------------------------------------------
      subroutine set_inflow_fpt_setup(dxx,dyy,dzz)   ! set up inflow BCs
      include 'SIZE'
      include 'TOTAL'
c
c setup recirculation boundary condition based on user supplied dx,dy,dz
c dx,dy,dz is the vector from the inflow where the user wants the velocity
c data to be interpolated from
c
      integer icalld,e,eg,i,f,nptsi
      save    icalld
      data    icalld /0/
      real dxx,dyy,dzz

      parameter (lt=lx1*lz1*lelv)
      real rst_si(lt*ldim),xyz_si(lt*ldim)
      real dist_si(lt),vals_si(lt)

      integer elid_si(lt), proc_si(lt),ptid(lt)
      integer rcode_si(lt)
      common /ptlist_real/ rst_si
      common /ptlist_int/ elid_si,proc_si,ptid,rcode_si,nptsi
      integer inth_si
      common / fpt_h_si/ inth_si
      common /cvelbc/ uin(lx1,ly1,lz1,lelv)
     $              , vin(lx1,ly1,lz1,lelv)
     $              , win(lx1,ly1,lz1,lelv)
      common /nekmpi/ nidd,npp,nekcomm,nekgroup,nekreal

      n = nx1*ny1*nz1*nelv
ccc
c     Gather info for findpts
ccc
      nptsi = 0
      nxyz = nx1*ny1*nz1

      do e=1,nelv
      do f=1,2*ndim  !Identify the xyz of the points that are to be found 
       if (cbc(f,e,1).eq.'v  ') then
           call facind (kx1,kx2,ky1,ky2,kz1,kz2,nx1,ny1,nz1,f)
           do iz=kz1,kz2
           do iy=ky1,ky2
           do ix=kx1,kx2
            nptsi = nptsi+1
            xyz_si(ldim*(nptsi-1)+1) = xm1(ix,iy,iz,e) + dxx
            xyz_si(ldim*(nptsi-1)+2) = ym1(ix,iy,iz,e) + dyy
      if (ldim.eq.3) xyz_si(ldim*(nptsi-1)+ldim) = zm1(ix,iy,iz,e) + dzz
            ptid(nptsi) = (e-1)*nxyz+(iz-1)*lx1*ly1+(iy-1)*lx1+ix
           enddo
           enddo
           enddo
       endif
      enddo
      enddo
      mptsi=iglmax(nptsi,1)
      if (mptsi.gt.lt) 
     $  call exitti('ERROR: increase lt in inflow_fpt routines.$',mptsi)

c     Setup findpts    

      tol     = 1e-10
      npt_max = 256
      nxf     = 2*nx1 ! fine mesh for bb-test
      nyf     = 2*ny1
      nzf     = 2*nz1
      bb_t    = 0.1 ! relative size to expand bounding boxes by
      call fgslib_findpts_setup(inth_si,nekcomm,npp,ndim,
     &                   xm1,ym1,zm1,nx1,ny1,nz1,
     &                   nelt,nxf,nyf,nzf,bb_t,n,n,
     &                   npt_max,tol)


c     Call findpts to determine el,proc,rst of the xyzs determined above

      call fgslib_findpts(inth_si,rcode_si,1,
     &             proc_si,1,
     &             elid_si,1,
     &             rst_si,ndim,
     &             dist_si,1,
     &             xyz_si(1),ldim,
     &             xyz_si(2),ldim,
     &             xyz_si(3),ldim,nptsi)

      return
      end
C-----------------------------------------------------------------------
      subroutine set_inflow_fpt(dxx,dyy,dzz,ubar)   ! set up inflow BCs
      include 'SIZE'
      include 'TOTAL'

c setup recirculation boundary condition based on user supplied dx,dy,dz
c dx,dy,dz is the vector from the inflow where the user wants the 
c velocity data to be interpolated from

      integer icalld
      save    icalld
      data    icalld /0/
      real dxx,dyy,dzz

      parameter (lt=lx1*lz1*lelv)
      real rst_si(lt*ldim),xyz_si(lt*ldim)
      real dist_si(lt),vals_si(lt)
      common /ptlist_real/ rst_si

      integer elid_si(lt), proc_si(lt),ptid(lt),rcode_si(lt)
      common /ptlist_int/ elid_si,proc_si,ptid,rcode_si,nptsi
      integer inth_si
      common / fpt_h_si/ inth_si
      common /cvelbc/ uin(lx1,ly1,lz1,lelv)
     $              , vin(lx1,ly1,lz1,lelv)
     $              , win(lx1,ly1,lz1,lelv)


c     Gather info for findpts and set up inflow BC
      if (icalld.eq.0) call set_inflow_fpt_setup(dxx,dyy,dzz)
      icalld=1


c     Eval fields and copy to uvwin array
      call field_eval_si(vals_si,1,vx)
      call field_copy_si(uin,vals_si,ptid,nptsi)

      call field_eval_si(vals_si,1,vy)
      call field_copy_si(vin,vals_si,ptid,nptsi)

      if (ldim.eq.3) then
        call field_eval_si(vals_si,1,vz)
        call field_copy_si(win,vals_si,ptid,nptsi)
      endif

c     Rescale the flow so that ubar,vbar or wbar is ubar
      call rescale_inflow_fpt(ubar)

      return
      end
C-----------------------------------------------------------------------

c automatically added by makenek
      subroutine usrsetvert(glo_num,nel,nx,ny,nz) ! to modify glo_num
      integer*8 glo_num(1)

      return
      end

c automatically added by makenek
      subroutine userqtl

      call userqtl_scig

      return
      end
