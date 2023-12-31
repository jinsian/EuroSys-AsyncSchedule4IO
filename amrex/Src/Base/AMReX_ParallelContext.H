#ifndef AMREX_PARALLELCONTEXT_H
#define AMREX_PARALLELCONTEXT_H
#include <AMReX_Config.H>

#include <AMReX_Extension.H>
#include <AMReX_Vector.H>
#include <AMReX_ccse-mpi.H>

#include <iosfwd>
#include <memory>

namespace amrex::ParallelContext {

class Frame
{
public:

    Frame (MPI_Comm c, int id, int io_rank);
    explicit Frame (MPI_Comm c);
    Frame (Frame const&) = delete;
    Frame& operator= (Frame const&) = delete;
    Frame& operator= (Frame &&) = delete;
    Frame (Frame && rhs) noexcept;
    ~Frame ();

    [[nodiscard]] int MyID   () const noexcept { return m_id; }
    [[nodiscard]] int MyProc () const noexcept { return m_rank_me; }
    [[nodiscard]] int NProcs () const noexcept { return m_nranks; }
    [[nodiscard]] int IOProc () const noexcept { return m_io_rank; }
    static int local_to_global_rank (int lrank);
    static void local_to_global_rank (int* global, const int* local, int n);
    static void global_to_local_rank (int* local, const int* global, int n);
    static int global_to_local_rank (int grank);
    int get_inc_mpi_tag ();
    void set_ofs_name (std::string filename);
    std::ofstream * get_ofs_ptr ();

    //! sub-communicator associated with frame
    MPI_Comm comm = MPI_COMM_NULL;
    MPI_Group group = MPI_GROUP_NULL; //!< to avoid repeatedly creating groups in rank translation

private:
    int m_id      = -1; //!< frame ID
    int m_rank_me =  0; //!< local rank
    int m_nranks  =  1; //!< local # of ranks
    int m_mpi_tag = -1;
    int m_io_rank = -1;
    std::string m_out_filename;
    std::unique_ptr<std::ofstream> m_out;
};

extern AMREX_EXPORT Vector<Frame> frames; //!< stack of communicator frames

//! world communicator
inline MPI_Comm CommunicatorAll () noexcept { return frames[0].comm; }
//! world group
inline MPI_Group GroupAll () noexcept { return frames[0].group; }
//! number of ranks in world communicator
inline int NProcsAll () noexcept { return frames[0].NProcs(); }
//! my rank in world communicator
inline int MyProcAll () noexcept { return frames[0].MyProc(); }
//! IO rank in world communicator
inline int IOProcessorNumberAll () noexcept { return frames[0].IOProc(); }
//! Am IO processor for world communicator?
inline bool IOProcessorAll () noexcept { return MyProcAll() == IOProcessorNumberAll(); }
//! Pointer to ofstream
inline std::ofstream * OFSPtrAll () noexcept { return frames[0].get_ofs_ptr(); }

//! sub-communicator for current frame
inline MPI_Comm CommunicatorSub () noexcept { return frames.back().comm; }
//! sub-group for current frame
inline MPI_Group GroupSub () noexcept { return frames.back().group; }
//! number of ranks in current frame
inline int NProcsSub () noexcept { return frames.back().NProcs(); }
//! my sub-rank in current frame
inline int MyProcSub () noexcept { return frames.back().MyProc(); }
//! IO sub-rank in current frame
inline int IOProcessorNumberSub () noexcept { return frames.back().IOProc(); }
//! Am IO processor for current frame?
inline bool IOProcessorSub () noexcept { return MyProcSub() == IOProcessorNumberSub(); }
//! Pointer to ofstream
inline std::ofstream * OFSPtrSub () noexcept { return frames.back().get_ofs_ptr(); }

#ifdef BL_USE_MPI
inline void BarrierSub () noexcept { MPI_Barrier(CommunicatorSub()); }
inline void BarrierAll () noexcept { MPI_Barrier(CommunicatorAll()); }
#else
inline void BarrierSub () noexcept { }
inline void BarrierAll () noexcept { }
#endif

//! get and increment mpi tag in current frame
inline int get_inc_mpi_tag () noexcept { return frames.back().get_inc_mpi_tag(); }
//! translate between local rank and global rank
inline int local_to_global_rank (int rank) noexcept { return Frame::local_to_global_rank(rank); }
inline void local_to_global_rank (int* global, const int* local, int n) noexcept
    { Frame::local_to_global_rank(global, local, n); }
inline int global_to_local_rank (int rank) noexcept { return Frame::global_to_local_rank(rank); }
inline void global_to_local_rank (int* local, const int* global, int n) noexcept
    { Frame::global_to_local_rank(local, global, n); }

inline void push (MPI_Comm c) { frames.emplace_back(c); }
inline void push (MPI_Comm c, int id, int io_rank) { frames.emplace_back(c, id, io_rank); }
inline void set_last_frame_ofs (const std::string & filename) {
    frames.back().set_ofs_name(filename);
}
//! Note that it's the user's responsibility to free the MPI_Comm
inline void pop () { frames.pop_back(); }

}

#endif // AMREX_PARALLELCONTEXT_H
