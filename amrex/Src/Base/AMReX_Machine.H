#ifndef AMREX_MACHINE_H
#define AMREX_MACHINE_H
#include <AMReX_Config.H>

#include <AMReX_Vector.H>

namespace amrex::machine {

void Initialize (); //!< called in amrex::Initialize()

#ifdef AMREX_USE_MPI
void Finalize ();
/**
* find the best topologically close neighborhood of ranks
* returns a vector of global or local rank IDs based on flag_local_ranks
*/
Vector<int> find_best_nbh (int rank_n, bool flag_local_ranks = false);
#endif

}

#endif
