# PSDynamoDB
A quick and dirty PowerShell module to talk to Amazon's DynamoDBs

## Prerequisites
Make sure you have the [AWS PowerShell module](https://docs.aws.amazon.com/powershell/latest/userguide/pstools-welcome.html) installed. At least the AWS.Tools module with DynamoDBv2.

```powershell
Install-Module AWS.Tools.Installer
Install-AWSToolsModule DynamoDBv2
```

[Configure your AWS credentials](https://docs.aws.amazon.com/powershell/latest/userguide/specifying-your-aws-credentials.html).

```powershell
Set-AWSCredential -AccessKey 'blah' -SecretKey 'blah' -StoreAs MyNewProfile
Initial-AWSDefaultConfiguration -ProfileName MyNewProfile -Region us-west-2
```

## Setup

Install from the PSGallery:

```powershell
Install-Module PSDynamoDB
```

## Usage

Initialize the DynamoDB Client:

```powershell
Initialize-DdbClient -TableName 'TableName'
```

Create a new item:

```powershell
New-DdbTableItem @{'FirstName'='Anthony';'LastName'='Howell';Data = '{"PowerShell":true,"OnTwitter":"@theposhwolf"}'}
```

Get that item:

```powershell
Get-DdbTableItem -HashKey 'Anthony' -RangeKey 'Howell'
```

## Warning

This module was quickly thrown together to support a POC. If it pans out, I will be developing this further. If not, then this may orphaned. Feel free to fork and/or contribute.

## Additional Notes

You can create and manage tables using the AWS.Tools.DynamoDBv2 module.