#ifndef AMREX_EB2_IF_ALL_REGULAR_H_
#define AMREX_EB2_IF_ALL_REGULAR_H_
#include <AMReX_Config.H>

#include <AMReX_Array.H>
#include <AMReX_EB2_IF_Base.H>

namespace amrex::EB2 {

// For all implicit functions, >0: body; =0: boundary; <0: fluid

class AllRegularIF
    : public GPUable
{
public:
    constexpr Real operator() (const RealArray&) const noexcept { return -1.0; }

    constexpr Real operator() (AMREX_D_DECL(Real, Real, Real)) const noexcept { return -1.0; }
};

}

#endif
