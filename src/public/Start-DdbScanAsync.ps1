#https://docs.aws.amazon.com/sdkfornet/v3/apidocs/items/DynamoDBv2/MDynamoDBScanAsyncScanRequestCancellationToken.html
function Start-DdbScanAsync {
    [cmdletbinding()]
    param (
        [Parameter(ParameterSetName="TableName", ValueFromPipeline=$true, Mandatory=$true)]
        $tableName,
        [Parameter(ParameterSetName="Conditions")]
        $conditions
    )

    Begin {
        <# Example declarations for conditions
        $conditions=New-Object System.Collections.Generic.Dictionary"[String,Amazon.DynamoDBv2.Model.Condition]"
        $condition=New-Object Amazon.DynamoDBv2.Model.condition
        #>
        $request=New-Object Amazon.DynamoDBv2.Model.ScanRequest
        $client=New-Object Amazon.DynamoDBv2.AmazonDynamoDBClient
    }

    Process {
        <# Simple example condition of key "active"=="true"
        $condition.AttributeValueList=@(@{"BOOL"="true"})
        $condition.ComparisonOperator="EQ"
        $conditions.Add("active",$condition)
        #>
        
        $request.TableName=$tableName
        if ($PSBoundParameters.ContainsKey("conditions")) { $request.ScanFilter=$conditions }

        $results=Wait-Task -task $client.ScanAsync($request)
        return $results
    }
}