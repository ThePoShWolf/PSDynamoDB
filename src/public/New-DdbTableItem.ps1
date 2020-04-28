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
                $attribMap.Add($key,$AttributeMap[$key])
            }
            $doc = [Amazon.DynamoDBv2.DocumentModel.Document]::FromAttributeMap($attribMap)
        }
    }
    [System.Threading.Tasks.Task]$task = $table.PutItemAsync($doc)
    $task.Wait()
    $task.Result
}