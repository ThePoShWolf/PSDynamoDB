Function New-DdbTableItem {
    [cmdletbinding()]
    param (
        [Parameter(
            ParameterSetName = 'ByJson'
        )]
        [string]$Json,
        [Parameter(
            ParameterSetName = 'ByAttribMap'
        )]
        [hashtable]$AttributeMap
    )
    switch($PSCmdlet.ParameterSetName) {
        'ByJson' {
            $doc = [Amazon.DynamoDBv2.DocumentModel.Document]::FromJson($json)
        }
        'ByAttribMap' {
            $attribMap = New-Object 'System.Collections.Generic.Dictionary[string,Amazon.DynamoDBv2.Model.AttributeValue]'
            foreach ($key in $AttributeMap.Keys) {
                $attribValue = [Amazon.DynamoDBv2.Model.AttributeValue]::new()
                if ($AttributeMap[$key].GetType().Name -like 'Int*') {
                    $attribValue.N = $AttributeMap[$key]
                } else {
                    $attribValue.S = $AttributeMap[$key]
                }
                $attribMap.Add($key,$attribValue)
            }
            $doc = [Amazon.DynamoDBv2.DocumentModel.Document]::FromAttributeMap($attribMap)
        }
    }
    [System.Threading.Tasks.Task]$task = $table.PutItemAsync($doc)
    $task.Wait()
    $task.Result
}