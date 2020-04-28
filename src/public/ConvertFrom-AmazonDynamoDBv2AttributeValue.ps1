Function ConvertFrom-AmazonDynamoDBv2AttributeValue {
    [cmdletbinding()]
    param (
        [Amazon.DynamoDBv2.Model.AttributeValue]$Value
    )
    if ($value.S) {
        $Value.S
    } elseif ($value.N) {
        [int]$Value.N
    } else {
        $value
    }
}