#https://stackoverflow.com/questions/51218257/await-async-c-sharp-method-from-powershell
function Wait-Task {
    [cmdletbinding()]
    param (
        [Parameter(ValueFromPipeline=$true, Mandatory=$true)]
        $task
    )

    process {
        while (-not $task.AsyncWaitHandle.WaitOne(100)) { }
        return $task.GetAwaiter().GetResult()
    }
}