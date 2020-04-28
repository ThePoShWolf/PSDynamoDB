Function Get-DdbTableItem {
    [cmdletbinding()]
    param (
        [string]$HashKey,
        [string]$RangeKey
    )
    if ($PSBoundParameters.Keys -contains 'RangeKey' ){
        [System.Threading.Tasks.Task]$task = $table.GetItemAsync([Amazon.DynamoDBv2.DocumentModel.Primitive]::new($HashKey),[Amazon.DynamoDBv2.DocumentModel.Primitive]::new($RangeKey))
    } else {
        [System.Threading.Tasks.Task]$task = $table.GetItemAsync([Amazon.DynamoDBv2.DocumentModel.Primitive]::new($HashKey))
    }
    $task.Wait()
    $task.Result
}