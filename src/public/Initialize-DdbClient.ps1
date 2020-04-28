Function Initialize-DdbClient {
    [cmdletbinding()]
    param (
        [string]$TableName
    )
    $global:ddbClient = [Amazon.DynamoDBv2.AmazonDynamoDBClient]::new()
    $global:table = [Amazon.DynamoDBv2.DocumentModel.Table]::LoadTable($ddbClient, $TableName)
}