Function Get-DdbTableItem {
    [cmdletbinding(
        DefaultParameterSetName = 'Single'
    )]
    param (
        [Parameter(
            Mandatory,
            ParameterSetName = 'Single'
        )]
        [Parameter(
            ParameterSetName = 'IndexQuery'
        )]
        [string]$HashKey,
        [Parameter(
            ParameterSetName = 'Single'
        )]
        [string]$RangeKey,
        [Parameter(
            ParameterSetName = 'IndexQuery'
        )]
        [string]$IndexName,
        [Parameter(
            ParameterSetName = 'IndexQuery'
        )]
        [int]$Limit,
        [Parameter(
            ParameterSetName = 'IndexQuery'
        )]
        [bool]$ScanIndexForward = $true
    )
    if ($PSCmdlet.ParameterSetName -eq 'Single') {
        if ($PSBoundParameters.Keys -contains 'RangeKey' ){
            $task = $table.GetItemAsync([Amazon.DynamoDBv2.DocumentModel.Primitive]::new($HashKey),[Amazon.DynamoDBv2.DocumentModel.Primitive]::new($RangeKey))
        } else {
            $task = $table.GetItemAsync([Amazon.DynamoDBv2.DocumentModel.Primitive]::new($HashKey))
        }
        $task.Wait()
        $htArr = $task.Result
        $ht = @{}
        foreach ($item in $htArr) {
            $ht[$item.Key] = switch ($item.Value.Type) {
                'Numeric' { [int]$item.Value.Value }
                default { $item.Value.Value }
            }
        }
        $ht
    } else {
        # Find the name of the hashkey
        $hashKeyName = ($table.GlobalSecondaryIndexes[$IndexName].KeySchema | ?{$_.KeyType -eq 'HASH'}).AttributeName

        $req = [Amazon.DynamoDBv2.Model.QueryRequest]::new()

        # Really simple condition, hashkey = $hashkey
        # This can be expanded
        $condition = [Amazon.DynamoDBv2.Model.Condition]::new()
        $condition.AttributeValueList.Add($HashKey)
        $condition.ComparisonOperator = [Amazon.DynamoDBv2.ComparisonOperator]::EQ
        $req.KeyConditions.Add($hashKeyName,$condition)

        # Other parameters
        $req.IndexName = $IndexName
        $req.ScanIndexForward = $ScanIndexForward
        $req.Limit = $Limit

        # Since we are using the ddbClient to query, gotta specify tablename
        $req.TableName = $table.TableName

        # Query
        $task = $ddbClient.QueryAsync($req)
        $task.Wait()
        
        # Convert
        foreach ($item in $task.Result.Items) {
            $ht = @{}
            foreach ($key in $item.Keys) {
                $ht[$key] = ConvertFrom-AmazonDynamoDBv2AttributeValue $item[$key]
            }
            $ht
        }
    }
}