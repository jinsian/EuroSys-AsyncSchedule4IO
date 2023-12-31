#include <AMReX_Config.H>

module amrex_fillpatch_module

  use amrex_base_module

  implicit none
  private

  public :: amrex_fillpatch, amrex_fillcoarsepatch, amrex_interp_hook_proc

  interface amrex_fillpatch
     module procedure amrex_fillpatch_single
     module procedure amrex_fillpatch_two
     module procedure amrex_fillpatch_two_faces
  end interface amrex_fillpatch

  interface amrex_fillcoarsepatch
     module procedure amrex_fillcoarsepatch_default
     module procedure amrex_fillcoarsepatch_faces
  end interface amrex_fillcoarsepatch

  interface
     subroutine amrex_interp_hook_proc (lo, hi, d, dlo, dhi, nd, icomp, ncomp) bind(c)
       import
       implicit none
       integer(c_int), intent(in) :: lo(3), hi(3), dlo(3), dhi(3)
       integer(c_int), intent(in), value :: nd, icomp, ncomp
       real(amrex_real), intent(inout) :: d(dlo(1):dhi(1),dlo(2):dhi(2),dlo(3):dhi(3),nd)
     end subroutine amrex_interp_hook_proc

     subroutine amrex_interp_hook_arr_proc (lo, hi, dx, dxlo, dxhi, &
#if (AMREX_SPACEDIM > 1)
          &                                         dy, dylo, dyhi, &
#endif
#if (AMREX_SPACEDIM > 2)
          &                                         dz, dzlo, dzhi, &
#endif
          &                                 nd, icomp, ncomp) bind(c)
       import
       implicit none
       integer(c_int), intent(in) :: lo(3), hi(3), dxlo(3), dxhi(3)
       integer(c_int), intent(in), value :: nd, icomp, ncomp
       real(amrex_real), intent(inout) :: dx(dxlo(1):dxhi(1),dxlo(2):dxhi(2),dxlo(3):dxhi(3),nd)
#if (AMREX_SPACEDIM > 1)
       integer(c_int), intent(in) :: dylo(3), dyhi(3)
       real(amrex_real), intent(inout) :: dy(dylo(1):dyhi(1),dylo(2):dyhi(2),dylo(3):dyhi(3),nd)
#endif
#if (AMREX_SPACEDIM > 2)
       integer(c_int), intent(in) :: dzlo(3), dzhi(3)
       real(amrex_real), intent(inout) :: dz(dzlo(1):dzhi(1),dzlo(2):dzhi(2),dzlo(3):dzhi(3),nd)
#endif
     end subroutine amrex_interp_hook_arr_proc
  end interface

  interface
     subroutine amrex_fi_fillpatch_single(mf, time, smf, stime, ns, scomp, dcomp, ncomp, &
          geom, fill) bind(c)
       import
       implicit none
       type(c_ptr), value :: mf, geom
       type(c_ptr), intent(in) :: smf(*)
       real(amrex_real), value :: time
       real(amrex_real), intent(in) :: stime(*)
       integer(c_int), value :: scomp, dcomp, ncomp, ns
       type(c_funptr), value :: fill
     end subroutine amrex_fi_fillpatch_single

     subroutine amrex_fi_fillpatch_two(mf, time, &
          cmf, ctime, nc, fmf, ftime, nf, scomp, dcomp, ncomp, &
          cgeom, fgeom, cfill, ffill, rr, interp, lo_bc, hi_bc, pre_interp, post_interp) &
          bind(c)
       import
       implicit none
       type(c_ptr), value :: mf, cgeom, fgeom
       type(c_ptr), intent(in) :: cmf(*), fmf(*), lo_bc(*), hi_bc(*)
       type(c_funptr), value :: cfill, ffill, pre_interp, post_interp
       real(amrex_real), value :: time
       real(amrex_real), intent(in) :: ctime(*), ftime(*)
       integer, value :: nc, nf, scomp, dcomp, ncomp, rr, interp
     end subroutine amrex_fi_fillpatch_two

     subroutine amrex_fi_fillpatch_two_faces(mf, time, &
          cmf, ctime, nc, fmf, ftime, nf, scomp, dcomp, ncomp, &
          cgeom, fgeom, cfill, ffill, rr, interp, lo_bc, hi_bc, pre_interp, post_interp) &
          bind(c)
       import
       implicit none
       type(c_ptr), value :: cgeom, fgeom
       type(c_ptr), intent(in) :: mf(*)
       type(c_ptr), intent(in) :: cmf(*), fmf(*), lo_bc(*), hi_bc(*)
       type(c_funptr), intent(in) :: cfill(*), ffill(*)
       type(c_funptr), value :: pre_interp, post_interp
       real(amrex_real), value :: time
       real(amrex_real), intent(in) :: ctime(*), ftime(*)
       integer, value :: nc, nf, scomp, dcomp, ncomp, rr, interp
     end subroutine amrex_fi_fillpatch_two_faces

     subroutine amrex_fi_fillcoarsepatch(mf, time, cmf, scomp, dcomp, ncomp, &
          cgeom, fgeom, cfill, ffill, rr, interp, lo_bc, hi_bc, pre_interp, post_interp) &
          bind(c)
       import
       implicit none
       type(c_ptr), value :: mf, cmf, cgeom, fgeom
       type(c_ptr), intent(in) :: lo_bc(*), hi_bc(*)
       type(c_funptr), value :: cfill, ffill, pre_interp, post_interp
       real(amrex_real), value :: time
       integer, value :: scomp, dcomp, ncomp, rr, interp
     end subroutine amrex_fi_fillcoarsepatch

     subroutine amrex_fi_fillcoarsepatch_faces(mf, time, cmf, scomp, dcomp, ncomp, &
          cgeom, fgeom, cfill, ffill, rr, interp, lo_bc, hi_bc, pre_interp, post_interp) &
          bind(c)
       import
       implicit none
       type(c_ptr), intent(in) :: mf(*), cmf(*)
       type(c_ptr), value :: cgeom, fgeom
       type(c_ptr), intent(in) :: lo_bc(*), hi_bc(*)
       type(c_funptr), intent(in) :: cfill(*), ffill(*)
       type(c_funptr), value :: pre_interp, post_interp
       real(amrex_real), value :: time
       integer, value :: scomp, dcomp, ncomp, rr, interp
     end subroutine amrex_fi_fillcoarsepatch_faces
  end interface

contains

  subroutine amrex_fillpatch_single (mf, told, mfold, tnew, mfnew, geom, fill_physbc, &
       &                             time, scomp, dcomp, ncomp)
    type(amrex_multifab), intent(inout) :: mf
    type(amrex_multifab), intent(in   ) :: mfold, mfnew
    integer, intent(in) :: scomp, dcomp, ncomp
    real(amrex_real), intent(in) :: told, tnew, time
    type(amrex_geometry), intent(in) :: geom
    procedure(amrex_physbc_proc) :: fill_physbc

    real(amrex_real) :: teps
    real(amrex_real) :: stime(2)
    type(c_ptr) :: smf(2)
    integer :: ns

    teps = 1.e-4_amrex_real * abs(tnew - told)
    if (abs(time-tnew) .le. teps) then
       ns = 1
       smf  (1) = mfnew%p
       stime(1) =  tnew
    else if (abs(time-told) .le. teps) then
       ns = 1
       smf  (1) = mfold%p
       stime(1) =  told
    else
       ns = 2
       smf  (1) = mfold%p
       smf  (2) = mfnew%p
       stime(1) =  told
       stime(2) =  tnew
    end if

    ! scomp-1 and dcomp-1 because of Fortran index starts with 1
    call amrex_fi_fillpatch_single(mf%p, time, smf, stime, ns, scomp-1, dcomp-1, ncomp, geom%p, &
         &                         c_funloc(fill_physbc))

  end subroutine amrex_fillpatch_single

  subroutine amrex_fillpatch_two (mf, told_c, mfold_c, tnew_c, mfnew_c, geom_c, fill_physbc_c, &
       &                              told_f, mfold_f, tnew_f, mfnew_f, geom_f, fill_physbc_f, &
       &                          time, scomp, dcomp, ncomp, rr, interp, lo_bc, hi_bc, &
       &                          pre_interp, post_interp)
    type(amrex_multifab), intent(inout) :: mf
    type(amrex_multifab), intent(in   ) :: mfold_c, mfnew_c, mfold_f, mfnew_f
    integer, intent(in) :: scomp, dcomp, ncomp, rr, interp
    integer, dimension(amrex_spacedim,scomp+ncomp-1), target, intent(in) :: lo_bc, hi_bc
    real(amrex_real), intent(in) :: told_c, tnew_c, told_f, tnew_f, time
    type(amrex_geometry), intent(in) :: geom_c, geom_f
    procedure(amrex_physbc_proc) :: fill_physbc_c, fill_physbc_f
    procedure(amrex_interp_hook_proc), optional :: pre_interp
    procedure(amrex_interp_hook_proc), optional :: post_interp

    real(amrex_real) :: teps
    real(amrex_real) :: c_time(2), f_time(2)
    type(c_ptr) :: c_mf(2), f_mf(2)
    type(c_ptr) :: lo_bc_ptr(scomp+ncomp-1), hi_bc_ptr(scomp+ncomp-1)
    type(c_funptr) :: pre_interp_ptr, post_interp_ptr
    integer :: ncrse, nfine, i

    ! coarse level
    teps = 1.e-4_amrex_real * abs(tnew_c - told_c)
    if (abs(time-tnew_c) .le. teps) then
       ncrse= 1
       c_mf  (1) = mfnew_c%p
       c_time(1) =  tnew_c
    else if (abs(time-told_c) .le. teps) then
       ncrse= 1
       c_mf  (1) = mfold_c%p
       c_time(1) =  told_c
    else
       ncrse= 2
       c_mf  (1) = mfold_c%p
       c_mf  (2) = mfnew_c%p
       c_time(1) =  told_c
       c_time(2) =  tnew_c
    end if

    ! fine level
    teps = 1.e-4_amrex_real * abs(tnew_f - told_f)
    if (abs(time-tnew_f) .le. teps) then
       nfine= 1
       f_mf  (1) = mfnew_f%p
       f_time(1) =  tnew_f
    else if (abs(time-told_f) .le. teps) then
       nfine= 1
       f_mf  (1) = mfold_f%p
       f_time(1) =  told_f
    else
       nfine= 2
       f_mf  (1) = mfold_f%p
       f_mf  (2) = mfnew_f%p
       f_time(1) =  told_f
       f_time(2) =  tnew_f
    end if

    do i = 1, scomp-1
       lo_bc_ptr(i) = c_null_ptr
       hi_bc_ptr(i) = c_null_ptr
    end do
    do i = scomp, scomp+ncomp-1
       lo_bc_ptr(i) = c_loc(lo_bc(1,i))
       hi_bc_ptr(i) = c_loc(hi_bc(1,i))
    end do

    pre_interp_ptr = c_null_funptr
    if (present(pre_interp)) pre_interp_ptr = c_funloc(pre_interp)
    post_interp_ptr = c_null_funptr
    if (present(post_interp)) post_interp_ptr = c_funloc(post_interp)

    ! scomp-1 and dcomp-1 because of Fortran index starts with 1
    call amrex_fi_fillpatch_two(mf%p, time, c_mf, c_time, ncrse, &
         &                                  f_mf, f_time, nfine, &
         &                      scomp-1, dcomp-1, ncomp,         &
         &                      geom_c%p, geom_f%p,              &
         &                      c_funloc(fill_physbc_c),         &
         &                      c_funloc(fill_physbc_f),         &
         &                      rr, interp, lo_bc_ptr, hi_bc_ptr,&
         &                      pre_interp_ptr, post_interp_ptr)
  end subroutine amrex_fillpatch_two

  subroutine amrex_fillpatch_two_faces(mf, told_c, mfold_c, tnew_c, mfnew_c, geom_c, fill_physbc_cx, &
#if (AMREX_SPACEDIM > 1)
        &                                   fill_physbc_cy, &
#if (AMREX_SPACEDIM > 2)
        &                                   fill_physbc_cz, &
#endif
#endif
        &                                   told_f, mfold_f, tnew_f, mfnew_f, geom_f, fill_physbc_fx, &
#if (AMREX_SPACEDIM > 1)
        &                                   fill_physbc_fy, &
#if (AMREX_SPACEDIM > 2)
        &                                   fill_physbc_fz, &
#endif
#endif
        &                               time, scomp, dcomp, ncomp, rr, interp, lo_bc, hi_bc, &
        &                               pre_interp, post_interp)
    type(amrex_multifab), intent(inout) :: mf(amrex_spacedim)
    type(amrex_multifab), intent(in   ) :: mfold_c(amrex_spacedim), mfnew_c(amrex_spacedim)
    type(amrex_multifab), intent(in   ) :: mfold_f(amrex_spacedim), mfnew_f(amrex_spacedim)
    integer, intent(in) :: scomp, dcomp, ncomp, rr, interp
    !                 (BC dir        , comp        , MF)
    integer, dimension(amrex_spacedim,scomp+ncomp-1,amrex_spacedim), target, intent(in) :: lo_bc, hi_bc
    real(amrex_real), intent(in) :: told_c, tnew_c, told_f, tnew_f, time
    type(amrex_geometry), intent(in) :: geom_c, geom_f
    procedure(amrex_physbc_proc) :: fill_physbc_cx, fill_physbc_fx
#if (AMREX_SPACEDIM > 1)
    procedure(amrex_physbc_proc) :: fill_physbc_cy, fill_physbc_fy
#endif
#if (AMREX_SPACEDIM > 2)
    procedure(amrex_physbc_proc) :: fill_physbc_cz, fill_physbc_fz
#endif
    procedure(amrex_interp_hook_arr_proc), optional :: pre_interp
    procedure(amrex_interp_hook_arr_proc), optional :: post_interp

    real(amrex_real) :: teps
    real(amrex_real) :: c_time(2), f_time(2)
    type(c_ptr) :: faces(amrex_spacedim)
    type(c_ptr) :: c_mf(amrex_spacedim*2), f_mf(amrex_spacedim*2)
    type(c_funptr) :: cfill(amrex_spacedim), ffill(amrex_spacedim)
    type(c_ptr) :: lo_bc_ptr(amrex_spacedim*(scomp+ncomp-1))
    type(c_ptr) :: hi_bc_ptr(amrex_spacedim*(scomp+ncomp-1))
    type(c_funptr) :: pre_interp_ptr, post_interp_ptr
    integer :: ncrse, nfine, dim, mfid, nc, i

    cfill(1) = c_funloc(fill_physbc_cx)
    ffill(1) = c_funloc(fill_physbc_fx)
#if AMREX_SPACEDIM>=2
    cfill(2) = c_funloc(fill_physbc_cy)
    ffill(2) = c_funloc(fill_physbc_fy)
#if AMREX_SPACEDIM>=3
    cfill(3) = c_funloc(fill_physbc_cz)
    ffill(3) = c_funloc(fill_physbc_fz)
#endif
#endif

    do dim = 1, amrex_spacedim
       faces(dim) = mf(dim)%p
    end do

    ! coarse level
    teps = 1.e-4_amrex_real * abs(tnew_c - told_c)
    if (abs(time-tnew_c) .le. teps) then
       ncrse= 1
       c_time(1) =  tnew_c
       do dim = 1, amrex_spacedim
          c_mf(dim) = mfnew_c(dim)%p
       end do
    else if (abs(time-told_c) .le. teps) then
       ncrse= 1
       c_time(1) =  told_c
       do dim = 1, amrex_spacedim
          c_mf(dim) = mfold_c(dim)%p
       end do
    else
       ncrse= 2
       c_time(1) =  told_c
       c_time(2) =  tnew_c
       do dim = 1, amrex_spacedim
          c_mf(dim)                = mfold_c(dim)%p
          c_mf(dim+amrex_spacedim) = mfnew_c(dim)%p
       end do
    end if

    ! fine level
    teps = 1.e-4_amrex_real * abs(tnew_f - told_f)
    if (abs(time-tnew_f) .le. teps) then
       nfine= 1
       f_time(1) =  tnew_f
       do dim = 1, amrex_spacedim
          f_mf(dim) = mfnew_f(dim)%p
       enddo
    else if (abs(time-told_f) .le. teps) then
       nfine= 1
       f_time(1) =  told_f
       do dim = 1, amrex_spacedim
          f_mf(dim) = mfold_f(dim)%p
       end do
    else
       nfine= 2
       f_time(1) =  told_f
       f_time(2) =  tnew_f
       do dim = 1, amrex_spacedim
          f_mf(dim)                = mfold_f(dim)%p
          f_mf(dim+amrex_spacedim) = mfnew_f(dim)%p
       end do
    end if

    ! lo_bc & hi_bc: (BC dir, comp, MF)
    nc = scomp+ncomp-1
    do mfid = 1, amrex_spacedim
       do i = 1, scomp-1
          lo_bc_ptr((mfid-1)*nc + i) = c_null_ptr
          hi_bc_ptr((mfid-1)*nc + i) = c_null_ptr
       end do
       do i = scomp, nc
          lo_bc_ptr((mfid-1)*nc + i) = c_loc(lo_bc(1,i,mfid))
          hi_bc_ptr((mfid-1)*nc + i) = c_loc(hi_bc(1,i,mfid))
       end do
    end do

    pre_interp_ptr = c_null_funptr
    if (present(pre_interp)) pre_interp_ptr = c_funloc(pre_interp)
    post_interp_ptr = c_null_funptr
    if (present(post_interp)) post_interp_ptr = c_funloc(post_interp)

    ! scomp-1 and dcomp-1 because of Fortran index starts with 1
    call amrex_fi_fillpatch_two_faces(faces, time, c_mf, c_time, ncrse,&
         &                                         f_mf, f_time, nfine,&
         &                            scomp-1, dcomp-1, ncomp,         &
         &                            geom_c%p, geom_f%p,              &
         &                            cfill, ffill,                    &
         &                            rr, interp, lo_bc_ptr, hi_bc_ptr,&
         &                            pre_interp_ptr, post_interp_ptr)
  end subroutine amrex_fillpatch_two_faces


  subroutine amrex_fillcoarsepatch_default (mf, told_c, mfold_c, tnew_c, mfnew_c, &
       &                                    geom_c, fill_physbc_c, geom_f, fill_physbc_f, &
       &                                    time, scomp, dcomp, ncomp, rr, interp, lo_bc, hi_bc, &
       &                                    pre_interp, post_interp)
    type(amrex_multifab), intent(inout) :: mf
    type(amrex_multifab), intent(in   ) :: mfold_c, mfnew_c
    integer, intent(in) :: scomp, dcomp, ncomp, rr, interp
    integer, dimension(amrex_spacedim,scomp+ncomp-1), target, intent(in) :: lo_bc, hi_bc
    real(amrex_real), intent(in) :: told_c, tnew_c, time
    type(amrex_geometry), intent(in) :: geom_c, geom_f
    procedure(amrex_physbc_proc) :: fill_physbc_c, fill_physbc_f
    procedure(amrex_interp_hook_proc), optional :: pre_interp
    procedure(amrex_interp_hook_proc), optional :: post_interp

    real(amrex_real) :: teps
    type(c_ptr) :: c_mf
    type(c_ptr) :: lo_bc_ptr(scomp+ncomp-1), hi_bc_ptr(scomp+ncomp-1)
    type(c_funptr) :: pre_interp_ptr, post_interp_ptr
    integer :: i

    ! coarse level
    teps = 1.e-4_amrex_real * abs(tnew_c - told_c)
    if (abs(time-tnew_c) .le. teps) then
       c_mf = mfnew_c%p
    else if (abs(time-told_c) .le. teps) then
       c_mf = mfold_c%p
    else
       call amrex_abort("amrex_fillcoarsepatch_default: how did this happen?")
    end if

    do i = 1, scomp-1
       lo_bc_ptr(i) = c_null_ptr
       hi_bc_ptr(i) = c_null_ptr
    end do
    do i = scomp, scomp+ncomp-1
       lo_bc_ptr(i) = c_loc(lo_bc(1,i))
       hi_bc_ptr(i) = c_loc(hi_bc(1,i))
    end do

    pre_interp_ptr = c_null_funptr
    if (present(pre_interp)) pre_interp_ptr = c_funloc(pre_interp)
    post_interp_ptr = c_null_funptr
    if (present(post_interp)) post_interp_ptr = c_funloc(post_interp)

    ! scomp-1 and dcomp-1 because of Fortran index starts with 1
    call amrex_fi_fillcoarsepatch(mf%p, time, c_mf, scomp-1, dcomp-1, ncomp, &
         &                        geom_c%p, geom_f%p,              &
         &                        c_funloc(fill_physbc_c),         &
         &                        c_funloc(fill_physbc_f),         &
         &                        rr, interp, lo_bc_ptr, hi_bc_ptr,&
         &                        pre_interp_ptr, post_interp_ptr)
  end subroutine amrex_fillcoarsepatch_default


  subroutine amrex_fillcoarsepatch_faces (mf, told_c, mfold_c, tnew_c, mfnew_c, &
       &                                  geom_c, fill_physbc_cx, &
#if (AMREX_SPACEDIM > 1)
       &                                  fill_physbc_cy, &
#if (AMREX_SPACEDIM > 2)
       &                                  fill_physbc_cz, &
#endif
#endif
       &                                  geom_f, fill_physbc_fx, &
#if (AMREX_SPACEDIM > 1)
       &                                  fill_physbc_fy, &
#if (AMREX_SPACEDIM > 2)
       &                                  fill_physbc_fz, &
#endif
#endif
       &                                  time, scomp, dcomp, ncomp, rr, interp, lo_bc, hi_bc, &
       &                                  pre_interp, post_interp)
    type(amrex_multifab), intent(inout) :: mf(amrex_spacedim)
    type(amrex_multifab), intent(in   ) :: mfold_c(amrex_spacedim), mfnew_c(amrex_spacedim)
    integer, intent(in) :: scomp, dcomp, ncomp, rr, interp
    !                 (BC dir        , comp        , MF)
    integer, dimension(amrex_spacedim,scomp+ncomp-1,amrex_spacedim), target, intent(in) :: lo_bc, hi_bc
    real(amrex_real), intent(in) :: told_c, tnew_c, time
    type(amrex_geometry), intent(in) :: geom_c, geom_f
    procedure(amrex_physbc_proc) :: fill_physbc_cx, fill_physbc_fx
#if (AMREX_SPACEDIM > 1)
    procedure(amrex_physbc_proc) :: fill_physbc_cy, fill_physbc_fy
#endif
#if (AMREX_SPACEDIM > 2)
    procedure(amrex_physbc_proc) :: fill_physbc_cz, fill_physbc_fz
#endif
    procedure(amrex_interp_hook_arr_proc), optional :: pre_interp
    procedure(amrex_interp_hook_arr_proc), optional :: post_interp

    real(amrex_real) :: teps
    type(c_ptr) :: faces(amrex_spacedim)
    type(c_ptr) :: c_mf(amrex_spacedim)
    type(c_funptr) :: cfill(amrex_spacedim), ffill(amrex_spacedim)
    type(c_ptr) :: lo_bc_ptr(amrex_spacedim*(scomp+ncomp-1)), hi_bc_ptr(amrex_spacedim*(scomp+ncomp-1))
    type(c_funptr) :: pre_interp_ptr, post_interp_ptr
    integer :: i, nc, dim, mfid

    cfill(1) = c_funloc(fill_physbc_cx)
    ffill(1) = c_funloc(fill_physbc_fx)
#if (AMREX_SPACEDIM >= 2)
    cfill(2) = c_funloc(fill_physbc_cy)
    ffill(2) = c_funloc(fill_physbc_fy)
#if (AMREX_SPACEDIM >= 3)
    cfill(3) = c_funloc(fill_physbc_cz)
    ffill(3) = c_funloc(fill_physbc_fz)
#endif
#endif

    do dim = 1, amrex_spacedim
       faces(dim) = mf(dim)%p
    end do

    ! coarse level
    teps = 1.e-4_amrex_real * abs(tnew_c - told_c)
    if (abs(time-tnew_c) .le. teps) then
       do dim = 1, amrex_spacedim
          c_mf(dim) = mfnew_c(dim)%p
       end do
    else if (abs(time-told_c) .le. teps) then
       do dim = 1, amrex_spacedim
          c_mf(dim) = mfold_c(dim)%p
       end do
    else
       call amrex_abort("amrex_fillcoarsepatch_faces: how did this happen?")
    end if

    ! lo_bc & hi_bc: (BC dir, comp, MF)
    nc = scomp+ncomp-1
    do mfid = 1, amrex_spacedim
       do i = 1, scomp-1
          lo_bc_ptr((mfid-1)*nc + i) = c_null_ptr
          hi_bc_ptr((mfid-1)*nc + i) = c_null_ptr
       end do
       do i = scomp, nc
          lo_bc_ptr((mfid-1)*nc + i) = c_loc(lo_bc(1,i,mfid))
          hi_bc_ptr((mfid-1)*nc + i) = c_loc(hi_bc(1,i,mfid))
       end do
    end do

    pre_interp_ptr = c_null_funptr
    if (present(pre_interp)) pre_interp_ptr = c_funloc(pre_interp)
    post_interp_ptr = c_null_funptr
    if (present(post_interp)) post_interp_ptr = c_funloc(post_interp)

    ! scomp-1 and dcomp-1 because of Fortran index starts with 1
    call amrex_fi_fillcoarsepatch_faces(faces, time, c_mf, scomp-1, dcomp-1, ncomp, &
         &                              geom_c%p, geom_f%p,              &
         &                              cfill, ffill,                    &
         &                              rr, interp, lo_bc_ptr, hi_bc_ptr,&
         &                              pre_interp_ptr, post_interp_ptr)
  end subroutine amrex_fillcoarsepatch_faces

end module amrex_fillpatch_module
