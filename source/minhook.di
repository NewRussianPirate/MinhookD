module minhook;

import core.sys.windows.windows;

enum MH_STATUS
{
    MH_UNKNOWN = -1,

    /// Successful.
    MH_OK = 0,

    /// MinHook is already initialized.
    MH_ERROR_ALREADY_INITIALIZED,

    /// MinHook is not initialized yet, or already uninitialized.
    MH_ERROR_NOT_INITIALIZED,

    /// The hook for the specified target function is already created.
    MH_ERROR_ALREADY_CREATED,

    /// The hook for the specified target function is not created yet.
    MH_ERROR_NOT_CREATED,

    /// The hook for the specified target function is already enabled.
    MH_ERROR_ENABLED,

    /// The hook for the specified target function is not enabled yet, or already
    /// disabled.
    MH_ERROR_DISABLED,

    /// The specified pointer is invalid. It points the address of non-allocated
    /// and/or non-executable region.
    MH_ERROR_NOT_EXECUTABLE,

    /// The specified target function cannot be hooked.
    MH_ERROR_UNSUPPORTED_FUNCTION,

    /// Failed to allocate memory.
    MH_ERROR_MEMORY_ALLOC,

    /// Failed to change the memory protection.
    MH_ERROR_MEMORY_PROTECT,

    /// The specified module is not loaded.
    MH_ERROR_MODULE_NOT_FOUND,

    /// The specified function is not found.
    MH_ERROR_FUNCTION_NOT_FOUND
}

/// Initialize the MinHook library. You must call this function EXACTLY ONCE
/// at the beginning of your program.
extern(C) MH_STATUS MH_Initialize();

/// Uninitialize the MinHook library. You must call this function EXACTLY
/// ONCE at the end of your program.
extern(C) MH_STATUS MH_Uninitialize();

/// Creates a hook for the specified target function, in disabled state.
/// Params:
/// pTarget = [in]  A pointer to the target function, which will be
///                    overridden by the detour function.
/// pDetour = [in]  A pointer to the detour function, which will override
///                     the target function.
/// ppOriginal = [out] A pointer to the trampoline function, which will be
///                     used to call the original target function.
///                     This parameter can be NULL.
extern(C) MH_STATUS MH_CreateHook(LPVOID pTarget, LPVOID pDetour, LPVOID *ppOriginal);

/// Creates a hook for the specified API function, in disabled state.
/// Params:
///   pszModule  =  [in]  A pointer to the loaded module name which contains the
///                     target function.
///   pszProcName = [in]  A pointer to the target function name, which will be
///                     overridden by the detour function.
///   pDetour = [in]  A pointer to the detour function, which will override
///                     the target function.
///   ppOriginal = [out] A pointer to the trampoline function, which will be
///                     used to call the original target function.
///                     This parameter can be NULL.
extern(C) MH_STATUS MH_CreateHookApi(LPCWSTR pszModule, LPCSTR pszProcName, LPVOID pDetour, LPVOID *ppOriginal);

/// Creates a hook for the specified API function, in disabled state.
/// Params:
///   pszModule = [in]  A pointer to the loaded module name which contains the
///                     target function.
///   pszProcName = [in]  A pointer to the target function name, which will be
///                     overridden by the detour function.
///   pDetour = [in]  A pointer to the detour function, which will override
///                     the target function.
///   ppOriginal = [out] A pointer to the trampoline function, which will be
///                     used to call the original target function.
///                     This parameter can be NULL.
///   ppTarget = [out] A pointer to the target function, which will be used
///                     with other functions.
///                     This parameter can be NULL.
extern(C) MH_STATUS MH_CreateHookApiEx(LPCWSTR pszModule, LPCSTR pszProcName, LPVOID pDetour, LPVOID *ppOriginal, LPVOID *ppTarget);

/// Removes an already created hook.
/// Params:
///   pTarget = [in] A pointer to the target function.
extern(C) MH_STATUS MH_RemoveHook(LPVOID pTarget);

/// Enables an already created hook.
/// Params:
///   pTarget = [in] A pointer to the target function.
///                If this parameter is MH_ALL_HOOKS, all created hooks are
///                enabled in one go.
extern(C) MH_STATUS MH_EnableHook(LPVOID pTarget);

/// Disables an already created hook.
/// Params:
///   pTarget = [in] A pointer to the target function.
///                If this parameter is MH_ALL_HOOKS, all created hooks are
///                disabled in one go.
extern(C) MH_STATUS MH_DisableHook(LPVOID pTarget);

/// Queues to enable an already created hook.
/// Params:
///   pTarget = [in] A pointer to the target function.
///                If this parameter is MH_ALL_HOOKS, all created hooks are
///                queued to be enabled.
extern(C) MH_STATUS MH_QueueEnableHook(LPVOID pTarget);

/// Queues to disable an already created hook.
/// Params:
///   pTarget = [in] A pointer to the target function.
///                If this parameter is MH_ALL_HOOKS, all created hooks are
///                queued to be disabled.
extern(C) MH_STATUS MH_QueueDisableHook(LPVOID pTarget);

/// Applies all queued changes in one go.
extern(C) MH_STATUS MH_ApplyQueued();

/// Translates the MH_STATUS to its name as a string.
extern(C) const(char*) MH_StatusToString(MH_STATUS status);