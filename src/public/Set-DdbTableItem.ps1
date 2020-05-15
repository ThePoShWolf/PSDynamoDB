Function Set-DdbTableItem {
    [cmdletbinding()]
    param (
        <#[Parameter(
            ParameterSetName = 'ByJson'
        )]
        [string]$Json,#>
        [Parameter(
            ParameterSetName = 'ByAttribMap'
        )]
        [hashtable]$AttributeMap,
        [string]$Key
    )
    switch($PSCmdlet.ParameterSetName) {
        <#'ByJson' {
            $doc = [Amazon.DynamoDBv2.DocumentModel.Document]::FromJson($json)
        }#>
        'ByAttribMap' {
            $attribUpdates = New-Object 'System.Collections.Generic.Dictionary[string,Amazon.DynamoDBv2.Model.AttributeValueUpdate]'
            foreach ($htkey in $AttributeMap.Keys) {
                $attribValue = [Amazon.DynamoDBv2.Model.AttributeValue]::new()
                # needs support for other value types
                if ($AttributeMap[$htkey] -is [int]) {
                    $attribValue.N = $AttributeMap[$htkey]
                } else {
                    $attribValue.S = $AttributeMap[$htkey]
                }
                
                $attribUpdates.Add($htkey,[Amazon.DynamoDBv2.Model.AttributeValueUpdate]::new($attribValue,'PUT'))
            }
        }
    }

    # Currently only supports tables with a single hash key name
    $keys = New-Object 'System.Collections.Generic.Dictionary[string,Amazon.DynamoDBv2.Model.AttributeValue]'
    $keys.Add($table.HashKeys[0],$Key)
    
    [System.Threading.Tasks.Task]$task = $ddbClient.UpdateItemAsync($table.TableName,$keys,$attribUpdates)
    $task.Wait()
    $task.Result
}