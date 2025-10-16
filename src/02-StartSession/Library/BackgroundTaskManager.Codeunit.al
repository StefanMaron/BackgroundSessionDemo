/// <summary>
/// Lightweight task manager for running codeunits in parallel using StartSession.
/// No database writes - uses Session.IsSessionActive() to check completion.
/// Works with any codeunit - no special requirements.
/// </summary>
codeunit 50110 "Background Task Manager"
{
    /// <summary>
    /// Starts a codeunit in a background session
    /// </summary>
    /// <param name="CodeunitId">The codeunit to run in background</param>
    /// <param name="RecordVariant">Record parameter to pass to the codeunit</param>
    /// <returns>Session ID</returns>
    procedure StartTask(CodeunitId: Integer; RecordVariant: Variant): Integer
    var
        SessionId: Integer;
    begin
        if not StartSession(SessionId, CodeunitId, CompanyName(), RecordVariant) then
            Error(SessionStartFailedErr);

        SessionIds.Add(SessionId);
        exit(SessionId);
    end;

    procedure StartTask(CodeunitId: Integer): Integer
    var
        SessionId: Integer;
    begin
        if not StartSession(SessionId, CodeunitId, CompanyName()) then
            Error(SessionStartFailedErr);

        SessionIds.Add(SessionId);
        exit(SessionId);
    end;


    /// <summary>
    /// Waits for all started sessions to complete
    /// </summary>
    /// <param name="TimeoutMs">Maximum time to wait in milliseconds</param>
    /// <returns>True if all sessions completed, false if timeout</returns>
    procedure WaitAll(TimeoutMs: Integer): Boolean
    var
        StartTime: DateTime;
        SessionId: Integer;
        AllCompleted: Boolean;
        SessionActive: Boolean;
    begin
        StartTime := CurrentDateTime();

        repeat
            AllCompleted := true;

            foreach SessionId in SessionIds do begin
                SessionActive := Session.IsSessionActive(SessionId);
                if SessionActive then
                    AllCompleted := false;
            end;

            if not AllCompleted then
                Sleep(100); // Poll every 100ms

        until AllCompleted or (CurrentDateTime() - StartTime > TimeoutMs);

        exit(AllCompleted);
    end;

    /// <summary>
    /// Clears all tracked sessions
    /// </summary>
    procedure ClearAll()
    begin
        Clear(SessionIds);
    end;

    /// <summary>
    /// Gets the list of session IDs that were started
    /// </summary>
    /// <returns>List of session IDs</returns>
    procedure GetSessionIds(): List of [Integer]
    begin
        exit(SessionIds);
    end;

    var
        SessionIds: List of [Integer];
        SessionStartFailedErr: Label 'Failed to start background session.';
}
